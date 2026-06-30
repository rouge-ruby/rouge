module Rouge
  module Lexers
    class Julia
      BUILTINS = Set.new %w(
        true false missing nothing
        Inf Inf16 Inf32 Inf64
        NaN NaN16 NaN32 NaN64
        stdout stderr stdin devnull
        pi π ℯ im
        ARGS C_NULL ENV ENDIAN_BOM
        VERSION undef LOAD_PATH DEPOT_PATH
      )

      KEYWORDS = Set.new %w(
        function return module import export
        if else elseif end for
        in isa while try catch
        const local global using struct
        mutable struct abstract type finally
        begin do quote macro for outer
        where
      )

      # NOTE: The list of types was generated automatically using the following script:
      # using Pkg, InteractiveUtils
      #
      # allnames = [names(Core); names(Base, imported=true)]
      #
      # for stdlib in readdir(Pkg.Types.stdlib_dir())
      #     mod = Symbol(basename(stdlib))
      #     @eval begin
      #         using $mod
      #         append!(allnames, names($mod))
      #     end
      # end
      #
      # sort!(unique!(allnames))
      #
      # i = 1
      # for sym in allnames
      #     global i # needed at the top level, e.g. in the REPL
      #     isdefined(Main, sym) || continue
      #     getfield(which(Main, sym), sym) isa Type || continue
      #     sym === :(=>) && continue # Actually an alias for Pair
      #     print(" ", sym)
      #     i % 3 == 0 ? println() : print(" ") # print 3 to a line
      #     i += 1
      # end
      TYPES = Set.new %w(
        ARPACKException AbstractArray AbstractChannel AbstractChar
        AbstractDict AbstractDisplay AbstractFloat AbstractIrrational
        AbstractLogger AbstractMatrix AbstractREPL AbstractRNG AbstractRange
        AbstractSerializer AbstractSet AbstractSparseArray AbstractSparseMatrix
        AbstractSparseVector AbstractString AbstractUnitRange AbstractVecOrMat
        AbstractVector AbstractWorkerPool Adjoint Any ArgumentError Array
        AssertionError Base64DecodePipe Base64EncodePipe BasicREPL Bidiagonal
        BigFloat BigInt BitArray BitMatrix BitSet BitVector Bool BoundsError
        BunchKaufman CachingPool CapturedException CartesianIndex
        CartesianIndices Cchar Cdouble Cfloat Channel Char Cholesky
        CholeskyPivoted Cint Cintmax_t Clong Clonglong ClusterManager Cmd
        Colon Complex ComplexF16 ComplexF32 ComplexF64 CompositeException
        Condition ConsoleLogger Cptrdiff_t Cshort Csize_t Cssize_t Cstring
        Cuchar Cuint Cuintmax_t Culong Culonglong Cushort Cvoid Cwchar_t
        Cwstring DataType Date DateFormat DatePeriod DateTime Day DenseArray
        DenseMatrix DenseVecOrMat DenseVector Diagonal Dict DimensionMismatch
        Dims DivideError DomainError EOFError Eigen Enum ErrorException
        Exception ExponentialBackOff Expr FDWatcher Factorization FileMonitor
        Float16 Float32 Float64 FolderMonitor Function GeneralizedEigen
        GeneralizedSVD GeneralizedSchur GenericArray GenericDict GenericSet
        GenericString GitConfig GitRepo GlobalRef HMAC_CTX HTML Hermitian
        Hessenberg Hour IO IOBuffer IOContext IOStream IPAddr IPv4 IPv6
        IdDict IndexCartesian IndexLinear IndexStyle InexactError InitError
        Int Int128 Int16 Int32 Int64 Int8 Integer InterruptException
        InvalidStateException Irrational KeyError LAPACKException LDLt LQ
        LU LinRange LineEditREPL LineNumberNode LinearIndices LoadError
        LogLevel LowerTriangular MIME Matrix MersenneTwister Method
        MethodError Microsecond Millisecond Minute Missing MissingException
        Module Month NTuple NamedTuple Nanosecond Nothing NullLogger Number
        OrdinalRange OutOfMemoryError OverflowError PackageMode PackageSpec
        Pair PartialQuickSort Period PermutedDimsArray Pipe PollingFileWatcher
        PosDefException ProcessExitedException Ptr QR QRPivoted QuoteNode
        RandomDevice RankDeficientException Rational RawFD ReadOnlyMemoryError
        Real ReentrantLock Ref Regex RegexMatch RemoteChannel RemoteException
        RoundingMode SHA1_CTX SHA224_CTX SHA256_CTX SHA2_224_CTX SHA2_256_CTX
        SHA2_384_CTX SHA2_512_CTX SHA384_CTX SHA3_224_CTX SHA3_256_CTX
        SHA3_384_CTX SHA3_512_CTX SHA512_CTX SVD Schur Second SegmentationFault
        Serializer Set SharedArray SharedMatrix SharedVector Signed
        SimpleLogger SingularException Some SparseMatrixCSC SparseVector
        StackOverflowError StepRange StepRangeLen StreamREPL StridedArray
        StridedMatrix StridedVecOrMat StridedVector String StringIndexError
        SubArray SubString SubstitutionString SymTridiagonal Symbol Symmetric
        SystemError TCPSocket Task TestSetException Text TextDisplay Time
        TimePeriod TimeType TimeZone Timer Transpose Tridiagonal Tuple
        Type TypeError TypeVar UDPSocket UInt UInt128 UInt16 UInt32 UInt64
        UInt8 UTC UUID UndefInitializer UndefKeywordError UndefRefError
        UndefVarError UniformScaling Union UnionAll UnitLowerTriangular
        UnitRange UnitUpperTriangular Unsigned UpgradeLevel UpperTriangular
        Val Vararg VecElement VecOrMat Vector VersionNumber WeakKeyDict
        WeakRef Week WorkerConfig WorkerPool Year
      )
    end
  end
end
