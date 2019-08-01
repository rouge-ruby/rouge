# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Lasso do
  let(:subject) { Rouge::Lexers::Lasso.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.lasso'
      assert_guess :filename => 'foo.lasso8'
      assert_guess :filename => 'foo.lasso9'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-lasso'
      assert_guess :mimetype => 'application/x-httpd-lasso'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env lasso9'
      assert_guess :source => '<?lasso define today => date ?>'
    end
  end
end
