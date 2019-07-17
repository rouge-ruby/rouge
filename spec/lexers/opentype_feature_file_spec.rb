# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::OpenTypeFeatureFile do
  let(:subject) { Rouge::Lexers::OpenTypeFeatureFile.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.fea'
    end

  end
end
