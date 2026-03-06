# frozen_string_literal: true

describe Rouge::Lexers::SysML do
  let(:subject) { Rouge::Lexers::SysML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sysml'
      assert_guess :filename => 'bar.kerml'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-sysml'
      assert_guess :mimetype => 'application/x-sysml'
    end

    it 'guesses by source' do
      assert_guess :source => 'package "My Package" { part def MyPart; requirement MyReq; }'
    end
  end
end
