module Rouge
  module Lexers
    class Praat
      KEYWORDS = Set.new %w(
        if then else elsif elif endif fi for from to endfor endproc while
        endwhile repeat until select plus minus demo assert stopwatch
        nocheck nowarn noprogress editor endeditor clearinfo
      )

      FUNCTIONS = Set.new %w(
        backslashTrigraphsToUnicode$ chooseDirectory$ chooseReadFile$
        chooseWriteFile$ date$ demoKey$ do$ environment$ extractLine$ extractWord$
        fixed$ info$ left$ mid$ percent$ readFile$ replace$ replace_regex$ right$
        selected$ string$ unicodeToBackslashTrigraphs$

        abs appendFile appendFileLine appendInfo appendInfoLine arccos arccosh
        arcsin arcsinh arctan arctan2 arctanh barkToHertz beginPause
        beginSendPraat besselI besselK beta beta2 binomialP binomialQ boolean
        ceiling chiSquareP chiSquareQ choice comment cos cosh createDirectory
        deleteFile demoClicked demoClickedIn demoCommandKeyPressed
        demoExtraControlKeyPressed demoInput demoKeyPressed
        demoOptionKeyPressed demoShiftKeyPressed demoShow demoWaitForInput
        demoWindowTitle demoX demoY differenceLimensToPhon do editor endPause
        endSendPraat endsWith erb erbToHertz erf erfc exitScript exp
        extractNumber fileReadable fisherP fisherQ floor gaussP gaussQ hash
        hertzToBark hertzToErb hertzToMel hertzToSemitones imax imin
        incompleteBeta incompleteGammaP index index_regex integer invBinomialP
        invBinomialQ invChiSquareQ invFisherQ invGaussQ invSigmoid invStudentQ
        length ln lnBeta lnGamma log10 log2 max melToHertz min minusObject
        natural number numberOfColumns numberOfRows numberOfSelected
        objectsAreIdentical option optionMenu pauseScript
        phonToDifferenceLimens plusObject positive randomBinomial randomGauss
        randomInteger randomPoisson randomUniform real readFile removeObject
        rindex rindex_regex round runScript runSystem runSystem_nocheck
        selectObject selected semitonesToHertz sentence sentencetext sigmoid
        sin sinc sincpi sinh soundPressureToPhon sqrt startsWith studentP
        studentQ tan tanh text variableExists word writeFile writeFileLine
        writeInfo writeInfoLine

        linear# randomGauss# randomInteger# randomUniform# zero#

        linear## mul## mul_fast## mul_metal## mul_nt## mul_tn## mul_tt## outer## peaks##
        randomGamma## randomGauss## randomInteger## randomUniform## softmaxPerRow##
        solve## transpose## zero##

        empty$# fileNames$# folderNames$# readLinesFromFile$# splitByWhitespace$#
      )

      OBJECTS = Set.new %w(
        Activation AffineTransform AmplitudeTier Art Artword Autosegment
        BarkFilter BarkSpectrogram CCA Categories Cepstrogram Cepstrum
        Cepstrumc ChebyshevSeries ClassificationTable Cochleagram Collection
        ComplexSpectrogram Configuration Confusion ContingencyTable Corpus
        Correlation Covariance CrossCorrelationTable CrossCorrelationTableList
        CrossCorrelationTables DTW DataModeler Diagonalizer Discriminant
        Dissimilarity Distance Distributions DurationTier EEG ERP ERPTier
        EditCostsTable EditDistanceTable Eigen Excitation Excitations
        ExperimentMFC FFNet FeatureWeights FileInMemory FilesInMemory Formant
        FormantFilter FormantGrid FormantModeler FormantPoint FormantTier
        GaussianMixture HMM HMM_Observation HMM_ObservationSequence HMM_State
        HMM_StateSequence HMMObservation HMMObservationSequence HMMState
        HMMStateSequence Harmonicity ISpline Index Intensity IntensityTier
        IntervalTier KNN KlattGrid KlattTable LFCC LPC Label LegendreSeries
        LinearRegression LogisticRegression LongSound Ltas MFCC MSpline ManPages
        Manipulation Matrix MelFilter MelSpectrogram MixingMatrix Movie Network
        OTGrammar OTHistory OTMulti PCA PairDistribution ParamCurve Pattern
        Permutation Photo Pitch PitchModeler PitchTier PointProcess Polygon
        Polynomial PowerCepstrogram PowerCepstrum Procrustes RealPoint RealTier
        ResultsMFC Roots SPINET SSCP SVD Salience ScalarProduct Similarity
        SimpleString SortedSetOfString Sound Speaker Spectrogram Spectrum
        SpectrumTier SpeechSynthesizer SpellingChecker Strings StringsIndex
        Table TableOfReal TextGrid TextInterval TextPoint TextTier Tier
        Transition VocalTract VocalTractTier Weight WordList
      )

      VARIABLES = Set.new %w(
        all average e left macintosh mono pi praatVersion right stereo
        undefined unix windows

        praatVersion$ tab$ shellDirectory$ homeDirectory$
        preferencesDirectory$ newline$ temporaryDirectory$
        defaultDirectory$
      )

      ATTRIBUTES = Set.new %w(ncol nrow xmin ymin xmax ymax nx ny dx dy)

    end
  end
end
