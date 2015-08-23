# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Praat < RegexLexer
      title "Praat"
      desc "The Praat scripting language (praat.org)"

      tag 'praat'

      filenames '*.praat', '*.proc', '*.psc'

      def self.analyze_text(text)
        return 1 if text.shebang? 'praat'
      end

      keywords = %w(
        if then else elsif elif endif fi for from to endfor endproc while
        endwhile repeat until select plus minus demo assert asserterror
        stopwatch nocheck nowarn noprogress editor endeditor clearinfo
      )

      functions = %w(
        writeInfo writeInfoLine appendInfo appendInfoLine info$ writeFile
        writeFileLine appendFile appendFileLine abs round floor ceiling min max
        imin imax sqrt sin cos tan arcsin arccos arctan arctan2 sinc sincpi exp
        ln lnBeta lnGamma log10 log2 sinh cosh tanh arcsinh arccosh arctanh
        sigmoid invSigmoid erf erfc randomUniform randomInteger randomGauss
        randomPoisson randomBinomial gaussP gaussQ invGaussQ incompleteGammaP
        incompleteBeta chiSquareP chiSquareQ invChiSquareQ studentP studentQ
        invStudentQ fisherP fisherQ invFisherQ binomialP binomialQ invBinomialP
        invBinomialQ hertzToBark barkToHerz hertzToMel melToHertz
        hertzToSemitones semitonesToHerz erb hertzToErb erbToHertz
        phonToDifferenceLimens string$ differenceLimensToPhon
        soundPressureToPhon beta beta2 besselI besselK numberOfColumns number
        numberOfRows selected$ selected numberOfSelected variableExists index
        rindex startsWith endsWith index_regex rindex_regex replace_regex$
        length extractWord$ extractLine$ extractNumber left$ right$ mid$
        replace$ date$ fixed$ percent$ zero# linear# randomUniform#
        randomInteger# randomGauss# beginPause endPause do do$ editor demoShow
        demoWindowTitle demoInput demoWaitForInput demoClicked demoClickedIn
        demoX demoY demoKeyPressed demoKey$ demoExtraControlKeyPressed
        demoShiftKeyPressed demoCommandKeyPressed demoOptionKeyPressed
        environment$ chooseReadFile$ chooseDirectory$ createDirectory
        fileReadable deleteFile selectObject removeObject plusObject minusObject
        runScript exitScript beginSendPraat endSendPraat objectsAreIdentical
        comment natural real positive word sentencetext boolean choice option
        optionMenu
      )

      objects = %w(
        Activation AffineTransform AmplitudeTier Art Artword Autosegment
        BarkFilter CCA Categories Cepstrum Cepstrumc ChebyshevSeries
        ClassificationTable Cochleagram Collection Configuration Confusion
        ContingencyTable Corpus Correlation Covariance CrossCorrelationTable
        CrossCorrelationTables DTW Diagonalizer Discriminant Dissimilarity
        Distance Distributions DurationTier EEG ERP ERPTier Eigen Excitation
        Excitations ExperimentMFC FFNet FeatureWeights Formant FormantFilter
        FormantGrid FormantPoint FormantTier GaussianMixture HMM HMM_Observation
        HMM_ObservationSequence HMM_State HMM_StateSequence Harmonicity ISpline
        Index Intensity IntensityTier IntervalTier KNN KlattGrid KlattTable LFCC
        LPC Label LegendreSeries LinearRegression LogisticRegression LongSound
        Ltas MFCC MSpline ManPages Manipulation Matrix MelFilter MixingMatrix
        Movie Network OTGrammar OTHistory OTMulti PCA PairDistribution
        ParamCurve Pattern Permutation Pitch PitchTier PointProcess Polygon
        Polynomial Procrustes RealPoint RealTier ResultsMFC Roots SPINET SSCP
        SVD Salience ScalarProduct Similarity SimpleString SortedSetOfString
        Sound Speaker Spectrogram Spectrum SpectrumTier SpeechSynthesizer
        SpellingChecker Strings StringsIndex Table TableOfReal TextGrid
        TextInterval TextPoint TextTier Tier Transition VocalTract Weight
        WordList
      )

      variables = %w(
        macintosh windows unix praatVersion praatVersion$ pi undefined newline$
        tab$ shellDirectory$ homeDirectory$ preferencesDirectory$
        temporaryDirectory$ defaultDirectory$
      )

      state :root do
        rule /#.*?$/,         Comment::Single
        rule /;[^\n]*/,       Comment::Single
        rule /\s+/,           Text
        rule /\bprocedure\b/, Keyword,        :procedure_definition
        rule /\bcall\b/,      Keyword,        :procedure_call
        rule /@/,             Name::Function, :procedure_call

        rule /\b(#{functions.join('|')})(?=\s*[:(])/, Name::Function, :function

        rule /\b(?:#{keywords.join('|')})\b/, Keyword

        rule /(\bform\b)(\s+)([^\n]+)/ do
          groups Keyword, Text, Literal::String
          push :old_form
        end

        rule /(print(?:line|tab)?|echo|exit|pause|send(?:praat|socket)|include|execute|system(?:_nocheck)?)(\s+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule /(goto|label)(\s+)(\w+)/ do
          groups Keyword, Text, Name::Label
        end

        mixin :variable_name
        mixin :number

        rule /"/, Literal::String, :string

        rule /\b(?:#{objects.join('|')})(?=\s+\S+\n)/, Name::Class, :string_unquoted

        rule /(\b[A-Z][^.:\n"]+\.{3})/, Keyword, :old_arguments
        rule /\b[A-Z][^.:\n"]+:/,       Keyword, :comma_list
        rule /\b[A-Z][^\n]+/,           Keyword
        rule /(\.{3}|\)|\(|,|\$)/,      Text
      end

      state :old_arguments do
        rule /\n/ do
          token Text
          pop!
          pop! unless state? :root
        end

        mixin :variable_name
        mixin :operator
        mixin :number

        rule /"/,     Literal::String, :string
        rule /^/,     Literal::String, :pop!
        rule /[A-Z]/, Text
        rule /\s/,    Text
      end

      state :function do
        rule /\s+/, Text

        rule /:/ do
          token Text
          push :comma_list
        end

        rule /\s*\(/ do
          token Text
          pop!
          push :comma_list
        end

        rule /\)/, Text, :pop!
      end

      state :procedure_call do
        rule /\s+/, Text

        rule /([\w.]+)(:|\s*\()/ do
          groups Name::Function, Text
          pop!
        end

        rule /([\w.]+)/, Name::Function, :old_arguments
      end

      state :procedure_definition do
        rule /\s/, Text

        rule /([\w.]+)(\s*?[(:])/ do
          groups Name::Function, Text
          pop!
        end

        rule /([\w.]+)([^\n]*)/ do
          groups Name::Function, Text
          pop!
        end
      end

      state :comma_list do
        rule /\n\s*\.{3}/, Text

        rule /\n/ do
          token Text
          while state? :comma_list
            pop!
          end
          pop! unless state? :root
        end

        rule /\s+/,    Text
        rule /"/,      Literal::String, :string
        rule /\b(if|then|else|fi|endif)\b/, Keyword

        mixin :variable_name
        mixin :operator
        mixin :number

        rule /,/,      Text, :comma_list
        rule /(\)|\]|^)/, Text, :pop!
      end

      state :number do
        rule /[+-]?\d+(\.\d+([eE][+-]?\d+)?)?/,   Literal::Number
      end

      state :variable_name do
        mixin :operator
        mixin :number

        rule /\bObject_/, Name::Builtin
        rule /\b(?:#{variables.join('|')})\b/, Name::Class
        rule /\.?[a-z][a-zA-Z0-9_.]*\$?/, Text
        rule /\[/, Text, :comma_list
        rule /'(?=.*')/, Literal::String::Interpol, :string_interpolated
        rule /\]/, Text, :pop!
      end

      state :string_interpolated do
        rule /\.?[_a-z][a-zA-Z0-9_.]*(?:\$|#|:[0-9]+)?/, Literal::String::Interpol
        rule /'/, Literal::String::Interpol, :pop!
      end

      state :string_unquoted do
        rule /\n\s*\.{3}/, Text
        rule /\n/,         Text, :pop!
        rule /\s/,         Text
        rule /'(?=.*')/,   Literal::String::Interpol, :string_interpolated
        rule /'/,          Literal::String
        rule /.+/,         Literal::String
      end

      state :string do
        rule /\n\s*\.{3}/, Text
        rule /"/,          Literal::String,           :pop!
        rule /'(?=.*')/,   Literal::String::Interpol, :string_interpolated
        rule /'/,          Literal::String
        rule /[^'"\n]+/,   Literal::String
      end

      state :old_form do
        rule /\s+/, Text

        rule /(optionmenu|choice)(\s+\S+:\s+)([0-9]+)/ do
          groups Keyword, Text, Literal::Number
        end

        rule /(option|button)(\s+)([+-]?\d+(?:(?:\.\d*)?(?:[eE][+-]?\d+)?)?\b)/ do
          groups Keyword, Text, Literal::Number
        end

        rule /(option|button)(\s+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule /(sentence|text)(\s+\S+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule /(word)(\s+\S+\s*)(\S+)?(\s.*)?/ do
          groups Keyword, Text, Literal::String, Text
        end

        rule /(boolean)(\s+\S+\s*)(0|1|"?(?:yes|no)"?)/ do
          groups Keyword, Text, Name::Variable
        end

        rule /(real|natural|positive|integer)(\s+\S+\s*)([+-]?\d+(?:(?:\.\d*)?(?:[eE][+-]?\d+)?)?\b)/ do
          groups Keyword, Text, Literal::Number
        end

        rule /(comment)(\s+)(.*)/ do
          groups Keyword, Text, Literal::String
        end

        rule /\bendform\b/, Keyword, :pop!
      end

      state :operator do
        rule /([+\/*<>=!-]=?|[\%^|]|<>)/, Operator
        rule /\b(and|or|not)\b/, Operator::Word
      end
    end
  end
end
