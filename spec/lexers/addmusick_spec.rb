# frozen_string_literal: true

describe Rouge::Lexers::AddmusicK do
  let(:subject) { Rouge::Lexers::AddmusicK.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.amk'
      assert_guess :filename => 'foo.rmk'
      assert_guess :filename => 'foo.mml'
    end

    it 'guesses by source' do
      assert_guess :source => <<~AMK
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;    Title = Cast List   ;;
      ;; Ported by LadiesMan217 ;;
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;


      #option smwvtable

      #SPC
      {
        #author "Koji Kondo"
        #title "Cast List"
        #game "Super Mario World"
        #length "2:19"
      }
      AMK
    end
  end
end
