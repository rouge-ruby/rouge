# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class IgorPro < RegexLexer
      tag 'igorpro'
      filenames '*.ipf'
      mimetypes 'text/x-igorpro'

      title "IgorPro"
      desc "WaveMetrics Igor Pro"

      keywords = %w(
      Structure EndStructure
      threadsafe static
      Macro Proc Window Menu Function End
      if else elseif endif switch strswitch endswitch
      break return continue
      for endfor do while
      case default
      AbortOnRTE
      )

      preprocessor = %w(
      pragma include
      define ifdef ifndef undef
      if elif else endif
      )

      igorDeclarations = %w(
      Variable String WAVE StrConstant Constant
      NVAR SVAR DFREF FUNCREF STRUCT
      char uchar int16 uint16 int32 uint32 int64 uint64 float double
      )

      igorConstants = %w(
      NaN Inf
      )

      igorFunction = %w(
      AxonTelegraphSetTimeoutMs AxonTelegraphGetTimeoutMs
      AxonTelegraphGetDataNum AxonTelegraphAGetDataNum
      AxonTelegraphGetDataString AxonTelegraphAGetDataString
      AxonTelegraphGetDataStruct AxonTelegraphAGetDataStruct HDF5DatasetInfo
      HDF5AttributeInfo HDF5TypeInfo HDF5LibraryInfo
      MPFXGaussPeak MPFXLorenzianPeak MPFXVoigtPeak MPFXEMGPeak MPFXExpConvExpPeak
      abs acos acosh AiryA AiryAD AiryB AiryBD
      alog area areaXY asin asinh atan atan2 atanh AxisValFromPixel Besseli
      Besselj Besselk Bessely beta betai BinarySearch BinarySearchInterp
      binomial binomialln binomialNoise cabs CaptureHistoryStart ceil cequal
      char2num chebyshev chebyshevU CheckName cmplx cmpstr conj ContourZ cos
      cosh cosIntegral cot coth CountObjects CountObjectsDFR cpowi
      CreationDate csc csch DataFolderExists DataFolderRefsEqual
      DataFolderRefStatus date2secs datetime DateToJulian Dawson defined
      deltax digamma dilogarithm DimDelta DimOffset DimSize ei enoise
      equalWaves erf erfc erfcw exists exp expInt expIntegralE1 expNoise
      factorial fakedata faverage faverageXY FindDimLabel FindListItem floor
      FontSizeHeight FontSizeStringWidth FresnelCos FresnelSin gamma
      gammaEuler gammaInc gammaNoise gammln gammp gammq Gauss Gauss1D Gauss2D
      gcd GetBrowserLine GetDefaultFontSize GetDefaultFontStyle GetKeyState
      GetRTError GetRTLocation GizmoInfo GizmoScale gnoise GrepString hcsr
      hermite hermiteGauss HyperG0F1 HyperG1F1 HyperG2F1 HyperGNoise HyperGPFQ
      IgorVersion imag IndexToScale Integrate1D interp Interp2D Interp3D
      inverseERF inverseERFC ItemsInList JacobiCn JacobiSn Laguerre LaguerreA
      LaguerreGauss LambertW leftx LegendreA limit ln log logNormalNoise
      lorentzianNoise magsqr MandelbrotPoint MarcumQ MatrixCondition MatrixDet
      MatrixDot MatrixRank MatrixTrace max mean median min mod ModDate
      norm NumberByKey numpnts numtype NumVarOrDefault NVAR_Exists p2rect
      PanelResolution ParamIsDefault pcsr Pi PixelFromAxisVal pnt2x
      poissonNoise poly poly2D PolygonArea qcsr r2polar real rightx round
      sawtooth scaleToIndex ScreenResolution sec sech SelectNumber
      SetEnvironmentVariable sign sin sinc sinh sinIntegral SphericalBessJ
      SphericalBessJD SphericalBessY SphericalBessYD SphericalHarmonics sqrt
      StartMSTimer StatsBetaCDF StatsBetaPDF StatsBinomialCDF StatsBinomialPDF
      StatsCauchyCDF StatsCauchyPDF StatsChiCDF StatsChiPDF StatsCMSSDCDF
      StatsCorrelation StatsDExpCDF StatsDExpPDF StatsErlangCDF StatsErlangPDF
      StatsErrorPDF StatsEValueCDF StatsEValuePDF StatsExpCDF StatsExpPDF
      StatsFCDF StatsFPDF StatsFriedmanCDF StatsGammaCDF StatsGammaPDF
      StatsGeometricCDF StatsGeometricPDF StatsGEVCDF StatsGEVPDF
      StatsHyperGCDF StatsHyperGPDF StatsInvBetaCDF StatsInvBinomialCDF
      StatsInvCauchyCDF StatsInvChiCDF StatsInvCMSSDCDF StatsInvDExpCDF
      StatsInvEValueCDF StatsInvExpCDF StatsInvFCDF StatsInvFriedmanCDF
      StatsInvGammaCDF StatsInvGeometricCDF StatsInvKuiperCDF
      StatsInvLogisticCDF StatsInvLogNormalCDF StatsInvMaxwellCDF
      StatsInvMooreCDF StatsInvNBinomialCDF StatsInvNCChiCDF StatsInvNCFCDF
      StatsInvNormalCDF StatsInvParetoCDF StatsInvPoissonCDF StatsInvPowerCDF
      StatsInvQCDF StatsInvQpCDF StatsInvRayleighCDF StatsInvRectangularCDF
      StatsInvSpearmanCDF StatsInvStudentCDF StatsInvTopDownCDF
      StatsInvTriangularCDF StatsInvUsquaredCDF StatsInvVonMisesCDF
      StatsInvWeibullCDF StatsKuiperCDF StatsLogisticCDF StatsLogisticPDF
      StatsLogNormalCDF StatsLogNormalPDF StatsMaxwellCDF StatsMaxwellPDF
      StatsMedian StatsMooreCDF StatsNBinomialCDF StatsNBinomialPDF
      StatsNCChiCDF StatsNCChiPDF StatsNCFCDF StatsNCFPDF StatsNCTCDF
      StatsNCTPDF StatsNormalCDF StatsNormalPDF StatsParetoCDF StatsParetoPDF
      StatsPermute StatsPoissonCDF StatsPoissonPDF StatsPowerCDF
      StatsPowerNoise StatsPowerPDF StatsQCDF StatsQpCDF StatsRayleighCDF
      StatsRayleighPDF StatsRectangularCDF StatsRectangularPDF StatsRunsCDF
      StatsSpearmanRhoCDF StatsStudentCDF StatsStudentPDF StatsTopDownCDF
      StatsTriangularCDF StatsTriangularPDF StatsTrimmedMean StatsUSquaredCDF
      StatsVonMisesCDF StatsVonMisesNoise StatsVonMisesPDF StatsWaldCDF
      StatsWaldPDF StatsWeibullCDF StatsWeibullPDF StopMSTimer str2num
      stringCRC stringmatch strlen strsearch StudentA StudentT sum SVAR_Exists
      TagVal tan tanh TextEncodingCode ThreadGroupCreate ThreadGroupRelease
      ThreadGroupWait ThreadProcessorCount ThreadReturnValue ticks trunc
      UnsetEnvironmentVariable Variance vcsr VoigtFunc WaveCRC WaveDims
      WaveExists WaveMax WaveMin WaveRefsEqual WaveTextEncoding WaveType
      WhichListItem WinType wnoise x2pnt xcsr zcsr ZernikeR zeta AddListItem
      AnnotationInfo AnnotationList AxisInfo AxisList Base64_Decode
      Base64_Encode CaptureHistory ChildWindowList CleanupName ContourInfo
      ContourNameList ControlNameList ConvertTextEncoding CsrInfo CsrWave
      CsrXWave CTabList DataFolderDir date FetchURL FontList FuncRefInfo
      FunctionInfo FunctionList FunctionPath GetBrowserSelection GetDataFolder
      GetDefaultFont GetDimLabel GetEnvironmentVariable GetErrMessage
      GetFormula GetIndependentModuleName GetIndexedObjName
      GetIndexedObjNameDFR GetRTErrMessage GetRTLocInfo GetRTStackInfo
      GetScrapText GetUserData GetWavesDataFolder GrepList GuideInfo
      GuideNameList Hash IgorInfo ImageInfo ImageNameList
      IndependentModuleList IndexedDir IndexedFile JulianToDate LayoutInfo
      ListMatch LowerStr MacroList NameOfWave NormalizeUnicode note num2char
      num2istr num2str OperationList PadString ParseFilePath PathList PICTInfo
      PICTList PossiblyQuoteName ProcedureText RemoveByKey RemoveEnding
      RemoveFromList RemoveListItem ReplaceNumberByKey ReplaceString
      ReplaceStringByKey Secs2Date Secs2Time SelectString SortList
      SpecialCharacterInfo SpecialCharacterList SpecialDirPath StringByKey
      StringFromList StringList StrVarOrDefault TableInfo TextEncodingName
      TextFile ThreadGroupGetDF time TraceFromPixel TraceInfo TraceNameList
      TrimString UniqueName UnPadString UpperStr URLDecode URLEncode
      VariableList WaveInfo WaveList WaveName WaveRefWaveToList WaveUnits
      WinList WinName WinRecreation WMFindWholeWord XWaveName
      ContourNameToWaveRef CsrWaveRef CsrXWaveRef ImageNameToWaveRef
      ListToTextWave ListToWaveRefWave NewFreeWave TagWaveRef
      TraceNameToWaveRef WaveRefIndexed WaveRefIndexedDFR XWaveRefFromTrace
      GetDataFolderDFR GetWavesDataFolderDFR NewFreeDataFolder
      )

      igorOperation = %w(
      Abort AddFIFOData AddFIFOVectData AddMovieAudio AddMovieFrame AdoptFiles
      APMath Append AppendImage AppendLayoutObject AppendMatrixContour
      AppendText AppendToGizmo AppendToGraph AppendToLayout AppendToTable
      AppendXYZContour AutoPositionWindow BackgroundInfo Beep BoundingBall
      BrowseURL BuildMenu Button cd Chart CheckBox CheckDisplayed ChooseColor
      Close CloseHelp CloseMovie CloseProc ColorScale ColorTab2Wave
      Concatenate ControlBar ControlInfo ControlUpdate
      ConvertGlobalStringTextEncoding ConvexHull Convolve CopyFile CopyFolder
      CopyScales Correlate CreateAliasShortcut CreateBrowser Cross
      CtrlBackground CtrlFIFO CtrlNamedBackground Cursor CurveFit
      CustomControl CWT Debugger DebuggerOptions DefaultFont
      DefaultGuiControls DefaultGuiFont DefaultTextEncoding DefineGuide
      DelayUpdate DeleteAnnotations DeleteFile DeleteFolder DeletePoints
      Differentiate dir Display DisplayHelpTopic DisplayProcedure DoAlert
      DoIgorMenu DoUpdate DoWindow DoXOPIdle DPSS DrawAction DrawArc
      DrawBezier DrawLine DrawOval DrawPICT DrawPoly DrawRect DrawRRect
      DrawText DrawUserShape DSPDetrend DSPPeriodogram Duplicate
      DuplicateDataFolder DWT EdgeStats Edit ErrorBars Execute
      ExecuteScriptText ExperimentModified ExportGizmo Extract
      FastGaussTransform FastOp FBinRead FBinWrite FFT FGetPos FIFO2Wave
      FIFOStatus FilterFIR FilterIIR FindContour FindDuplicates FindLevel
      FindLevels FindPeak FindPointsInPoly FindRoots FindSequence FindValue
      FPClustering fprintf FReadLine FSetPos FStatus FTPCreateDirectory
      FTPDelete FTPDownload FTPUpload FuncFit FuncFitMD GBLoadWave GetAxis
      GetCamera GetFileFolderInfo GetGizmo GetLastUserMenuInfo GetMarquee
      GetMouse GetSelection GetWindow GraphNormal GraphWaveDraw GraphWaveEdit
      Grep GroupBox Hanning HideIgorMenus HideInfo HideProcedures HideTools
      HilbertTransform Histogram ICA IFFT ImageAnalyzeParticles ImageBlend
      ImageBoundaryToMask ImageEdgeDetection ImageFileInfo ImageFilter
      ImageFocus ImageFromXYZ ImageGenerateROIMask ImageGLCM
      ImageHistModification ImageHistogram ImageInterpolate ImageLineProfile
      ImageLoad ImageMorphology ImageRegistration ImageRemoveBackground
      ImageRestore ImageRotate ImageSave ImageSeedFill ImageSkeleton3d
      ImageSnake ImageStats ImageThreshold ImageTransform ImageUnwrapPhase
      ImageWindow IndexSort InsertPoints Integrate Integrate2D IntegrateODE
      Interp3DPath Interpolate2 Interpolate3D JCAMPLoadWave JointHistogram
      KillBackground KillControl KillDataFolder KillFIFO KillFreeAxis KillPath
      KillPICTs KillStrings KillVariables KillWaves KillWindow KMeans Label
      Layout LayoutPageAction LayoutSlideShow Legend
      LinearFeedbackShiftRegister ListBox LoadData LoadPackagePreferences
      LoadPICT LoadWave Loess LombPeriodogram Make MakeIndex MarkPerfTestTime
      MatrixConvolve MatrixCorr MatrixEigenV MatrixFilter MatrixGaussJ
      MatrixGLM MatrixInverse MatrixLinearSolve MatrixLinearSolveTD MatrixLLS
      MatrixLUBkSub MatrixLUD MatrixLUDTD MatrixMultiply MatrixOP MatrixSchur
      MatrixSolve MatrixSVBkSub MatrixSVD MatrixTranspose MeasureStyledText
      MLLoadWave Modify ModifyBrowser ModifyCamera ModifyContour ModifyControl
      ModifyControlList ModifyFreeAxis ModifyGizmo ModifyGraph ModifyImage
      ModifyLayout ModifyPanel ModifyTable ModifyWaterfall MoveDataFolder
      MoveFile MoveFolder MoveString MoveSubwindow MoveVariable MoveWave
      MoveWindow MultiTaperPSD MultiThreadingControl NeuralNetworkRun
      NeuralNetworkTrain NewCamera NewDataFolder NewFIFO NewFIFOChan
      NewFreeAxis NewGizmo NewImage NewLayout NewMovie NewNotebook NewPanel
      NewPath NewWaterfall Note Notebook NotebookAction Open OpenHelp
      OpenNotebook Optimize ParseOperationTemplate PathInfo PauseForUser
      PauseUpdate PCA PlayMovie PlayMovieAction PlaySound PopupContextualMenu
      PopupMenu Preferences PrimeFactors Print printf PrintGraphs PrintLayout
      PrintNotebook PrintSettings PrintTable Project PulseStats PutScrapText
      pwd Quit RatioFromNumber Redimension Remove RemoveContour
      RemoveFromGizmo RemoveFromGraph RemoveFromLayout RemoveFromTable
      RemoveImage RemoveLayoutObjects RemovePath Rename RenameDataFolder
      RenamePath RenamePICT RenameWindow ReorderImages ReorderTraces
      ReplaceText ReplaceWave Resample ResumeUpdate Reverse Rotate Save
      SaveData SaveExperiment SaveGraphCopy SaveNotebook
      SavePackagePreferences SavePICT SaveTableCopy SetActiveSubwindow SetAxis
      SetBackground SetDashPattern SetDataFolder SetDimLabel SetDrawEnv
      SetDrawLayer SetFileFolderInfo SetFormula SetIgorHook SetIgorMenuMode
      SetIgorOption SetMarquee SetProcessSleep SetRandomSeed SetScale
      SetVariable SetWaveLock SetWaveTextEncoding SetWindow ShowIgorMenus
      ShowInfo ShowTools Silent Sleep Slider Smooth SmoothCustom Sort
      SortColumns SoundInRecord SoundInSet SoundInStartChart SoundInStatus
      SoundInStopChart SoundLoadWave SoundSaveWave SphericalInterpolate
      SphericalTriangulate SplitString SplitWave sprintf sscanf Stack
      StackWindows StatsAngularDistanceTest StatsANOVA1Test StatsANOVA2NRTest
      StatsANOVA2RMTest StatsANOVA2Test StatsChiTest
      StatsCircularCorrelationTest StatsCircularMeans StatsCircularMoments
      StatsCircularTwoSampleTest StatsCochranTest StatsContingencyTable
      StatsDIPTest StatsDunnettTest StatsFriedmanTest StatsFTest
      StatsHodgesAjneTest StatsJBTest StatsKDE StatsKendallTauTest StatsKSTest
      StatsKWTest StatsLinearCorrelationTest StatsLinearRegression
      StatsMultiCorrelationTest StatsNPMCTest StatsNPNominalSRTest
      StatsQuantiles StatsRankCorrelationTest StatsResample StatsSample
      StatsScheffeTest StatsShapiroWilkTest StatsSignTest StatsSRTest
      StatsTTest StatsTukeyTest StatsVariancesTest StatsWatsonUSquaredTest
      StatsWatsonWilliamsTest StatsWheelerWatsonTest StatsWilcoxonRankTest
      StatsWRCorrelationTest StructGet StructPut SumDimension SumSeries
      TabControl Tag TextBox ThreadGroupPutDF ThreadStart Tile TileWindows
      TitleBox ToCommandLine ToolsGrid Triangulate3d Unwrap URLRequest
      ValDisplay WaveClear WaveMeanStdv WaveStats WaveTransform wfprintf
      )

      object_name = /[a-zA-Z_][a-zA-Z0-9_]*/
      whitespace  = /[\s\r]+/
      noLineBreak = /[ \t]+/
      operator = %r([\#$~!%^&*+=\|?:<>/-])
      punctuation = /[{}()\[\],.;]/
      number_float= /0x[a-f0-9]+/i
      number_hex  = /\d+\.\d+(e[\+\-]?\d+)?/
      number_int  = /[\d]+(?:_\d+)*/

      state :root do
        mixin :comments
        mixin :preprocessor
        mixin :function
        mixin :variables
        rule /\b(#{keywords.join('|')})\b/i, Keyword
        rule /\b(#{igorConstants.join('|')})\b/i, Keyword::Constant
        rule /\b(V|S|W)_[A-Z]+[A-Z0-9]*/i, Name::Builtin

        mixin :igorFunction
        mixin :igorOperation

        mixin :waveFlag
        mixin :characters
        mixin :numbers
        rule /#{object_name}/, Name
      end

      state :preprocessor do
        rule /^#(#{preprocessor.join('|')})\b/i, Comment::Preproc
      end

      state :variables do
        rule %r(^([[:space:]]*)
          (static\s)*
          ([[:space:]]*)
          (#{igorDeclarations.join('|')})\b
          )ix do
          groups Text, Keyword, Text, Keyword::Declaration
          push :parse_variables
        end
      end

      state :function do
        rule %r(^([[:space:]]*)
          ((?:static|threadsafe)\s)?
          ([[:space:]]*)
          (\bFunction\b)
          )ix do
          groups Text, Keyword, Text, Keyword::Declaration
          push :parse_function
        end
      end

      state :igorFunction do
        rule %r(
          (#{whitespace}|#{operator}|#{punctuation})
          (#{igorFunction.join('|')})\b
          )ix do |m|
          recurse m[1]
          token Name::Builtin, m[2]
        end
      end

      state :igorOperation do
        rule %r(^([[:space:]]*)
          (#{igorOperation.join('|')})\b
          )ix do
          groups Text, Keyword::Reserved
          push :operationFlags
        end
      end

      # @todo the assignment should be done via recursion in the appropriate boundaries
      state :assignment do
        mixin :whitespace
        rule /\"[^"]*\"/, Literal::String, :pop!
        rule /#{number_float}/, Literal::Number::Float, :pop!
        rule /#{number_int}/, Literal::Number::Integer, :pop!
        rule /[\(\[][^\)\]]+[\)\]]/, Generic, :pop!
        rule /[^\s\/\(]+/, Generic, :pop!
        rule(//) { pop! }
      end

      state :parse_variables do
        mixin :whitespace
        rule /[=]/, Punctuation, :assignment
        rule %r([/][a-z]+)i, Keyword::Pseudo, :parse_variables
        rule /#{object_name}/, Name::Variable
        rule /[\[\]]/, Punctuation # optional variables in functions
        rule /[,]/, Punctuation, :parse_variables
        rule /\)/, Punctuation, :pop! # end of function
        rule(//) { pop! }
      end

      state :parse_function do
        rule %r([/][a-z]+)i, Keyword::Pseudo # only one flag
        mixin :whitespace
        rule /#{object_name}/, Name::Function
        rule /[\(]/, Punctuation, :parse_variables
        rule(//) { pop! }
      end

      state :operationFlags do
        rule /#{noLineBreak}/, Text
        rule /[=]/, Punctuation, :assignment
        rule %r([/][a-z]+)i, Keyword::Pseudo, :operationFlags
        rule(//) { pop! }
      end

      # inline variable assignments (i.e. for Make) with strict syntax
      state :waveFlag do
        rule %r(
          (/(?:wave|X|Y))
          (\s*)(=)(\s*)
          (#{object_name})
          )ix do |m|
          token Keyword::Pseudo, m[1]
          token Text, m[2]
          token Punctuation, m[3]
          token Text, m[4]
          token Name::Variable, m[5]
        end
      end

      state :characters do
        rule /\s/, Text
        rule /#{operator}/, Operator
        rule /#{punctuation}/, Punctuation
        rule /\"[^"]*\"/, Literal::String
      end

      state :numbers do
        rule /#{number_float}/, Literal::Number::Float
        rule /#{number_hex}/, Literal::Number::Hex
        rule /#{number_int}/, Literal::Number::Integer
      end

      state :whitespace do
        rule /#{noLineBreak}/, Text
      end

      state :comments do
        rule %r(
          (//[^@\n]*)
          (@\w*\b)?   # doxygen parameters
          (.*)
          )x do
          groups Comment, Comment::Special, Comment
        end
      end
    end
  end
end
