describe Rouge::Lexers::HTML do
  let(:lexer) { Rouge::Lexers::HTML.new }
  it 'lexes embedded script tags' do
    result = lexer.lex('<script>x && x < y;</script>').to_a
    errors = result.select { |(t, _)| t.name == 'Error' }
    assert { errors.empty? }
  end
end
