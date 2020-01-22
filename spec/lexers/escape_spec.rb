describe Rouge::Lexers::Escape do
  let(:lexer) { Rouge::Lexers::Escape.new(lang: 'json') }
  let(:text) { '{ "foo": <!<bar>!> }' }
  let(:result) {
    Rouge::Formatter.with_escape do
      formatter.format(lexer.lex(text))
    end
  }

  describe 'html' do
    let(:formatter) { Rouge::Formatters::HTML.new }

    it 'unescapes' do
      assert { result =~ /<bar>/ }
    end
  end

  describe 'terminal256' do
    let(:formatter) { Rouge::Formatters::Terminal256.new }
    let(:text) { %({ "foo": \n <!\e123!> }) }

    it 'unescapes' do
      assert { result =~ /\e123/ }

      # shouldn't escape the term codes around \n
      assert { result =~ /\n\e/ }
    end
  end
end
