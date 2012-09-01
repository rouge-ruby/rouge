describe Rouge::Formatters::HTML do
  let(:subject) { Rouge::Formatters::HTML.new }
  Token = Rouge::Token

  it 'formats a simple token stream' do
    out = subject.render([[Token['Name'], 'foo']])
    assert { out == '<pre class="highlight"><span class="n">foo</span></pre>' }
  end
end
