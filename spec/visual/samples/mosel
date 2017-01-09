(!******************************************************
   Mosel Example Problems
   ======================

   file runfolio.mos
   `````````````````
   Master model running portfolio optimization model.

   Runs model foliomemio.mos.
   -- Data input/output in memory --
      
  (c) 2009 Fair Isaac Corporation
      author: S.Heipcke, Jan. 2009
*******************************************************!)

model "Run portfolio optimization model"
 uses "mmjobs"                       ! Use multiple model handling
 uses "mmsystem", "mmxprs"

 parameters
  MODELFILE = "foliomemio.mos"       ! Optimization model
  INPUTFILE = "folio10.dat"          ! File with problem data
 
  MAXRISK = 1/3                      ! Max. investment into high-risk values
  MINREG = 0.2                       ! Min. investment per geogr. region
  MAXREG = 0.5                       ! Max. investment per geogr. region
  MAXSEC = 0.25                      ! Max. investment per ind. sector
  MAXVAL = 0.2                       ! Max. investment per share
  MINVAL = 0.1                       ! Min. investment per share
  MAXNUM = 15                        ! Max. number of different assets
 end-parameters
 
 forward procedure write_html_results

 declarations
  SHARES: set of string              ! Set of shares
  RISK: set of string                ! Set of high-risk values among shares
  REGIONS: set of string             ! Geographical regions
  TYPES: set of string               ! Share types (ind. sectors)
  LOCTAB: dynamic array(REGIONS,SHARES) of boolean ! Shares per geogr. region
  RET: array(SHARES) of real         ! Estimated return in investment
  SECTAB: dynamic array(TYPES,SHARES) of boolean ! Shares per industry sector

  returnsol: real                    ! Solution values
  numsharessol,status: integer
  fracsol: array(SHARES) of real     ! Fraction of capital used per share
  buysol: array(SHARES) of real      ! 1 if asset is in portfolio, 0 otherwise

  foliomod: Model
 end-declarations

! Compile and load the optimization model
 if compile("", MODELFILE, "shmem:bim") <> 0 then
  writeln("Error during model compilation")
  exit(1)
 end-if
 load(foliomod, "shmem:bim")
 fdelete("shmem:bim")

! Read in data from file
 initializations from INPUTFILE
  RISK RET LOCTAB SECTAB
 end-initializations

! Save data to memory
 initializations to "raw:"
  RISK as 'shmem:RISK'
  RET as 'shmem:RET'
  LOCTAB as 'shmem:LOCTAB'
  SECTAB as 'shmem:SECTAB'
 end-initializations

 run(foliomod, "MAXRISK=" + MAXRISK + ",MINREG=" + MINREG + 
  ",MAXREG=" + MAXREG + ",MAXSEC=" + MAXSEC +
  ",MAXVAL=" + MAXVAL + ",MINVAL=" + MINVAL +
  ",MAXNUM=" + MAXNUM + ",DATAFILE='raw:',OUTPUTFILE='raw:'," +
  "RISKDATA='shmem:RISK',RETDATA='shmem:RET',LOCDATA='shmem:LOCTAB'," +
  "SECDATA='shmem:SECTAB',FRACSOL='shmem:FRAC',BUYSOL='shmem:BUY'," +
  "NUMSHARES='shmem:NUMSHARES',RETSOL='shmem:RETSOL'," +
  "SOLSTATUS='shmem:SOLSTATUS'")
  wait                              ! Wait for model termination
  dropnextevent                     ! Ignore termination event message

 initializations from  "raw:"
  returnsol as 'shmem:RETSOL'
  numsharessol as 'shmem:NUMSHARES'
  fracsol as 'shmem:FRAC'
  buysol as 'shmem:BUY'
  status as 'shmem:SOLSTATUS'
 end-initializations

 case status of
  XPRS_OPT: writeln("Problem solved to optimality")
  XPRS_UNF: writeln("Problem solving unfinished")
  XPRS_INF: writeln("Problem is infeasible")
  XPRS_UNB,XPRS_OTH:  writeln("No solution available")
 end-case 

 ! Solution printing
 writeln("Total return: ", returnsol)
 writeln("Number of shares: ", numsharessol)
 forall(s in SHARES | fracsol(s)>0)
  writeln(s, ": ", fracsol(s)*100, "% (", buysol(s), ")")
 
 write_html_results

! *********** Writing an HTML result file ***********
 procedure write_html_results
  setparam("datetimefmt", "%0d-%N-%y, %0H:%0M:%0S")

  HTMLFILE:= INPUTFILE + "_sol.html"
  fopen(HTMLFILE, F_OUTPUT)
  writeln("<html>")
  writeln("<head>")
  writeln("<style type='text/css'>")
  writeln("body {font-family: Verdana, Geneva, Helvetica, Arial, sans-serif; color: 000055 }")
  writeln("table td {background-color: ffffaa; text-align: left }")
  writeln("table th {background-color: 053055; color: ffcc88}")
 writeln("</style>")
  writeln("</head>")

  writeln("<body>")
  writeln("<center><h2>Portfolio Optimization Results</h2></center>")
  writeln("<table width='100%' cellpadding='5' cellspacing='0' border=0>")
  writeln("<tr><td width='55%'><font color='#000055'><b>Total return: ",
          returnsol, "</b></font></td><td><font color='#885533'><b>Problem instance: ",
          INPUTFILE,"</b></font></td></tr>")
  writeln("<tr><td><font color='#000055'><b>Number of shares: ", numsharessol, "</b></font></td><td><font color='#885533'><b>Date: ", datetime(SYS_NOW),"</b></font></td></tr>")
  writeln("<tr><td colspan='2'>&nbsp;</td></tr>")
  writeln("</table>")

  writeln("<table cellpadding='2' cellspacing='1' width='100%'>")
  writeln("<tr><th>Value</th><th>Percentage</th></tr>")
 forall(s in SHARES | fracsol(s)>0) 
   writeln("<tr><td>", s, "</td><td>", strfmt(fracsol(s)*100,4,2), 
           "%</td></tr>")
  writeln("</table>")
  writeln("</body>")
  writeln("</html>")
  fclose(F_OUTPUT)
 end-procedure

! Test multiple strings escaping

  writeln("Reading 'KnapsackData.txt' ... ")
  writeln("Reading \"KnapsackData.txt\" ... ")
  writeln('Reading "KnapsackData.txt" ... ')
  writeln("A double-quote string with a escape\nbreakline")
  writeln('A single-quote string with a escape\nbreakline which should be ignored')
  writeln("The letter q has octal code 161 can written as \161. But \229 is not a valid octal number")
! Multiline strings
  writeln("This is
    a multi-line
    string with three lines")
  writeln("Reading 
    file 'KnapsackData.txt' ... ")
  writeln('Reading 
    file "KnapsackData.txt" ... ')


end-model
