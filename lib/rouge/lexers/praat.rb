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
        endwhile repeat until select plus minus demo assert stopwatch 
        nocheck nowarn noprogress editor endeditor clearinfo
      )

      functions_string = %w(
        backslashTrigraphsToUnicode chooseDirectory chooseReadFile
        chooseWriteFile date demoKey do environment extractLine extractWord
        fixed info left mid percent readFile replace replace_regex right
        selected string unicodeToBackslashTrigraphs
      )

      functions_numeric = %w(
        abs appendFile appendFileLine appendInfo appendInfoLine arccos arccosh
        arcsin arcsinh arctan arctan2 arctanh barkToHertz beginPause
        beginSendPraat besselI besselK beta beta2 binomialP binomialQ boolean
        ceiling chiSquareP chiSquareQ choice comment cos cosh createDirectory
        deleteFile demoClicked demoClickedIn demoCommandKeyPressed
        demoExtraControlKeyPressed demoInput demoKeyPressed
        demoOptionKeyPressed demoShiftKeyPressed demoShow demoWaitForInput
        demoWindowTitle demoX demoY differenceLimensToPhon do editor endPause
        endSendPraat endsWith erb erbToHertz erf erfc exitScript exp
        extractNumber fileReadable fisherP fisherQ floor gaussP gaussQ
        hertzToBark hertzToErb hertzToMel hertzToSemitones imax imin
        incompleteBeta incompleteGammaP index index_regex invBinomialP
        invBinomialQ invChiSquareQ invFisherQ invGaussQ invSigmoid invStudentQ
        length ln lnBeta lnGamma log10 log2 max melToHertz min minusObject
        natural number numberOfColumns numberOfRows numberOfSelected
        objectsAreIdentical option optionMenu pauseScript
        phonToDifferenceLimens plusObject positive randomBinomial randomGauss
        randomInteger randomPoisson randomUniform real readFile removeObject
        rindex rindex_regex round runScript runSystem runSystem_nocheck
        selectObject selected semitonesToHertz sentencetext sigmoid sin sinc
        sincpi sinh soundPressureToPhon sqrt startsWith studentP studentQ tan
        tanh variableExists word writeFile writeFileLine writeInfo
        writeInfoLine
      )

      functions_array = %w(
        linear randomGauss randomInteger randomUniform zero
      )

      objects = %w(
        Activation AffineTransform AmplitudeTier Art Artword Autosegment
        BarkFilter BarkSpectrogram CCA Categories Cepstrogram Cepstrum
        Cepstrumc ChebyshevSeries ClassificationTable Cochleagram Collection
        ComplexSpectrogram Configuration Confusion ContingencyTable Corpus
        Correlation Covariance CrossCorrelationTable CrossCorrelationTables DTW
        DataModeler Diagonalizer Discriminant Dissimilarity Distance
        Distributions DurationTier EEG ERP ERPTier EditCostsTable
        EditDistanceTable Eigen Excitation Excitations ExperimentMFC FFNet
        FeatureWeights FileInMemory FilesInMemory Formant FormantFilter
        FormantGrid FormantModeler FormantPoint FormantTier GaussianMixture HMM
        HMM_Observation HMM_ObservationSequence HMM_State HMM_StateSequence
        Harmonicity ISpline Index Intensity IntensityTier IntervalTier KNN
        KlattGrid KlattTable LFCC LPC Label LegendreSeries LinearRegression
        LogisticRegression LongSound Ltas MFCC MSpline ManPages Manipulation
        Matrix MelFilter MelSpectrogram MixingMatrix Movie Network OTGrammar
        OTHistory OTMulti PCA PairDistribution ParamCurve Pattern Permutation
        Photo Pitch PitchModeler PitchTier PointProcess Polygon Polynomial
        PowerCepstrogram PowerCepstrum Procrustes RealPoint RealTier ResultsMFC
        Roots SPINET SSCP SVD Salience ScalarProduct Similarity SimpleString
        SortedSetOfString Sound Speaker Spectrogram Spectrum SpectrumTier
        SpeechSynthesizer SpellingChecker Strings StringsIndex Table
        TableOfReal TextGrid TextInterval TextPoint TextTier Tier Transition
        VocalTract VocalTractTier Weight WordList
      )

      variables_numeric = %w(
        macintosh windows unix praatVersion pi e undefined
      )

      variables_string = %w(
        praatVersion tab shellDirectory homeDirectory
        preferencesDirectory newline temporaryDirectory
        defaultDirectory
      )

      state :root do
        rule /(\s+)(#.*?$)/ do
          groups Text, Comment::Single
        end

        rule /^#.*?$/,        Comment::Single
        rule /;[^\n]*/,       Comment::Single
        rule /\s+/,           Text
        rule /\bprocedure\b/, Keyword,        :procedure_definition
        rule /\bcall\b/,      Keyword,        :procedure_call
        rule /@/,             Name::Function, :procedure_call

        mixin :function_call

        rule /\b(?:#{keywords.join('|')})\b/, Keyword

        rule /(\bform\b)(\s+)([^\n]+)/ do
          groups Keyword, Text, Literal::String
          push :old_form
        end

        rule /(print(?:line|tab)?|echo|exit|asserterror|pause|send(?:praat|socket)|include|execute|system(?:_nocheck)?)(\s+)/ do
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

        rule /\b(?=[A-Z])/, Text, :command
        rule /(\.{3}|[)(,\$])/, Punctuation
        rule /./, Generic::Error
      end

      state :command do
        rule /( ?[\w()-]+ ?)/, Keyword
        rule /'(?=.*')/,  Literal::String::Interpol, :string_interpolated
        rule /\.{3}/,     Keyword, :old_arguments
        rule /:/,         Keyword, :comma_list
        rule /[\s\n]/,    Text, :pop!
      end

      state :function_call do
        rule /\b(#{functions_string.join('|')})\$(?=\s*[:(])/, Name::Function, :function
        rule /\b(#{functions_array.join('|')})#(?=\s*[:(])/,   Name::Function, :function
        rule /\b(#{functions_numeric.join('|')})(?=\s*[:(])/,  Name::Function, :function
      end

      state :old_arguments do
        rule /\n/ do
          token Text
          pop!
          pop! unless state? :root
        end

        mixin :function_call
        mixin :operator
        mixin :number

        rule /"/, Literal::String, :string
        rule /[^\n]/, Text
      end

      state :function do
        rule /\s+/, Text

        rule /:/ do
          token Punctuation
          push :comma_list
        end

        rule /\s*\(/ do
          token Punctuation
          pop!
          push :comma_list
        end
      end

      state :procedure_call do
        rule /\s+/, Text

        rule /([\w.]+)(:|\s*\()/ do
          groups Name::Function, Punctuation
          push :comma_list
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
        rule /(\s*\n\s*)(\.{3})/ do
          groups Text, Punctuation
        end

        rule /\s*(\)|\]|\n)/ do
          token Punctuation
          pop!
          pop! unless state? :root
        end

        rule /\s+/, Text
        rule /"/,   Literal::String, :string
        rule /\b(if|then|else|fi|endif)\b/, Keyword

        mixin :function_call
        mixin :variable_name
        mixin :operator
        mixin :number

        rule /,/, Punctuation
      end

      state :number do
        rule /\n/, Text, :pop!
        rule /\b\d+(\.\d*)?([eE][-+]?\d+)?%?/, Literal::Number
      end

      state :variable_name do
        mixin :operator
        mixin :number

        rule /\b(?:#{variables_string.join('|')})\$/,  Name::Builtin
        rule /\b(?:#{variables_numeric.join('|')})\b/, Name::Builtin

        rule /\b(Object|#{objects.join('|')})_\w+/, Name::Builtin, :object_attributes

        rule /\b((?:Object|#{objects.join('|')})_)(')/ do
          groups Name::Builtin, Literal::String::Interpol
          push :object_attributes
          push :string_interpolated
        end

        rule /\.?[a-z][a-zA-Z0-9_.]*(\$|#)?/, Text
        rule /[\[\]]/, Punctuation
        rule /'(?=.*')/, Literal::String::Interpol, :string_interpolated
      end

      state :object_attributes do
        rule /\.?(n(col|row)|[xy]min|[xy]max|[nd][xy])\b/, Name::Builtin, :pop!
        rule /(\.?(?:col|row)\$)(\[)/ do
          groups Name::Builtin, Punctuation
          push :variable_name
        end
        rule /(\$?)(\[)/ do
          groups Name::Builtin, Punctuation
          push :comma_list
        end
      end

      state :string_interpolated do
        rule /\.?[_a-z][a-zA-Z0-9_.]*(?:[\$#]?(?:\[[a-zA-Z0-9,]+\])?|:[0-9]+)?/, Literal::String::Interpol
        rule /'/, Literal::String::Interpol, :pop!
      end

      state :string_unquoted do
        rule /\n\s*\.{3}/, Punctuation
        rule /\n/,         Text, :pop!
        rule /\s/,         Text
        rule /'(?=.*')/,   Literal::String::Interpol, :string_interpolated
        rule /'/,          Literal::String
        rule /[^'\n]+/,    Literal::String
      end

      state :string do
        rule /\n\s*\.{3}/, Punctuation
        rule /"/,          Literal::String,           :pop!
        rule /'(?=.*')/,   Literal::String::Interpol, :string_interpolated
        rule /'/,          Literal::String
        rule /[^'"\n]+/,   Literal::String
      end

      state :old_form do
        rule /\s+/, Text

        rule /(optionmenu|choice)([ \t]+\S+:[ \t]+)/ do
          groups Keyword, Text
          push :number
        end

        rule /(option|button)([ \t]+)/ do
          groups Keyword, Text
          push :number
        end

        rule /(option|button)([ \t]+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule /(sentence|text)([ \t]+\S+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule /(word)([ \t]+\S+[ \t]*)(\S+)?([ \t]+.*)?/ do
          groups Keyword, Text, Literal::String, Generic::Error
        end

        rule /(boolean)(\s+\S+\s*)(0|1|"?(?:yes|no)"?)/ do
          groups Keyword, Text, Name::Variable
        end

        rule /(real|natural|positive|integer)([ \t]+\S+[ \t]*)([+-]?)/ do
          groups Keyword, Text, Operator
          push :number
        end

        rule /(comment)(\s+)/ do
          groups Keyword, Text
          push :string_unquoted
        end

        rule /\bendform\b/, Keyword, :pop!
      end

      state :operator do
        # This rule incorrectly matches === or +++++, which are not operators
        rule /([+\/*<>=!-]=?|[&*|][&*|]?|\^|<>)/, Operator
        rule /\b(and|or|not|div|mod)\b/,          Operator::Word
      end
    end
  end
end
