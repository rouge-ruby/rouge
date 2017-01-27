# -*- coding: utf-8 -*- #

# This is from
# http://stackoverflow.com/questions/3772864/how-do-i-remove-leading-whitespace-chars-from-ruby-heredoc#answer-3772911
# and removes a minimal amount of leading whitespace from each line of a string.
# Ruby 2.3 and later has a squiggly heredoc (<<~) that eliminates the need for
# this.
class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, '')
  end
end

describe Rouge::Lexers::CsoundOrchestra do
  let(:subject) { Rouge::Lexers::CsoundOrchestra.new }

  describe 'Csound Orchestra lexer' do
    include Support::Lexing

    it 'lexes comments' do
      code = <<-EOF.unindent
        /*
         * comment
         */
        ; comment
        // comment
      EOF
      assert_tokens_equal code,
        ['Comment.Multiline', "/*\n * comment\n */"],
        ['Text', "\n"],
        ['Comment.Single', '; comment'],
        ['Text', "\n"],
        ['Comment.Single', '// comment'],
        ['Text', "\n"]
    end

    it 'lexes instrument blocks' do
      code = <<-EOF.unindent
        instr/**/1,/**/N_a_M_e_,/**/+Name/**///
          iDuration = p3
          outc:a(aSignal)
        endin
      EOF
      assert_tokens_equal code,
        ['Keyword.Declaration', 'instr'],
        ['Comment.Multiline', '/**/'],
        ['Name.Function', '1'],
        ['Punctuation', ','],
        ['Comment.Multiline', '/**/'],
        ['Name.Function', 'N_a_M_e_'],
        ['Punctuation', ','],
        ['Comment.Multiline', '/**/'],
        ['Punctuation', '+'],
        ['Name.Function', 'Name'],
        ['Comment.Multiline', '/**/'],
        ['Comment.Single', '//'],
        ['Text', "\n  "],
        ['Keyword.Type', 'i'],
        ['Name', 'Duration'],
        ['Text', ' '],
        ['Operator', '='],
        ['Text', ' '],
        ['Name.Variable.Instance', 'p3'],
        ['Text', "\n  "],
        ['Name.Builtin', 'outc'],
        ['Punctuation', ':'],
        ['Keyword.Type', 'a'],
        ['Punctuation', '('],
        ['Keyword.Type', 'a'],
        ['Name', 'Signal'],
        ['Punctuation', ')'],
        ['Text', "\n"],
        ['Keyword.Declaration', 'endin'],
        ['Text', "\n"]
    end

    it 'lexes user-defined opcodes' do
      code = <<-EOF.unindent
        opcode/**/aUDO,/**/0,/**/aik//
          aUDO
        endop
      EOF
      assert_tokens_equal code,
        ['Keyword.Declaration', 'opcode'],
        ['Comment.Multiline', '/**/'],
        ['Name.Function', 'aUDO'],
        ['Punctuation', ','],
        ['Comment.Multiline', '/**/'],
        ['Keyword.Type', '0'],
        ['Punctuation', ','],
        ['Comment.Multiline', '/**/'],
        ['Keyword.Type', 'aik'],
        ['Comment.Single', '//'],
        ['Text', "\n  "],
        ['Name.Function', 'aUDO'],
        ['Text', "\n"],
        ['Keyword.Declaration', 'endop'],
        ['Text', "\n"]
    end

    it 'lexes numbers' do
      assert_tokens_equal '123 0123456789',
        ['Literal.Number.Integer', '123'],
        ['Text', ' '],
        ['Literal.Number.Integer', '0123456789']
      assert_tokens_equal '0xabcdef0123456789 0XABCDEF',
        ['Literal.Number.Hex', '0xabcdef0123456789'],
        ['Text', ' '],
        ['Literal.Number.Hex', '0XABCDEF']
      %w(1e2 3e+4 5e-6 7E8 9E+0 1E-2 3. 4.56 .789).each do |code|
        assert_tokens_equal code, ['Literal.Number.Float', code]
      end
    end

    it 'lexes quoted strings' do
      assert_tokens_equal '"characters$MACRO."',
        ['Literal.String', '"characters'],
        ['Comment.Preproc', '$MACRO.'],
        ['Literal.String', '"']
    end

    it 'lexes braced strings' do
      code = <<-EOF.unindent
        {{
        characters$MACRO.
        }}
      EOF
      assert_tokens_equal code,
        ['Literal.String', "{{\ncharacters$MACRO.\n}}"],
        ['Text', "\n"]
    end

    it 'lexes escape sequences' do
      %w(\\\\ \\a \\b \\n \\r \\t \\" \\012 \\345 \\67).each do |code|
        assert_tokens_equal %Q("#{code}"),
          ['Literal.String', '"'],
          ['Literal.String.Escape', code],
          ['Literal.String', '"']
        assert_tokens_equal "{{#{code}}}",
          ['Literal.String', '{{'],
          ['Literal.String.Escape', code],
          ['Literal.String', '}}']
      end
    end

    it 'lexes operators' do
      %w(+ - ~ ¬ ! * / ^ % << >> < > <= >= == != & # | && || ? : += -= *= /=).each do |code|
        assert_tokens_equal code, ['Operator', code]
      end
    end

    it 'lexes global value identifiers' do
      %w(0dbfs A4 kr ksmps nchnls nchnls_i sr).each do |code|
        assert_tokens_equal code, ['Name.Variable.Global', code]
      end
    end

    it 'lexes keywords' do
      %w(do else elseif endif enduntil fi if ithen kthen od then until while).each do |code|
        assert_tokens_equal code, ['Keyword', code]
      end
      %w(return rireturn).each do |code|
        assert_tokens_equal code, ['Keyword.Pseudo', code]
      end
    end

    it 'lexes labels' do
      code = <<-EOF.unindent
        aLabel:
         label2:
      EOF
      assert_tokens_equal code,
        ['Name.Label', 'aLabel'],
        ['Punctuation', ':'],
        ['Text', "\n "],
        ['Name.Label', 'label2'],
        ['Punctuation', ':'],
        ['Text', "\n"]
    end

    it 'lexes printks and prints escape sequences' do
      %w(printks prints).each do |opcode|
        %w(%! %% %n %N %r %R %t %T \\\\a \\\\A \\\\b \\\\B \\\\n \\\\N \\\\r \\\\R \\\\t \\\\T).each do |code|
          assert_tokens_equal %Q(#{opcode} "#{code}"),
            ['Name.Builtin', opcode],
            ['Text', ' '],
            ['Literal.String', '"'],
            ['Literal.String.Escape', code],
            ['Literal.String', '"']
        end
      end
    end

    it 'lexes goto statements' do
      %w(goto igoto kgoto).each do |code|
        assert_tokens_equal "#{code} aLabel",
          ['Keyword', code],
          ['Text', ' '],
          ['Name.Label', 'aLabel']
      end
      %w(reinit rigoto tigoto).each do |code|
        assert_tokens_equal "#{code} aLabel",
          ['Keyword.Pseudo', code],
          ['Text', ' '],
          ['Name.Label', 'aLabel']
      end
      %w(cggoto cigoto cingoto ckgoto cngoto cnkgoto).each do |code|
        assert_tokens_equal "#{code} 1==0, aLabel",
          ['Keyword.Pseudo', code],
          ['Text', ' '],
          ['Literal.Number.Integer', '1'],
          ['Operator', '=='],
          ['Literal.Number.Integer', '0'],
          ['Punctuation', ','],
          ['Text', ' '],
          ['Name.Label', 'aLabel']
      end
      assert_tokens_equal 'timout 0, 0, aLabel',
        ['Keyword.Pseudo', 'timout'],
        ['Text', ' '],
        ['Literal.Number.Integer', '0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Literal.Number.Integer', '0'],
        ['Punctuation', ','],
        ['Text', ' '],
        ['Name.Label', 'aLabel']
      %w(loop_ge loop_gt loop_le loop_lt).each do |code|
        assert_tokens_equal "#{code} 0, 0, 0, aLabel",
          ['Keyword.Pseudo', code],
          ['Text', ' '],
          ['Literal.Number.Integer', '0'],
          ['Punctuation', ','],
          ['Text', ' '],
          ['Literal.Number.Integer', '0'],
          ['Punctuation', ','],
          ['Text', ' '],
          ['Literal.Number.Integer', '0'],
          ['Punctuation', ','],
          ['Text', ' '],
          ['Name.Label', 'aLabel']
      end
    end

    it 'lexes include directives' do
      %w(" |).each do |character|
        assert_tokens_equal "#include/**/#{character}file.udo#{character}",
          ['Comment.Preproc', '#include'],
          ['Comment.Multiline', '/**/'],
          ['Literal.String', "#{character}file.udo#{character}"]
      end
    end

    it 'lexes object-like macro definitions' do
      code = <<-EOF.unindent
        # \tdefine MACRO#macro_body#
        #define/**/
        MACRO/**/
        #\\#macro
        body\\##
      EOF
      assert_tokens_equal code,
        ['Comment.Preproc', "# \tdefine"],
        ['Text', ' '],
        ['Comment.Preproc', 'MACRO'],
        ['Punctuation', '#'],
        ['Name', 'macro_body'],
        ['Punctuation', '#'],
        ['Text', "\n"],
        ['Comment.Preproc', '#define'],
        ['Comment.Multiline', '/**/'],
        ['Text', "\n"],
        ['Comment.Preproc', 'MACRO'],
        ['Comment.Multiline', '/**/'],
        ['Text', "\n"],
        ['Punctuation', '#'],
        ['Comment.Preproc', '\\#'],
        ['Name', 'macro'],
        ['Text', "\n"],
        ['Name', 'body'],
        ['Comment.Preproc', '\\#'],
        ['Punctuation', '#'],
        ['Text', "\n"]
    end

    it 'lexes function-like macro definitions' do
      code = <<-EOF.unindent
        #define MACRO(ARG1#ARG2) #macro_body#
        #define/**/
        MACRO(ARG1'ARG2' ARG3)/**/
        #\\#macro
        body\\##
      EOF
      assert_tokens_equal code,
        ['Comment.Preproc', '#define'],
        ['Text', ' '],
        ['Comment.Preproc', 'MACRO'],
        ['Punctuation', '('],
        ['Comment.Preproc', 'ARG1'],
        ['Punctuation', '#'],
        ['Comment.Preproc', 'ARG2'],
        ['Punctuation', ')'],
        ['Text', ' '],
        ['Punctuation', '#'],
        ['Name', 'macro_body'],
        ['Punctuation', '#'],
        ['Text', "\n"],
        ['Comment.Preproc', '#define'],
        ['Comment.Multiline', '/**/'],
        ['Text', "\n"],
        ['Comment.Preproc', 'MACRO'],
        ['Punctuation', '('],
        ['Comment.Preproc', 'ARG1'],
        ['Punctuation', "'"],
        ['Comment.Preproc', 'ARG2'],
        ['Punctuation', "'"],
        ['Text', ' '],
        ['Comment.Preproc', 'ARG3'],
        ['Punctuation', ')'],
        ['Comment.Multiline', '/**/'],
        ['Text', "\n"],
        ['Punctuation', '#'],
        ['Comment.Preproc', '\\#'],
        ['Name', 'macro'],
        ['Text', "\n"],
        ['Name', 'body'],
        ['Comment.Preproc', '\\#'],
        ['Punctuation', '#'],
        ['Text', "\n"]
    end

    it 'lexes macro preprocessor directives' do
      %w(#ifdef #ifndef #undef).each do |directive|
        assert_tokens_equal "#{directive} MACRO",
          ['Comment.Preproc', directive],
          ['Text', ' '],
          ['Comment.Preproc', 'MACRO']
      end
    end

    it 'lexes other preprocessor directives' do
      code = <<-EOF.unindent
        #else
        #end
        #endif
        ###
        @ \t12345
        @@ \t67890
      EOF
      assert_tokens_equal code,
        ['Comment.Preproc', '#else'],
        ['Text', "\n"],
        ['Comment.Preproc', '#end'],
        ['Text', "\n"],
        ['Comment.Preproc', '#endif'],
        ['Text', "\n"],
        ['Comment.Preproc', '###'],
        ['Text', "\n"],
        ['Comment.Preproc', "@ \t12345"],
        ['Text', "\n"],
        ['Comment.Preproc', "@@ \t67890"],
        ['Text', "\n"]
    end

    it 'lexes function-like macros' do
      code = <<-EOF.unindent
        $MACRO.(((x\\))' "x)\\)x\\))"# {{x\\))x)\\)}})
      EOF
      assert_tokens_equal code,
        ['Comment.Preproc', '$MACRO.'],
        ['Punctuation', '('],
        ['Comment.Preproc', '(('],
        ['Name', 'x'],
        ['Comment.Preproc', '\\)'],
        ['Error', ')'],
        ['Punctuation', "'"],
        ['Text', ' '],
        ['Literal.String', '"x'],
        ['Error', ')'],
        ['Comment.Preproc', '\\)'],
        ['Literal.String', 'x'],
        ['Comment.Preproc', '\\)'],
        ['Error', ')'],
        ['Literal.String', '"'],
        ['Punctuation', '#'],
        ['Text', ' '],
        ['Literal.String', '{{x'],
        ['Comment.Preproc', '\\)'],
        ['Error', ')'],
        ['Literal.String', 'x'],
        ['Error', ')'],
        ['Comment.Preproc', '\\)'],
        ['Literal.String', '}}'],
        ['Punctuation', ')'],
        ['Text', "\n"]
    end

    include Support::Guessing
    it 'guesses by filename' do
      assert_guess :filename => 'foo.orc'
      assert_guess :filename => 'foo.udo'
    end
  end
end


describe Rouge::Lexers::CsoundScore do
  let(:subject) { Rouge::Lexers::CsoundScore.new }

  describe 'Csound Score lexer' do
    include Support::Guessing
    it 'guesses by filename' do
      assert_guess :filename => 'foo.sco'
    end
  end
end


describe Rouge::Lexers::CsoundDocument do
  let(:subject) { Rouge::Lexers::CsoundDocument.new }

  describe 'Csound Document lexer' do
    include Support::Guessing
    it 'guesses by filename' do
      assert_guess :filename => 'foo.csd'
    end
  end
end
