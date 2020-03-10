# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Apex do
  let(:subject) { Rouge::Lexers::Apex.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cls', :source => '// A comment'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-apex'
    end
  end
end
