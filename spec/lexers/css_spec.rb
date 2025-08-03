# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::CSS do
  let(:subject) { Rouge::Lexers::CSS.new }

  describe 'guessing' do
    include Support::Guessing
    it 'guesses by filename' do
      assert_guess :filename => 'foo.css'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/css'
    end
  end

  describe 'nested CSS rules' do
    it 'should highlight nested selectors correctly' do
      nested_css = <<~CSS
        .container {
          width: 100%;
          
          .header {
            font-size: 2em;
            
            .title {
              font-weight: bold;
            }
          }
          
          &:hover {
            background-color: #f0f0f0;
          }
          
          &.active {
            border: 2px solid red;
          }
        }
      CSS

      tokens = subject.lex(nested_css).to_a

      # Check that nested selectors are properly tokenized as Name::Tag
      nested_selectors = tokens.select { |token, _| token == Rouge::Token::Tokens::Name::Tag }
      nested_selector_texts = nested_selectors.map(&:last)

      assert nested_selector_texts.include?('.header ')
      assert nested_selector_texts.include?('.title ')
      assert nested_selector_texts.include?('&:hover ')
      assert nested_selector_texts.include?('&.active ')

      # Check that properties are still correctly tokenized
      properties = tokens.select { |token, _| token == Rouge::Token::Tokens::Name::Label }
      property_texts = properties.map(&:last)

      assert property_texts.include?('width')
      assert property_texts.include?('font-size')
      assert property_texts.include?('font-weight')
      assert property_texts.include?('background-color')
      assert property_texts.include?('border')
    end

    it 'should handle deeply nested CSS rules' do
      deep_nested_css = <<~CSS
        .level1 {
          color: black;
          
          .level2 {
            color: blue;
            
            .level3 {
              color: red;
              
              .level4 {
                color: green;
              }
            }
          }
        }
      CSS

      tokens = subject.lex(deep_nested_css).to_a

      # Check that all levels of nesting are recognized
      nested_selectors = tokens.select { |token, _| token == Rouge::Token::Tokens::Name::Tag }
      nested_selector_texts = nested_selectors.map(&:last)

      assert nested_selector_texts.include?('.level2 ')
      assert nested_selector_texts.include?('.level3 ')
      assert nested_selector_texts.include?('.level4 ')
    end

    it 'should handle nested CSS within @media queries' do
      media_nested_css = <<~CSS
        @media (max-width: 768px) {
          .container {
            padding: 10px;
            
            .header {
              font-size: 1.5em;
            }
          }
        }
      CSS

      tokens = subject.lex(media_nested_css).to_a

      # Check that @media is recognized as keyword
      media_tokens = tokens.select { |token, _| token == Rouge::Token::Tokens::Keyword }
      media_texts = media_tokens.map(&:last)
      assert media_texts.include?('@media')

      # Check that nested selectors within media query work
      nested_selectors = tokens.select { |token, _| token == Rouge::Token::Tokens::Name::Tag }
      nested_selector_texts = nested_selectors.map(&:last)
      assert nested_selector_texts.include?('.header ')
    end
  end
end
