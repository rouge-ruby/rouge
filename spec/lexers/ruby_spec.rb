describe Rouge::Lexers::Ruby do
  let(:subject) { Rouge::Lexers::Ruby.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.rb'
      assert_guess :filename => 'foo.ruby'
      assert_guess :filename => 'foo.rbw'
      assert_guess :filename => 'foo.gemspec'
      assert_guess :filename => 'Rakefile'
      assert_guess :filename => 'Guardfile'
      assert_guess :filename => 'Gemfile'
      assert_guess :filename => 'foo.rake'
      assert_guess :filename => 'Capfile'
      assert_guess :filename => 'Vagrantfile'
      assert_guess :filename => 'config.ru'
      assert_guess :filename => 'foo.pdf.prawn'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ruby'
      assert_guess :mimetype => 'application/x-ruby'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/ruby'
    end
  end
end
