module Rouge
  module Lexers
    class Matlab < RegexLexer
      desc "Matlab"
      tag 'matlab'
      aliases 'm'
      filenames '*.m'
      mimetypes 'text/x-matlab', 'application/x-matlab'

      def self.analyze_text(text)
        return 0.51 if text.match(/^\s*% /) # % comments are a dead giveaway
      end

      keywords = %w(
        break case catch classdef continue else elseif end for function
        global if otherwise parfor persistent return spmd switch try while
      )

      builtins = %w(
        ans clc diary format home iskeyword more commandhistory commandwindow accumarray
        blkdiag diag eye false freqspace linspace logspace meshgrid ndgrid ones
        rand true zeros cat horzcat vertcat colon end ind2sub sub2ind
        length ndims numel size height width iscolumn isempty ismatrix isrow
        isscalar isvector blkdiag circshift ctranspose diag flip flipdim fliplr flipud
        ipermute permute repmat reshape rot90 shiftdim issorted sort sortrows squeeze
        transpose vectorize plus uplus minus uminus times rdivide ldivide power
        mtimes mrdivide mldivide mpower cumprod cumsum diff prod sum ceil
        fix floor idivide mod rem round eq ge gt le
        lt ne isequal isequaln and not or xor all any
        false find islogical logical true intersect ismember issorted setdiff setxor
        union unique join innerjoin outerjoin bitand bitcmp bitget bitor bitset
        bitshift bitxor swapbytes colon double single int8 int16 int32 int64
        uint8 uint16 uint32 uint64 cast typecast isinteger isfloat isnumeric isreal
        isfinite isinf isnan eps flintmax intmax intmin realmax realmin blanks
        cellstr char iscellstr ischar sprintf strcat strjoin ischar isletter isspace
        isstrprop sscanf strfind strrep strsplit strtok validatestring symvar regexp regexpi
        regexprep regexptranslate strcmp strcmpi strncmp strncmpi blanks deblank strtrim lower
        upper strjust categorical iscategorical categories iscategory isordinal isprotected addcats mergecats
        removecats renamecats reordercats summary countcats isundefined table array2table cell2table struct2table
        table2array table2cell table2struct readtable writetable istable height width summary intersect
        ismember setdiff setxor unique union join innerjoin outerjoin sortrows stack
        unstack ismissing standardizeMissing varfun rowfun struct fieldnames getfield isfield isstruct
        orderfields rmfield setfield arrayfun structfun cell2struct struct2cell cell cell2mat cell2struct
        celldisp cellfun cellplot cellstr iscell iscellstr mat2cell num2cell strjoin strsplit
        struct2cell feval func2str str2func localfunctions functions isKey keys remove values
        append get getdatasamplesize getqualitydesc getsamples plot set timeseries addsample ctranspose
        delsample detrend filter getabstime getinterpmethod getsampleusingtime idealfilter resample setabstime setinterpmethod
        synchronize transpose addevent delevent gettsafteratevent gettsafterevent gettsatevent gettsbeforeatevent gettsbeforeevent gettsbetweenevents
        iqr max mean median min std sum var plot tscollection
        addsampletocollection addts delsamplefromcollection gettimeseriesnames removets settimeseriesnames is* isa iscategorical iscell
        iscellstr ischar isfield isfloat ishghandle isinteger isjava islogical isnumeric isobject
        isreal isscalar isstr isstruct istable isvector class validateattributes whos char
        int2str mat2str num2str str2double str2num native2unicode unicode2native base2dec bin2dec dec2base
        dec2bin dec2hex hex2dec hex2num num2hex table2array table2cell table2struct array2table cell2table
        struct2table cell2mat cell2struct cellstr mat2cell num2cell struct2cell datenum datevec datestr
        now clock date calendar eomday weekday addtodate etime plus uplus
        minus uminus times rdivide ldivide power mtimes mrdivide mldivide mpower
        cumprod cumsum diff prod sum ceil fix floor idivide mod
        rem round sin sind asin asind sinh asinh cos cosd
        acos acosd cosh acosh tan tand atan atand atan2 atan2d
        tanh atanh csc cscd acsc acscd csch acsch sec secd
        asec asecd sech asech cot cotd acot acotd coth acoth
        hypot exp expm1 log log10 log1p log2 nextpow2 nthroot pow2
        reallog realpow realsqrt sqrt abs angle complex conj cplxpair i
        imag isreal j real sign unwrap factor factorial gcd isprime
        lcm nchoosek perms primes poly polyder polyeig polyfit polyint polyval
        polyvalm residue roots airy besselh besseli besselj besselk bessely beta
        betainc betaincinv betaln ellipj ellipke erf erfc erfcinv erfcx erfinv
        expint gamma gammainc gammaincinv gammaln legendre psi cart2pol cart2sph pol2cart
        sph2cart eps flintmax i j pi isfinite isinf isnan compan
        gallery hadamard hankel hilb invhilb magic pascal rosser toeplitz vander
        wilkinson cross dot kron surfnorm tril triu transpose cond condest
        funm inv linsolve lscov lsqnonneg pinv rcond mldivide mrdivide chol
        ichol cholupdate ilu lu qr qrdelete qrinsert qrupdate planerot ldl
        cdf2rdf rsf2csf gsvd svd balance cdf2rdf condeig eig eigs gsvd
        hess ordeig ordqz ordschur poly polyeig qz rsf2csf schur sqrtm
        ss2tf svd svds cond condeig det norm normest null orth
        rank rcond rref subspace trace expm logm sqrtm bsxfun arrayfun
        accumarray mpower corrcoef cov max mean median min mode std
        var rand randn randi randperm rng interp1 griddedInterpolant pchip spline
        ppval mkpp unmkpp padecoef interpft interp2 interp3 interpn griddedInterpolant ndgrid
        meshgrid griddata griddatan scatteredInterpolant fminbnd fminsearch fzero lsqnonneg optimget optimset
        ode45 ode15s ode23 ode113 ode23t ode23tb ode23s ode15i decic odextend
        odeget odeset deval bvp4c bvp5c bvpinit bvpxtend bvpget bvpset deval
        dde23 ddesd ddensd ddeget ddeset deval pdepe pdeval integral integral2
        integral3 quadgk quad2d cumtrapz trapz polyint del2 diff gradient polyder
        abs angle cplxpair fft fft2 fftn fftshift fftw ifft ifft2
        ifftn ifftshift nextpow2 unwrap conv conv2 convn deconv detrend filter
        filter2 spdiags speye sprand sprandn sprandsym sparse spconvert issparse nnz
        nonzeros nzmax spalloc spfun spones spparms spy find full amd
        colamd colperm dmperm randperm symamd symrcm condest eigs ichol ilu
        normest spaugment sprank svds bicg bicgstab bicgstabl cgs gmres lsqr
        minres pcg qmr symmlq tfqmr etree etreeplot gplot symbfact treelayout
        treeplot unmesh triangulation tetramesh trimesh triplot trisurf delaunayTriangulation delaunay delaunayn
        tetramesh trimesh triplot trisurf triangulation delaunayTriangulation dsearchn tsearchn delaunay delaunayn
        convhull convhulln patch trisurf patch voronoi voronoin polyarea inpolygon rectint
        plot plotyy plot3 loglog semilogx semilogy errorbar fplot ezplot ezplot3
        bar bar3 barh bar3h hist histc rose pareto area pie
        pie3 stem stairs stem3 scatter scatter3 spy plotmatrix polar rose
        compass ezpolar contour contourf contourc contour3 contourslice ezcontour ezcontourf feather
        quiver compass quiver3 streamslice streamline surf surfc surface surfl surfnorm
        mesh meshc meshz waterfall ribbon contour3 peaks cylinder ellipsoid sphere
        pcolor surf2patch ezsurf ezsurfc ezmesh ezmeshc contourslice flow isocaps isocolors
        isonormals isosurface reducepatch reducevolume shrinkfaces slice smooth3 subvolume volumebounds coneplot
        curl divergence interpstreamspeed stream2 stream3 streamline streamparticles streamribbon streamslice streamtube
        fill fill3 patch surf2patch movie noanimate drawnow refreshdata frame2im getframe
        im2frame comet comet3 title xlabel ylabel zlabel clabel datetick texlabel
        legend colorbar xlim ylim zlim box grid daspect pbaspect axes
        axis subplot hold gca cla annotation text legend title xlabel
        ylabel zlabel datacursormode ginput gtext colormap colormapeditor colorbar brighten contrast
        shading graymon caxis hsv2rgb rgb2hsv rgbplot spinmap colordef whitebg hidden
        pan reset rotate rotate3d selectmoveresize zoom datacursormode figurepalette plotbrowser plotedit
        plottools propertyeditor showplottool brush datacursormode linkdata refreshdata view makehgtform viewmtx
        cameratoolbar campan camzoom camdolly camlookat camorbit campos camproj camroll camtarget
        camup camva camlight light lightangle lighting diffuse material specular alim
        alpha alphamap image imagesc imread imwrite imfinfo imformats frame2im im2frame
        im2java ind2rgb rgb2ind imapprox dither cmpermute cmunique print printopt printdlg
        printpreview orient savefig openfig hgexport hgsave hgload saveas gca gcf
        gcbf gcbo gco ancestor allchild findall findfigs findobj gobjects ishghandle
        copyobj delete get set propedit figure axes image light line
        patch rectangle surface text annotation set get hggroup hgtransform makehgtform
        figure gcf close clf refresh newplot shg closereq dragrect drawnow
        rbbox opengl axes hold ishold newplot linkaxes linkprop refreshdata waitfor
        get set if/elseif/else for parfor switch/case/otherwise try/catch while break continue
        end pause return edit input publish notebook grabcode snapnow function
        nargin nargout varargin varargout narginchk nargoutchk validateattributes validatestring inputParser inputname
        persistent genvarname isvarname namelengthmax assignin global isglobal try/catch error warning
        lastwarn assert onCleanup dbclear dbcont dbdown dbquit dbstack dbstatus dbstep
        dbstop dbtype dbup checkcode keyboard mlintrpt edit echo eval evalc
        evalin feval run builtin depdir depfun mfilename pcode timer clear
        clearvars disp openvar who whos load save matfile workspace importdata
        uiimport csvread csvwrite dlmread dlmwrite fileread textread textscan readtable writetable
        type xlsfinfo xlsread xlswrite readtable writetable fclose feof ferror fgetl
        fgets fopen fprintf fread frewind fscanf fseek ftell fwrite exifread
        im2java imfinfo imread imwrite nccreate ncdisp ncinfo ncread ncreadatt ncwrite
        ncwriteatt ncwriteschema netcdf h5create h5disp h5info h5read h5readatt h5write h5writeatt
        hdfinfo hdfread hdf fitsdisp fitsinfo fitsread fitswrite createFile openFile closeFile
        deleteFile fileName fileMode createImg getImgSize getImgType insertImg readImg setBscale writeImg
        readCard readKey readKeyCmplx readKeyDbl readKeyLongLong readKeyLongStr readKeyUnit readRecord writeComment writeDate
        writeKey writeKeyUnit writeHistory deleteKey deleteRecord getHdrSpace copyHDU getHDUnum getHDUtype getNumHDUs
        movAbsHDU movNamHDU movRelHDU writeChecksum deleteHDU imgCompress isCompressedImg setCompressionType setHCompScale setHCompSmooth
        setTileDim createTbl insertCol insertRows insertATbl insertBTbl deleteCol deleteRows getAColParms getBColParms
        getColName getColType getEqColType getNumCols getNumRows readATblHdr readBTblHdr readCol setTscale writeCol
        getConstantValue getVersion getOpenFiles multibandread multibandwrite cdfepoch cdfinfo cdfread cdfwrite todatenum
        cdflib audioinfo audioread audiowrite mmfileinfo movie2avi audiodevinfo audioplayer audiorecorder sound
        soundsc beep lin2mu mu2lin xmlread xmlwrite xslt memmapfile dir ls
        pwd fileattrib exist isdir type visdiff what which cd copyfile
        delete recycle mkdir movefile rmdir open winopen filebrowser fileparts fullfile
        filemarker filesep tempdir tempname matlabroot toolboxdir gunzip gzip tar untar
        unzip zip addpath rmpath path savepath userpath genpath pathsep pathtool
        restoredefaultpath clipboard computer dos getenv perl setenv system unix winqueryreg
        ftp sendmail urlread urlwrite web instrcallback instrfind instrfindall readasync record
        serial serialbreak stopasync guide figure axes uicontrol uitable uipanel uibuttongroup
        actxcontrol uimenu uicontextmenu uitoolbar uipushtool uitoggletool dialog errordlg helpdlg msgbox
        questdlg uigetpref uisetpref waitbar warndlg export2wsdlg inputdlg listdlg uisetcolor uisetfont
        printdlg printpreview uigetdir uigetfile uiopen uiputfile uisave align movegui getpixelposition
        setpixelposition listfonts textwrap uistack guidata guihandles openfig getappdata isappdata rmappdata
        setappdata uiresume uiwait waitfor waitforbuttonpress addpref getpref ispref rmpref setpref
        classdef class isa isequal isobject enumeration events methods properties classdef
        import properties isprop dynamicprops methods ismethod handle hgsetget dynamicprops delete
        findobj isa isvalid findprop relationaloperators events notify addlistener empty superclasses
        enumeration save load saveobj loadobj cat horzcat vertcat empty disp
        display numel size end subsref subsasgn subsindex substruct metaclass try/catch
        bench cputime memory profile profsave tic timeit toc clear inmem
        memory pack whos functiontests runtests builddocsearchdb javaArray javaclasspath javaaddpath javarmpath
        javachk isjava usejava javaMethod javaMethodEDT javaObject javaObjectEDT cell class clear
        depfun exist fieldnames im2java import inmem inspect isa methods methodsview
        which enableNETfromNetworkDrive cell bitand bitor bitxor bitnot mexext inmem actxserver
        actxcontrol actxcontrollist actxcontrolselect iscom isprop get set addproperty deleteproperty inspect
        propedit fieldnames ismethod methods methodsview invoke isevent events eventlisteners registerevent
        unregisterallevents unregisterevent isinterface interfaces release delete move load save actxGetRunningServer
        enableservice callSoapService createClassFromWsdl createSoapMessage parseSoapResponse loadlibrary unloadlibrary libisloaded calllib libfunctions
        libfunctionsview libstruct libpointer mexext inmem mex dbmex mex dbmex ver
        computer mexext dbmex inmem mex mexext checkin checkout cmopts customverctrl
        undocheckout verctrl exit quit matlabrc startup finish prefdir preferences ismac
        ispc isstudent isunix javachk license usejava ver verLessThan version doc
        help docsearch lookfor demo echodemo
      )

      state :root do
        rule /\s+/m, Text # Whitespace
        rule /(?:#{keywords.join('|')})\b/, Keyword
        rule /(?:#{builtins.join('|')})\b/, Name::Builtin
        rule /[a-zA-Z][_a-zA-Z0-9]*/m, Name
        rule %r{[(){};:,\/\\\]\[]}, Punctuation

        rule %r(%\{.*?%\})m, Comment::Multiline
        rule /%.*$/, Comment::Single

        rule /~=|==|<<|>>|[-~+\/*%=<>&^|.]/, Operator


        rule /(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /\d+L/, Num::Integer::Long
        rule /\d+/, Num::Integer

        mixin :strings
      end

      state :strings do
        rule /'.*?'/, Str::Single
      end
    end
  end
end
