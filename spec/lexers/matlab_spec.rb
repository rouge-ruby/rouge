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
      # this test is here to prove that <% isn't recognized as Mason
      assert_guess :filename => 'foo.m', :source => <<-eos
      function ImageGaborPhase(TFType,pkt,ell,titlestr)
      % ImageGaborPhase -- Time-Frequency Display with congruent rectangles
      %  Usage
      %    ImageGaborPhase(pkt,ell[,titlestr])
      %  Inputs
      %    TFType    type of time-frequency decomposition: 'WP' or 'CP'
      %    pkt       wavelet or cosine packet table
      %    ell       level of packet table to use
      %    titlestr  optional title string for plot
      %
      %  Side Effects
      %    Phase plot with 2^(ell-1) vertical and n/(2^(ell-1))
      %    horizontal subdivisions.
      %
      %  See Also
      %    ImagePhasePlane, CPTour, WPTour
      %
        if nargin < 3,
          titlestr = ' ';
        end
        [n,L] = size(pkt);
        if ell < 0 | ell >= L,
          fprintf('in ImageGaborPhase, ell=%g, needs to be 0 <= ell < %g\n',ell,L);
        else 
          ltree = zeros(1,2^L);
          if ell >= 1 & ell < L,
            ltree(1:(2^ell-1)) = ones(1,2^ell-1);
          end
          ImagePhasePlane(TFType,ltree,pkt,titlestr)
        end

      %
      % Copyright (c) 1993. David L. Donoho
      %     
      
      eos
    end

    it 'guesses by source' do
      assert_guess :filename => 'foo.m', :source => <<-eos
      methods
        function obj = GaussianBlur(sigma, img_size, edges)
            %GAUSSIANBLUR Create Gaussian Blur filter object.

            if ~exist('edges', 'var')
                edges = 'zero';
            end

            obj.img_size = img_size;
            obj.edges = edges;
            obj.padded_size = 2*img_size - 1;

            kernel = fftshift(fspecial('gaussian', obj.padded_size, sigma));
            obj.kernel_ft = fft2(kernel);

            switch obj.edges
                case 'smart'
                    integration_img = ones(obj.img_size);
                    integration_img_ft = fft2(integration_img, obj.padded_size(1), obj.padded_size(2));
                    energy_in_img = obj.fft_conv2(integration_img_ft, obj.kernel_ft);
                    filter_energy = sum(kernel(:));
                    obj.calibration = filter_energy./energy_in_img;
            end
        end
      end
      eos
    end
  end
end

