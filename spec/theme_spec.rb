# -*- coding: utf-8 -*- #

describe Rouge::Theme do
  def squish(str)
    str.strip.gsub(/\s+/, ' ')
  end

  class MyTheme < Rouge::CSSTheme
    style Literal::String, :fg => '#003366', :bold => true
    style Literal::String::Backtick, :fg => '#555555', :italic => true
  end

  let(:theme) { MyTheme.new }

  it 'auto-fills css classes' do
    rendered = theme.render

    # should also style, for example, String.Char
    assert { rendered =~ /\.sc/ }

    # and it should only style String.Backtick once
    assert { rendered =~ /\.sb/ }
    assert { $~.size == 1 }
  end

  it 'renders a style' do
    output = Rouge::Theme::Style[:bold => true].render('.foo')
    expected = <<-css
      .foo {
        font-weight: bold;
      }
    css

    assert { squish(output) == squish(expected) }
  end

  it 'fetches a style for a token' do
    style = theme.style_for(Rouge::Token['Literal.String'])
    assert { style == { :fg => '#003366', :bold => true } }
  end

  it 'fetches a the closest style for a token' do
    style = theme.style_for(Rouge::Token['Literal.String.Backtick'])
    assert { style == { :fg => '#555555', :italic => true } }
  end

  it 'fetches style from ancestor token when no style is defined' do
    style = theme.style_for(Rouge::Token['Literal.String.Char'])
    assert { style == { :fg => '#003366', :bold => true } }
  end
end
