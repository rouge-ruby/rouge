describe Rouge::Lexers::Slim do
  let(:subject) { Rouge::Lexers::Slim.new }
  include Support::Lexing

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.slim'
      assert_guess :filename => 'foo.html.slim'
    end

    it 'guesses by source' do
      assert_guess :source => 'doctype html'
      assert_guess :source => <<-source
doctype html
html
  head
    title Slim

  body
    h1 Sample Document
source
    end
  end
end
