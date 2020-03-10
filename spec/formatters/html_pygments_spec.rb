# frozen_string_literal: true

describe Rouge::Formatters::HTMLPygments do
  let(:formatter) { Rouge::Formatters::HTML.new }
  let(:source) { 'echo "Hello World"' }
  let(:lexer) { Rouge::Lexers::Shell.new }
  let(:subject) { Rouge::Formatters::HTMLPygments.new(formatter, lexer.tag) }
  let(:output) { subject.format(lexer.lex(source)) }

  it 'wrap with div.highlight' do
    assert { output =~ /\A<div class="highlight">.+<\/div>\Z/ }
  end

  it 'contain pre with class name "shell"' do
    assert { output =~ /<pre class="shell">/ }
  end
end
