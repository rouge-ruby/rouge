module Rouge
  module Lexers
    class Stata
      ###
      # Stata reference manual is available online at: https://www.stata.com/features/documentation/
      ###

      # Partial list of common programming and estimation commands, as of Stata 16
      # Note: not all abbreviations are included
      KEYWORDS = Set.new %w(
        do run include clear assert set mata log
        by bys bysort cap capt capture char class classutil which cdir confirm new existence creturn
        _datasignature discard di dis disp displ displa display ereturn error _estimates exit file open read write seek close query findfile fvexpand
        gettoken java home heapmax java_heapmax icd9 icd9p icd10 icd10cm icd10pcs initialize javacall levelsof
        tempvar tempname tempfile macro shift uniq dups retokenize clean sizeof posof
        makecns matcproc marksample mark markout markin svymarkout matlist
        accum define dissimilarity eigenvalues get rowjoinbyname rownames score svd symeigen dir list ren rename
        more pause plugin call postfile _predict preserve restore program define drop end python qui quietly noi noisily _return return _rmcoll rmsg _robust
        serset locale_functions locale_ui signestimationsample checkestimationsample sleep syntax sysdir adopath adosize
        tabdisp timer tokenize trace unab unabcmd varabbrev version viewsource
        window fopen fsave manage menu push stopbox
        net from cd link search install sj stb ado update uninstall pwd ssc ls
        using insheet outsheet mkmat svmat sum summ summarize
        graph gr_edit twoway histogram kdensity spikeplot
        mi miss missing var varname order compress append
        gen gene gener genera generat generate egen replace duplicates
        estimates nlcom lincom test testnl predict suest
        _regress reg regr regre regres regress probit logit ivregress logistic svy gmm ivprobit ivtobit
        bsample assert codebook collapse compare contract copy count cross datasignature d ds desc describe destring tostring
        drawnorm edit encode decode erase expand export filefilter fillin format frame frget frlink gsort
        import dbase delimited excel fred haver sas sasxport5 sasxport8 spss infile infix input insobs inspect ipolate isid
        joinby label language labelbook lookfor memory mem merge mkdir mvencode notes obs odbc order outfile
        pctile xtile _pctile putmata range recast recode rename group reshape rm rmdir sample save saveold separate shell snapshot sort split splitsample stack statsby sysuse
        type unicode use varmanage vl webuse xpose zipfile
        number keep tab table tabulate stset stcox tsset xtset
      )

      # Complete list of functions by name, as of Stata 16
      PRIMITIVE_FUNCTIONS = Set.new %w(
        abbrev abs acos acosh age age_frac asin asinh atan atan2 atanh autocode
        betaden binomial binomialp binomialtail binormal birthday bofd byteorder
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

      # Note: types `str1-str2045` handled separately below
      TYPE_KEYWORDS = Set.new %w(
        byte int long float double str strL numeric string integer scalar matrix
        local global numlist varlist newlist
      )

      # Stata commands used with braces. Includes all valid abbreviations for 'forvalues'.
      RESERVED_KEYWORDS = Set.new %w(
        if else foreach forv forva forval forvalu forvalue forvalues to while
        in of continue break nobreak
      )
    end
  end
end
