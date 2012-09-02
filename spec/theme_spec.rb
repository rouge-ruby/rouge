describe Rouge::Theme do
  def squish(str)
    str.strip.gsub(/\s+/, ' ')
  end

  it 'auto-fills css classes' do
    class MyTheme < Rouge::CSSTheme
      style 'Literal.String', :bold => true
      style 'Literal.String.Backtick', :italic => true
    end

    rendered = MyTheme.new.render

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
end
