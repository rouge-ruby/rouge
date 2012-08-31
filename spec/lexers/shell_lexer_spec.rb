describe Rouge::Lexers::ShellLexer do
  let(:subject) { Rouge::Lexers::ShellLexer }

  it 'parses a basic shell string' do
    tokens = subject.get_tokens('foo=bar')
    assert { tokens.size == 3 }
    assert { tokens[0][0].name == 'Name.Variable' }
  end

  it 'parses /etc/bash.bashrc' do
    source = File.read('/etc/bash.bashrc')
    tokens = subject.get_tokens(source)
    assert { tokens } # TODO: make this stricter
  end
end
