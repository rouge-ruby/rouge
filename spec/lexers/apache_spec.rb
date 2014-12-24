describe Rouge::Lexers::Apache do
  let(:subject) { Rouge::Lexers::Apache.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => '.htaccess'
      assert_guess :filename => 'httpd.conf'
      deny_guess   :filename => 'foo.conf'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-apache-conf'
      assert_guess :mimetype => 'text/x-httpd-conf'
    end
  end
end
