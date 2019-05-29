# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Julia < RegexLexer
      title "Julia"
      desc "The Julia programming language"
      tag 'julia'
      aliases 'jl'
      filenames '*.jl'
      mimetypes 'text/x-julia', 'application/x-julia'

      def self.detect?(text)
        return true if text.shebang? 'julia'
      end

      BUILTINS            = /\b(?:
                              true      | false    | missing | nothing
                            | Inf       | Inf16    | Inf32   | Inf64
                            | NaN       | NaN16    | NaN32   | NaN64
                            | stdout    | stderr   | stdin   | devnull
                            | pi        | π        | ℯ       | im
                            | ARGS      | C_NULL   | ENV     | ENDIAN_BOM
                            | VERSION   | undef    | (LOAD|DEPOT)_PATH
                            )\b/x

      KEYWORDS            = /\b(?:
                              function | return | module | import | export
                            | if       | else   | elseif | end    | for
                            | in       | isa    | while  | try    | catch
                            | const    | local  | global | using  | struct
                            | mutable struct    | abstract type   | finally
                            | begin    | do     | quote  | macro  | for outer
                            | where
                            )\b/x

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
      #     print("| ", sym)
      #     i % 3 == 0 ? println() : print(" ") # print 3 to a line
      #     i += 1
      # end
      TYPES               = /\b(?:
                              ARPACKException | AbstractArray | AbstractChannel
                            | AbstractChar | AbstractDict | AbstractDisplay
                            | AbstractFloat | AbstractIrrational | AbstractLogger
                            | AbstractMatrix | AbstractREPL | AbstractRNG
                            | AbstractRange | AbstractSerializer | AbstractSet
                            | AbstractSparseArray | AbstractSparseMatrix | AbstractSparseVector
                            | AbstractString | AbstractUnitRange | AbstractVecOrMat
                            | AbstractVector | AbstractWorkerPool | Adjoint
                            | Any | ArgumentError | Array
                            | AssertionError | Base64DecodePipe | Base64EncodePipe
                            | BasicREPL | Bidiagonal | BigFloat
                            | BigInt | BitArray | BitMatrix
                            | BitSet | BitVector | Bool
                            | BoundsError | BunchKaufman | CachingPool
                            | CapturedException | CartesianIndex | CartesianIndices
                            | Cchar | Cdouble | Cfloat
                            | Channel | Char | Cholesky
                            | CholeskyPivoted | Cint | Cintmax_t
                            | Clong | Clonglong | ClusterManager
                            | Cmd | Colon | Complex
                            | ComplexF16 | ComplexF32 | ComplexF64
                            | CompositeException | Condition | ConsoleLogger
                            | Cptrdiff_t | Cshort | Csize_t
                            | Cssize_t | Cstring | Cuchar
                            | Cuint | Cuintmax_t | Culong
                            | Culonglong | Cushort | Cvoid
                            | Cwchar_t | Cwstring | DataType
                            | Date | DateFormat | DatePeriod
                            | DateTime | Day | DenseArray
                            | DenseMatrix | DenseVecOrMat | DenseVector
                            | Diagonal | Dict | DimensionMismatch
                            | Dims | DivideError | DomainError
                            | EOFError | Eigen | Enum
                            | ErrorException | Exception | ExponentialBackOff
                            | Expr | FDWatcher | Factorization
                            | FileMonitor | Float16 | Float32
                            | Float64 | FolderMonitor | Function
                            | GeneralizedEigen | GeneralizedSVD | GeneralizedSchur
                            | GenericArray | GenericDict | GenericSet
                            | GenericString | GitConfig | GitRepo
                            | GlobalRef | HMAC_CTX | HTML
                            | Hermitian | Hessenberg | Hour
                            | IO | IOBuffer | IOContext
                            | IOStream | IPAddr | IPv4
                            | IPv6 | IdDict | IndexCartesian
                            | IndexLinear | IndexStyle | InexactError
                            | InitError | Int | Int128
                            | Int16 | Int32 | Int64
                            | Int8 | Integer | InterruptException
                            | InvalidStateException | Irrational | KeyError
                            | LAPACKException | LDLt | LQ
                            | LU | LinRange | LineEditREPL
                            | LineNumberNode | LinearIndices | LoadError
                            | LogLevel | LowerTriangular | MIME
                            | Matrix | MersenneTwister | Method
                            | MethodError | Microsecond | Millisecond
                            | Minute | Missing | MissingException
                            | Module | Month | NTuple
                            | NamedTuple | Nanosecond | Nothing
                            | NullLogger | Number | OrdinalRange
                            | OutOfMemoryError | OverflowError | PackageMode
                            | PackageSpec | Pair | PartialQuickSort
                            | Period | PermutedDimsArray | Pipe
                            | PollingFileWatcher | PosDefException | ProcessExitedException
                            | Ptr | QR | QRPivoted
                            | QuoteNode | RandomDevice | RankDeficientException
                            | Rational | RawFD | ReadOnlyMemoryError
                            | Real | ReentrantLock | Ref
                            | Regex | RegexMatch | RemoteChannel
                            | RemoteException | RoundingMode | SHA1_CTX
                            | SHA224_CTX | SHA256_CTX | SHA2_224_CTX
                            | SHA2_256_CTX | SHA2_384_CTX | SHA2_512_CTX
                            | SHA384_CTX | SHA3_224_CTX | SHA3_256_CTX
                            | SHA3_384_CTX | SHA3_512_CTX | SHA512_CTX
                            | SVD | Schur | Second
                            | SegmentationFault | Serializer | Set
                            | SharedArray | SharedMatrix | SharedVector
                            | Signed | SimpleLogger | SingularException
                            | Some | SparseMatrixCSC | SparseVector
                            | StackOverflowError | StepRange | StepRangeLen
                            | StreamREPL | StridedArray | StridedMatrix
                            | StridedVecOrMat | StridedVector | String
                            | StringIndexError | SubArray | SubString
                            | SubstitutionString | SymTridiagonal | Symbol
                            | Symmetric | SystemError | TCPSocket
                            | Task | TestSetException | Text
                            | TextDisplay | Time | TimePeriod
                            | TimeType | TimeZone | Timer
                            | Transpose | Tridiagonal | Tuple
                            | Type | TypeError | TypeVar
                            | UDPSocket | UInt | UInt128
                            | UInt16 | UInt32 | UInt64
                            | UInt8 | UTC | UUID
                            | UndefInitializer | UndefKeywordError | UndefRefError
                            | UndefVarError | UniformScaling | Union
                            | UnionAll | UnitLowerTriangular | UnitRange
                            | UnitUpperTriangular | Unsigned | UpgradeLevel
                            | UpperTriangular | Val | Vararg
                            | VecElement | VecOrMat | Vector
                            | VersionNumber | WeakKeyDict | WeakRef
                            | Week | WorkerConfig | WorkerPool
                            | Year
                            )\b/x

      OPERATORS           = / \+      | =        | -     | \*   | \/
                              | \\    | &        | \|    | \$   | ~
                              | \^    | %        | !     | >>>  | >>
                              | <<    | &&       | \|\|  | \+=  | -=
                              | \*=   | \/=      | \\=   | ÷=   | %=
                              | \^=   | &=       | \|=   | \$=  | >>>=
                              | >>=   | <<=      | ==    | !=   | ≠
                              | <=    | ≤        | >=    | ≥    | \.
                              | ::    | <:       | ->    | \?   | \.\*
                              | \.\^  | \.\\     | \.\/  | \\   | <
                              | >     | ÷        | >:    | :    | ===
                              | !==   | =>
                            /x

      PUNCTUATION         = / [ \[ \] { } \( \) , ; ] /x


      state :root do
        rule /\n/, Text
        rule /[^\S\n]+/, Text
        rule /#=/, Comment::Multiline, :blockcomment
        rule /#.*$/, Comment
        rule OPERATORS, Operator
        rule /\\\n/, Text
        rule /\\/, Text


        # functions and macros
        rule /(function|macro)((?:\s|\\\s)+)/ do
          groups Keyword, Name::Function
          push :funcname
        end

        # types
        rule /((mutable )?struct|(abstract|primitive) type)((?:\s|\\\s)+)/ do
          groups Keyword, Name::Class
          push :typename
        end
        rule TYPES, Keyword::Type

        # keywords
        rule /(local|global|const)\b/, Keyword::Declaration
        rule KEYWORDS, Keyword

        # TODO: end is a builtin when inside of an indexing expression
        rule BUILTINS, Name::Builtin

        # TODO: symbols

        # backticks
        rule /`.*?`/, Literal::String::Backtick

        # chars
        rule /'(\\.|\\[0-7]{1,3}|\\x[a-fA-F0-9]{1,3}|\\u[a-fA-F0-9]{1,4}|\\U[a-fA-F0-9]{1,6}|[^\\\'\n])'/, Literal::String::Char

        # try to match trailing transpose
        rule /(?<=[.\w)\]])\'+/, Operator

        # strings
        # TODO: triple quoted string literals
        # TODO: Detect string interpolation
        rule /(?:[IL])"/, Literal::String, :string
        rule /[E]?"/, Literal::String, :string

        # names
        rule /@[\w.]+/, Name::Decorator
        rule /(?:[a-zA-Z_\u00A1-\uffff]|[\u1000-\u10ff])(?:[a-zA-Z_0-9\u00A1-\uffff]|[\u1000-\u10ff])*!*/, Name

        rule PUNCTUATION, Other

        # numbers
        rule /(\d+(_\d+)+\.\d*|\d*\.\d+(_\d+)+)([eEf][+-]?[0-9]+)?/, Literal::Number::Float
        rule /(\d+\.\d*|\d*\.\d+)([eEf][+-]?[0-9]+)?/, Literal::Number::Float
        rule /\d+(_\d+)+[eEf][+-]?[0-9]+/, Literal::Number::Float
        rule /\d+[eEf][+-]?[0-9]+/, Literal::Number::Float
        rule /0b[01]+(_[01]+)+/, Literal::Number::Bin
        rule /0b[01]+/, Literal::Number::Bin
        rule /0o[0-7]+(_[0-7]+)+/, Literal::Number::Oct
        rule /0o[0-7]+/, Literal::Number::Oct
        rule /0x[a-fA-F0-9]+(_[a-fA-F0-9]+)+/, Literal::Number::Hex
        rule /0x[a-fA-F0-9]+/, Literal::Number::Hex
        rule /\d+(_\d+)+/, Literal::Number::Integer
        rule /\d+/, Literal::Number::Integer
      end


      state :funcname do
        rule /[a-zA-Z_]\w*/, Name::Function, :pop!
        rule /\([^\s\w{]{1,2}\)/, Operator, :pop!
        rule /[^\s\w{]{1,2}/, Operator, :pop!
      end

      state :typename do
        rule /[a-zA-Z_]\w*/, Name::Class, :pop!
      end

      state :stringescape do
        rule /\\([\\abfnrtv"\']|\n|N\{.*?\}|u[a-fA-F0-9]{4}|U[a-fA-F0-9]{8}|x[a-fA-F0-9]{2}|[0-7]{1,3})/,
          Literal::String::Escape
      end

      state :blockcomment do
        rule /[^=#]/, Comment::Multiline
        rule /#=/, Comment::Multiline, :blockcomment
        rule /\=#/, Comment::Multiline, :pop!
        rule /[=#]/, Comment::Multiline
      end

      state :string do
        mixin :stringescape

        rule /"/, Literal::String, :pop!
        rule /\\\\|\\"|\\\n/, Literal::String::Escape  # included here for raw strings
        rule /\$(\(\w+\))?[-#0 +]*([0-9]+|[*])?(\.([0-9]+|[*]))?/, Literal::String::Interpol
        rule /[^\\"$]+/, Literal::String
        # quotes, dollar signs, and backslashes must be parsed one at a time
        rule /["\\]/, Literal::String
        # unhandled string formatting sign
        rule /\$/, Literal::String
      end
    end
  end
end
