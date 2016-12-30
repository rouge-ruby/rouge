# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Wollok do
  let(:subject) { Rouge::Lexers::Ruby.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.wlk'
      assert_guess :filename => 'foo.wtest'
      assert_guess :filename => 'foo.wpgm'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'method calling' do

      it 'handles whitespace between the receiver and the method' do
        assert_tokens_equal "class Content {
	var name

	constructor(aName) {
		name = aName
	}

	method isLight() {
		return self.size() > 150 * 1024 ** 2
	}

	method canBeUploadedTo(aRepo) {
		return aRepo.canUpload(self)
	}

	method longName() {
		return name.length()
	}
}", ['Name', 'foo'],
                            ['Text', "\n  "],
                            ['Punctuation', '.'],
                            ['Name.Function', 'bar'],
                            ['Punctuation', '()']
      end


    end

  end
end
