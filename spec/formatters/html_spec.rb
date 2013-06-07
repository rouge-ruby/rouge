describe Rouge::Formatters::HTML do
  let(:subject) { Rouge::Formatters::HTML.new }
  Token = Rouge::Token

  it 'formats a simple token stream' do
    out = subject.format([[Token['Name'], 'foo']])
    assert { out == '<pre class="highlight"><span class="n">foo</span></pre>' }
  end

  it 'skips <pre> wrapper' do
    formatter = Rouge::Formatters::HTML.new(:wrap => false)
    out = formatter.format([[Token['Name'], 'foo']])
    assert { out == '<span class="n">foo</span>' }
  end
end
