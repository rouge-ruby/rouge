# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::MetaPost do
    let(:subject) { Rouge::Lexers::MetaPost.new }
  
    describe 'guessing' do
      include Support::Guessing
  
      it 'guesses by filename' do
        assert_guess :filename => 'foo.mp'
      end
  
      it 'guesses by mimetype' do
        assert_guess :mimetype => 'text/x-metapost'
        assert_guess :mimetype => 'application/x-metapost'
      end
    end
  end