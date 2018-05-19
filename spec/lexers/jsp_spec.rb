# -*- coding: utf-8 -*- #

describe Rouge::Lexers::JSP do
    let(:subject) { Rouge::Lexers::JSP.new }
    let(:bom) { "\xEF\xBB\xBF" }
  
    describe 'guessing' do
      include Support::Guessing
  
      it 'guesses by filename' do
        assert_guess :filename => 'file.jsp'
      end
  
      it 'guesses by mimetype' do
        assert_guess :mimetype => 'text/x-jsp'
        assert_guess :mimetype => 'application/x-jsp'
      end
  
    end
end