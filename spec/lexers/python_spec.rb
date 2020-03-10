# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Python do
  let(:subject) { Rouge::Lexers::Python.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.py'
      assert_guess :filename => 'foo.pyw'
      assert_guess :filename => '*.sc', :source => '# A comment'
      assert_guess :filename => 'SConstruct'
      assert_guess :filename => 'SConscript'
      assert_guess :filename => 'foo.tac'
      assert_guess :filename => 'foo.bzl'
      assert_guess :filename => 'BUCK'
      assert_guess :filename => 'BUILD'
      assert_guess :filename => 'BUILD.bazel'
      assert_guess :filename => 'WORKSPACE'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-python'
      assert_guess :mimetype => 'application/x-python'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env python'
      assert_guess :source => '#!/usr/bin/python2'
      assert_guess :source => '#!/usr/bin/python2.7'
      assert_guess :source => '#!/usr/local/bin/python3'
      assert_guess :source => '#!/usr/local/bin/python3.5'
      assert_guess :source => '#!/usr/local/bin/python3.14'
      deny_guess   :source => '#!/usr/bin/env python4'
    end
  end
end
