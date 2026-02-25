# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Docker do
  let(:subject) { Rouge::Lexers::Docker.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Dockerfile'
      assert_guess :filename => 'docker.docker'
      assert_guess :filename => 'some.Dockerfile'
      assert_guess :filename => 'Dockerfile.some'
      assert_guess :filename => 'Containerfile'
      assert_guess :filename => 'some.Containerfile'
      assert_guess :filename => 'Containerfile.some'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-dockerfile-config'
    end
  end
end
