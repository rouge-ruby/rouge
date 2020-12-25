# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Stata < RegexLexer
	  title "Stata"
      desc "The Stata programming language (www.stata.com)"
      tag 'stata'
      filenames '*.do', '*.ado'
	  mimetypes 'application/x-stata', 'text/x-stata'

      # Note: types `str1-str2045` handled separately below
      KEYWORD_TYPES = %w(byte int long float double str strL numeric string integer scalar matrix local global numlist varlist newlist)
	  	  
      # Stata commands used with braces
	  KEYWORDS_RESERVED = %w(if else foreach forval to while in of continue break nobreak)

      # Partial list of common programming and estimation commands, as of Stata 16
	  # Note: not all abbreviations are included
	  KEYWORDS = %w(
	    do run include clear assert
		set mata on off
	    by cap capt capture char class classutil which cdir confirm new existence creturn 
	    _datasignature discard di dis disp displ displa display ereturn error _estimates exit file open read write seek close query findfile fvexpand
	    gettoken java home heapmax java_heapmax initialize javacall levelsof 
 	    tempvar tempname tempfile macro shift uniq dups retokenize clean sizeof posof
  	    makecns matcproc marksample mark markout markin svymarkout matlist
	    accum define dissimilarity eigenvalues get rowjoinbyname rownames score svd symeigen dir list ren rename
	    more pause plugin call postfile _predict preserve restore program define drop end python qui quietly _return return _rmcoll rmsg _robust 
	    serset locale_functions locale_ui signestimationsample checkestimationsample sleep syntax sysdir adopath adosize
	    tabdisp timer tokenize trace unab unabcmd varabbrev version viewsource 
	    window fopen fsave manage menu push stopbox
	    net from cd link search install sj stb ado update uninstall pwd ssc ls
	    using insheet mkmat svmat summ summarize
		graph twoway histogram 
		mi miss missing var varname order compress append
		gen gene gener genera generat generate egen replace duplicates
		estimates  lincom test testnl predict suest 
		_regress reg regr regre regres regress probit logit ivregress logistic svy gmm ivprobit ivtobit
		bsample assert codebook collapse compare contract copy count cross datasignature d ds desc describe destring tostring
		drawnorm edit encode decode erase expand export filefilter fillin format frame frget frlink gsort 
		import dbase delimited excel fred haver sas sasxport5 sasxport8 spss infile infix input insobs inspect ipolate isid
		joinby label language labelbook lookfor memory mem merge mkdir mvencode notes obs odbc order outfile
		pctile putmata range recast recode rename group reshape rmdir sample save separate shell snapshot sort split splitsample stack statsby sysuse 
		type unicode use varmanage vl webuse xpose zipfile 
		number
	  )
	  
      # Complete list of functions by name, as of Stata 16
      PRIMITIVE_FUNCTIONS = %w(
        abbrev abs acos acosh age age_frac asin asinh atan atan2 atanh autocode
		betaden binomial bino#mialp binomialtail binormal birthday bofd byteorder
		c _caller cauchy cauchyden cauchytail Cdhms ceil char chi2 chi2den chi2tail Chms 
		chop cholesky clip Clock clock clockdiff cloglog Cmdyhms Cofc cofC Cofd cofd coleqnumb 
		collatorlocale collatorversion colnfreeparms colnumb colsof comb cond corr cos cosh 
		daily date datediff datediff_frac day det dgammapda dgammapdada dgammapdadx dgammapdxdx dhms 
		diag diag0cnt digamma dofb dofC dofc dofh dofm dofq dofw dofy dow doy dunnettprob e el epsdouble
		epsfloat exp expm1 exponential exponentialden exponentialtail 
		F Fden fileexists fileread filereaderror filewrite float floor fmtwidth frval _frval Ftail 
		fammaden gammap gammaptail get hadamard halfyear halfyearly has_eprop hh hhC hms hofd hours 
		hypergeometric hypergeometricp 
		I ibeta ibetatail igaussian igaussianden igaussiantail indexnot inlist inrange int inv invbinomial invbinomialtail
		invcauchy invcauchytail invchi2 invchi2tail invcloglog invdunnettprob invexponential invexponentialtail invF
		invFtail invgammap invgammaptail invibeta invibetatail invigaussian invigaussiantail invlaplace invlaplacetail
		invlogistic invlogistictail invlogit invnbinomial invnbinomialtail invnchi2 invnchi2tail invnF invnFtail invnibeta invnormal invnt invnttail 
		invpoisson invpoissontail invsym invt invttail invtukeyprob invweibull invweibullph invweibullphtail invweibulltail irecode islepyear issymmetric 
		J laplace laplaceden laplacetail ln ln1m ln1p lncauchyden lnfactorial lngamma lnigammaden lnigaussianden lniwishartden lnlaplaceden lnmvnormalden 
		lnnormal lnnormalden lnnormalden lnnormalden lnwishartden log log10 log1m log1p logistic logisticden logistictail logit
		matmissing matrix matuniform max maxbyte maxdouble maxfloat maxint maxlong mdy mdyhms mi min minbyte mindouble minfloat minint minlong minutes
		missing mm mmC mod mofd month monthly mreldif msofhours msofminutes msofseconds 
		nbetaden nbinomial nbinomialp nbinomialtail nchi2 nchi2den nchi2tail nextbirthday nextleapyear nF nFden nFtail nibeta
		normal normalden npnchi2 npnF npnt nt ntden nttail nullmat
		plural poisson poissonp poissontail previousbirthday previousleapyear qofd quarter quarterly r rbeta rbinomial rcauchy rchi2 recode
		real regexm regexr regexs reldif replay return rexponential rgamma rhypergeometric rigaussian rlaplace rlogistic rnormal
		round roweqnumb rownfreeparms rownumb rowsof rpoisson rt runiform runiformint rweibull rweibullph
		s scalar seconds sign sin sinh smallestdouble soundex soundex_nara sqrt ss ssC strcat strdup string stritrim strlen strlower 
		strltrim strmatch strofreal strpos strproper strreverse strrpos strrtrim strtoname strtrim strupper subinstr subinword substr sum sweep 
		t tan tanh tC tc td tden th tin tm tobytes tq trace trigamma trunc ttail tukeyprob tw twithin 
		uchar udstrlen udsubstr uisdigit uisletter uniform ustrcompare ustrcompareex ustrfix ustrfrom ustrinvalidcnt ustrleft ustrlen ustrlower
		ustrltrim ustrnormalize ustrpos ustrregexm ustrregexra ustrregexrf ustrregexs ustrreverse ustrright ustrrpos ustrrtrim ustrsortkey
		ustrsortkeyex ustrtitle ustrto ustrtohex ustrtoname ustrtrim ustrunescape ustrupper ustrword ustrwordcount usubinstr usubstr
		vec vecdiag week weekly weibull weibullden weibullph weibullphden weibullphtail weibulltail wofd word wordbreaklocale wordcount
		year yearly yh ym yofd yq yw 
      )
	
      state :root do
	  
		# Pre-processor commands: #
		rule %r/^\s*#.*$/, Comment::Preproc
		
		# Hashbang comments: *!
		rule %r/^\*!.*$/, Comment::Hashbang

		# Single-line comment: *
		rule %r/^\s*\*.*$/, Comment::Single
		
		# Keywords: recognize only when they are the first word
		rule %r/^\s*(#{KEYWORDS.join('|')})\b/, Keyword		
		
		# Whitespace. Classify `\n` as `Text` to avoid interference with single-line comment `*` and `Keyword`
		rule(/[ \t]+/, Text::Whitespace)		
		rule(/[\n]+/, Text)

		# in-line comment: //
		rule %r/\/\/.*?$/, Comment::Single
		
		# Multi-line comment: /* and */
		rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
		
		# Strings indicated by compound double-quotes and double-quotes
		rule %r/`"(\\.|.)*?"'/, Str::Double
		rule %r/"(\\.|.)*?"/, Str::Double
		
		# Format locals (`') and globals ($) as strings
		rule %r/`(\\.|.)*?'/, Str::Double
		rule %r/(?<!\w)\$\w+/, Str::Double

		# Numbers: regular, hex, %fmt
        rule %r/[+-]?(\d+([.]\d+)?|[.]\d+)([eE][+-]?\d+)?[Li]?/, Num
		rule %r/0[xX][a-fA-F0-9]+([pP][0-9]+)?[Li]?/, Num::Hex
		rule %r/\%\S+/, Name::Property
		
		# Additional types: str1-str2045
		rule %r/\s*str(204[0-5]|20[0-3][0-9]|[01][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[1-9])\b/, Keyword::Type

        # Only recognize primitive functions when they are actually used as a function call, i.e. followed by an opening parenthesis
        # `Name::Builtin` would be more logical, but is not usually highlighted; thus use `Name::Function`
        rule %r/\b(?<!.)(#{PRIMITIVE_FUNCTIONS.join('|')})(?=\()/, Name::Function
		
		rule %r/\w+/ do |m|
          if KEYWORDS_RESERVED.include? m[0]
            token Keyword::Reserved	
          elsif KEYWORD_TYPES.include? m[0]
            token Keyword::Type
          else
            token Name
          end
		end

        rule %r/[\[\]{}();,]/, Punctuation

		rule %r([-<>?*+'^/\\!#.=~:&|]), Operator
      end
    end
  end
end
