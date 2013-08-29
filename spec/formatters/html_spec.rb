describe Rouge::Formatters::HTML do
  let(:subject) { Rouge::Formatters::HTML.new(options) }
  let(:options) { {} }
  Token = Rouge::Token

  it 'formats a simple token stream' do
    out = subject.format([[Token['Name'], 'foo']])
    assert { out == '<pre class="highlight"><span class="n">foo</span></pre>' }
  end

  describe 'skipping the wrapper' do
    let(:options) { { :wrap => false } }
    let(:output) { subject.format([[Token['Name'], 'foo']]) }

    it 'skips the wrapper' do
      assert { output == '<span class="n">foo</span>' }
    end
  end

  describe '#inline_theme' do
    class InlineTheme < Rouge::CSSTheme
      style Name, :bold => true
    end

    let(:options) { { :inline_theme => InlineTheme.new, :wrap => false } }

    let(:output) {
      subject.format([[Token['Name'], 'foo']])
    }

    it 'inlines styles given a theme' do
      assert { output == '<span style="font-weight: bold">foo</span>' }
    end
  end
end
