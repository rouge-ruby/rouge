# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Matlab do
  let(:subject) { Rouge::Lexers::Matlab.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.m', :source => '% comment'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-matlab'
      assert_guess :mimetype => 'application/x-matlab'
    end

    it 'guesses by source' do
      assert_guess :filename => 'foo.m', :source => <<-eos
      function ImageGaborPhase(TFType,pkt,ell,titlestr)
      % ImageGaborPhase -- Time-Frequency Display with congruent rectangles
      
      eos
    end

    it 'guesses by source' do
      assert_guess :filename => 'foo.m', :source => <<-eos
      methods
        function obj = GaussianBlur(sigma, img_size, edges)
            %GAUSSIANBLUR Create Gaussian Blur filter object
        end
      end
      eos
    end
  end
end

