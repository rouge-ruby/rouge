# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GlimmerJs do
  let(:subject) { Rouge::Lexers::GlimmerJs.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gjs'
      assert_guess :filename => 'component.gjs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gjs'
      assert_guess :mimetype => 'application/x-gjs'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes JavaScript code outside template blocks' do
      assert_has_token 'Keyword', 'import Component from "@glimmer/component";'
      assert_has_token 'Name.Class', 'export default class MyComponent extends Component {'
    end

    it 'lexes template blocks' do
      code = <<~GJS
        export default class MyComponent extends Component {
          <template>
            <div>Hello {{@name}}</div>
          </template>
        }
      GJS
      
      assert_has_token 'Name.Tag', code
      assert_has_token 'Literal.String.Interpol', code
    end
  end
end
