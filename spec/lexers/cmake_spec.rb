describe Rouge::Lexers::CMake do
  let(:subject) { Rouge::Lexers::CMake.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'CMakeLists.txt'
      assert_guess :filename => 'cmake_clean.cmake'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-cmake'
    end
  end
end
