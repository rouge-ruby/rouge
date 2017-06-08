# -*- coding: utf-8 -*- #

describe Rouge::Lexers::ConsoleLexer do
  let(:subject) { Rouge::Lexers::ConsoleLexer.new }

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes multilines which end with $' do
      assert_tokens_equal "--foo \\\n--bar $",
        ["Generic.Prompt", "--foo \\\n--bar $"]
    end
  end
end
