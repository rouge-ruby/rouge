# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers do
  spec_dir = Pathname.new(__FILE__).dirname
  samples_dir = spec_dir.join('visual/samples')

  Rouge::Lexer.all.each do |lexer_class|
    describe lexer_class do
      include Support::Lexing

      subject { lexer_class.new }

      it 'lexes the demo with no errors' do
        assert_no_errors(lexer_class.demo)
      end

      it 'lexes the sample without throwing' do
        sample = File.read(samples_dir.join(lexer_class.tag), encoding: 'utf-8')

        out_buf = String.new("")
        subject.lex(sample) do |token, value|
          out_buf << value
        end

        # Escape is allowed to drop characters from its input
        next if lexer_class == Rouge::Lexers::Escape

        if out_buf != sample
          out_file = "tmp/mismatch.#{subject.tag}"
          puts "mismatch with #{samples_dir.join(lexer_class.tag)}! logged to #{out_file}"
          File.open(out_file, 'w') { |f| f << out_buf }
        end

        assert { out_buf == sample }
      end
    end
  end
end
