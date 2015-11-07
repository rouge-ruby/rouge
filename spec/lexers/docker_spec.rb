# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Docker do
  let(:subject) { Rouge::Lexers::Docker.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Dockerfile'
      assert_guess :filename => 'docker.docker'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-dockerfile-config'
    end

    it 'guess by source' do
      assert_guess :source => 'FROM scratch'
      assert_guess :source => <<-source
maintainer First O'Last

run echo \
  123 $bar
# comment
      source
    end
  end
end
