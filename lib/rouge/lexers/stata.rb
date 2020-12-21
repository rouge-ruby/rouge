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

      # Partial list of common programming and estimation commands
	  KEYWORDS = %w(if else foreach forval to while in of continue break program define end set mata by using use sysuse insheet save
	     cap capture confirm creturn ereturn return list error estimates exit file open read write close frame
		 gettoken levelsof macro shift mkmat svmat more  pause plugin preserve restore syntax adopath tokenize trace
		 unab varabbrev version clear run do net tempfile tempvar tempname drop rename mi missing label var order compress 
		 gen generate egen replace isid duplicates di display
		 lincom test testnl predict suest 
		 reg regress probit logit ivregress logistic svy gmm ivprobit ivtobit 
	  )
	  
	  KEYWORD_TYPES = %w(byte int long float double str strL local global numlist varlist newlist scalar matrix)

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
	  
	    rule %r/\s+/m, Text::Whitespace
	  
		# Single-line comment: *
		# Ideally, this match would be anchored to start of line + optional white space
		# That would avoid matching when * is used as an operator (eg 3*5)
		#   Example: match "   * text" and "*text" but not "text*text"
		#   Solution: rule %r/^\s*\*.*$/, Comment::Single
		#   Problem: This solution above works on rubular.com, but the '^' does not match "   * text" in rouge for some reason
		# Instead, use solution below, which matchs all * comments correctly but incorrectly matches the * operator
		rule %r/\*.*$/, Comment::Single

		# in-line comment: //
		rule %r/\/\/.*?$/, Comment::Single
		
		# Multi-line comment: /* and */
		rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
		
		# Strings indicated by double-quotes
		 rule %r/"(\\.|.)*?"/, Str::Double
		
		# Format locals (`') and globals ($) as strings
		rule %r/`(\\.|.)*?'/, Str::Double
		rule %r/(?<!\w)\$\w+/, Str::Double

        rule %r/0[xX][a-fA-F0-9]+([pP][0-9]+)?[Li]?/, Num::Hex
        rule %r/[+-]?(\d+([.]\d+)?|[.]\d+)([eE][+-]?\d+)?[Li]?/, Num

        # Only recognize built-in functions when they are actually used as a
        # function call, i.e. followed by an opening parenthesis.
        # `Name::Builtin` would be more logical, but is usually not
        # highlighted specifically; thus use `Name::Function`.
        rule %r/\b(?<!.)(#{PRIMITIVE_FUNCTIONS.join('|')})(?=\()/, Name::Function

		rule %r/\w+/ do |m|
          if KEYWORDS.include? m[0]
            token Keyword
          elsif KEYWORD_TYPES.include? m[0]
            token Keyword::Type
          else
            token Name
          end
        end

        rule %r/[\[\]{}();,]/, Punctuation

		rule %r([-<>?*+^/\\!#.=~:&|]), Operator
      end
    end
  end
end
