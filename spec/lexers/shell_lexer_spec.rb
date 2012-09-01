describe Rouge::Lexers::ShellLexer do
  let(:subject) { Rouge::Lexers::ShellLexer.new }

  def assert_no_errors(text)
    tokens = subject.get_tokens(text)

    errors = tokens.select do |(tok, val)|
      tok.name.include? 'Error'
    end

    assert { errors.empty? }

    tokens
  end

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

  it 'parses case statements correctly' do
    assert_no_errors <<-sh
      case $foo in
        a) echo "LOL" ;;
      esac
    sh
  end

  # pending
  # it 'parses case statement with globs correctly' do
  #   assert_no_errors <<-sh
  #     case $foo in
  #       a[b]) echo "LOL" ;;
  #     esac
  #   sh
  # end
end
