# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# automatically generated by `rake builtins:matlab`
Set.new %w(ans clc diary format home iskeyword more zeros ones rand true false eye diag blkdiag cat horzcat vertcat repelem repmat linspace logspace freqspace meshgrid ndgrid length size ndims numel isscalar isvector ismatrix isrow iscolumn isempty sort sortrows issorted issortedrows flip fliplr flipud rot90 transpose ctranspose permute ipermute circshift shiftdim reshape squeeze colon end ind2sub sub2ind plus uplus minus uminus times rdivide ldivide power mtimes mrdivide mldivide mpower cumprod cumsum diff movsum prod sum ceil fix floor idivide mod rem round bsxfun eq ge gt le lt ne isequal isequaln logicaloperatorsshortcircuit and not or xor all any false find islogical logical true intersect ismember ismembertol issorted setdiff setxor union unique uniquetol join innerjoin outerjoin bitand bitcmp bitget bitor bitset bitshift bitxor swapbytes double single int8 int16 int32 int64 uint8 uint16 uint32 uint64 cast typecast isinteger isfloat isnumeric isreal isfinite isinf isnan eps flintmax inf intmax intmin nan realmax realmin string strings join char cellstr blanks newline compose sprintf strcat ischar iscellstr isstring strlength isstrprop isletter isspace contains count endswith startswith strfind sscanf replace replacebetween strrep join split splitlines strjoin strsplit strtok erase erasebetween extractafter extractbefore extractbetween insertafter insertbefore pad strip lower upper reverse deblank strtrim strjust strcmp strcmpi strncmp strncmpi regexp regexpi regexprep regexptranslate datetime timezones years days hours minutes seconds milliseconds duration calyears calquarters calmonths calweeks caldays calendarduration exceltime juliandate posixtime yyyymmdd year quarter month week day hour minute second ymd hms split time timeofday isdst isweekend tzoffset between caldiff dateshift isbetween isdatetime isduration iscalendarduration isnat nat datenum datevec datestr char cellstr string now clock date calendar eomday weekday addtodate etime categorical iscategorical discretize categories iscategory isordinal isprotected addcats mergecats removecats renamecats reordercats setcats summary countcats isundefined table array2table cell2table struct2table table2array table2cell table2struct readtable writetable detectimportoptions istable head tail height width summary intersect ismember setdiff setxor unique union join innerjoin outerjoin sortrows stack unstack vartype ismissing standardizemissing rmmissing fillmissing varfun rowfun findgroups splitapply timetable retime synchronize lag table2timetable array2timetable timetable2table istimetable isregular timerange withtol vartype rmmissing issorted sortrows unique struct fieldnames getfield isfield isstruct orderfields rmfield setfield arrayfun structfun table2struct struct2table cell2struct struct2cell cell cell2mat cell2struct cell2table celldisp cellfun cellplot cellstr iscell iscellstr mat2cell num2cell strjoin strsplit struct2cell table2cell feval func2str str2func localfunctions functions addevent delevent gettsafteratevent gettsafterevent gettsatevent gettsbeforeatevent gettsbeforeevent gettsbetweenevents gettscollection isemptytscollection lengthtscollection settscollection sizetscollection tscollection addsampletocollection addts delsamplefromcollection getabstimetscollection getsampleusingtimetscollection gettimeseriesnames horzcattscollection removets resampletscollection setabstimetscollection settimeseriesnames vertcattscollection isa iscalendarduration iscategorical iscell iscellstr ischar isdatetime isduration isfield isfloat isgraphics isinteger isjava islogical isnumeric isobject isreal isenum isstruct istable is class validateattributes whos char cellstr int2str mat2str num2str str2double str2num native2unicode unicode2native base2dec bin2dec dec2base dec2bin dec2hex hex2dec hex2num num2hex table2array table2cell table2struct array2table cell2table struct2table cell2mat cell2struct mat2cell num2cell struct2cell plus uplus minus uminus times rdivide ldivide power mtimes mrdivide mldivide mpower cumprod cumsum diff movsum prod sum ceil fix floor idivide mod rem round bsxfun sin sind asin asind sinh asinh cos cosd acos acosd cosh acosh tan tand atan atand atan2 atan2d tanh atanh csc cscd acsc acscd csch acsch sec secd asec asecd sech asech cot cotd acot acotd coth acoth hypot deg2rad rad2deg exp expm1 log log10 log1p log2 nextpow2 nthroot pow2 reallog realpow realsqrt sqrt abs angle complex conj cplxpair i imag isreal j real sign unwrap factor factorial gcd isprime lcm nchoosek perms primes rat rats poly polyeig polyfit residue roots polyval polyvalm conv deconv polyint polyder airy besselh besseli besselj besselk bessely beta betainc betaincinv betaln ellipj ellipke erf erfc erfcinv erfcx erfinv expint gamma gammainc gammaincinv gammaln legendre psi cart2pol cart2sph pol2cart sph2cart eps flintmax i j inf pi nan isfinite isinf isnan compan gallery hadamard hankel hilb invhilb magic pascal rosser toeplitz vander wilkinson mldivide mrdivide linsolve inv pinv lscov lsqnonneg sylvester eig eigs balance svd svds gsvd ordeig ordqz ordschur polyeig qz hess schur rsf2csf cdf2rdf lu ldl chol cholupdate qr qrdelete qrinsert qrupdate planerot transpose ctranspose mtimes mpower sqrtm expm logm funm kron cross dot bandwidth tril triu isbanded isdiag ishermitian issymmetric istril istriu norm normest cond condest rcond condeig det null orth rank rref trace subspace rand randn randi randperm rng interp1 interp2 interp3 interpn pchip spline ppval mkpp unmkpp padecoef interpft ndgrid meshgrid griddata griddatan fminbnd fminsearch lsqnonneg fzero optimget optimset ode45 ode23 ode113 ode15s ode23s ode23t ode23tb ode15i decic odeget odeset deval odextend bvp4c bvp5c bvpinit bvpxtend bvpget bvpset deval dde23 ddesd ddensd ddeget ddeset deval pdepe pdeval integral integral2 integral3 quadgk quad2d cumtrapz trapz polyint del2 diff gradient polyder fft fft2 fftn fftshift fftw ifft ifft2 ifftn ifftshift nextpow2 interpft conv conv2 convn deconv filter filter2 ss2tf padecoef spalloc spdiags speye sprand sprandn sprandsym sparse spconvert issparse nnz nonzeros nzmax spfun spones spparms spy find full amd colamd colperm dmperm randperm symamd symrcm pcg minres symmlq gmres bicg bicgstab bicgstabl cgs qmr tfqmr lsqr ichol ilu eigs svds normest condest sprank etree symbfact spaugment dmperm etreeplot treelayout treeplot gplot unmesh graph digraph tetramesh trimesh triplot trisurf delaunay delaunayn tetramesh trimesh triplot trisurf dsearchn tsearchn delaunay delaunayn boundary alphashape convhull convhulln patch voronoi voronoin polyarea inpolygon rectint plot plot3 loglog semilogx semilogy errorbar fplot fplot3 fimplicit linespec colorspec bar bar3 barh bar3h histogram histcounts histogram2 histcounts2 rose pareto area pie pie3 stem stairs stem3 scatter scatter3 spy plotmatrix heatmap polarplot polarscatter polarhistogram compass ezpolar rlim thetalim rticks thetaticks rticklabels thetaticklabels rtickformat thetatickformat rtickangle polaraxes contour contourf contourc contour3 contourslice clabel fcontour feather quiver compass quiver3 streamslice streamline surf surfc surface surfl surfnorm mesh meshc meshz hidden fsurf fmesh fimplicit3 waterfall ribbon contour3 peaks cylinder ellipsoid sphere pcolor surf2patch contourslice flow isocaps isocolors isonormals isosurface reducepatch reducevolume shrinkfaces slice smooth3 subvolume volumebounds coneplot curl divergence interpstreamspeed stream2 stream3 streamline streamparticles streamribbon streamslice streamtube fill fill3 patch surf2patch movie getframe frame2im im2frame animatedline comet comet3 drawnow refreshdata title xlabel ylabel zlabel clabel legend colorbar text texlabel gtext line rectangle annotation xlim ylim zlim axis box daspect pbaspect grid xticks yticks zticks xticklabels yticklabels zticklabels xtickformat ytickformat ztickformat xtickangle ytickangle ztickangle datetick ruler2num num2ruler hold subplot yyaxis cla axes figure colormap colorbar rgbplot colormapeditor brighten contrast caxis spinmap hsv2rgb rgb2hsv parula jet hsv hot cool spring summer autumn winter gray bone copper pink lines colorcube prism flag view makehgtform viewmtx cameratoolbar campan camzoom camdolly camlookat camorbit campos camproj camroll camtarget camup camva camlight light lightangle lighting shading diffuse material specular alim alpha alphamap imshow image imagesc imread imwrite imfinfo imformats frame2im im2frame im2java im2double ind2rgb rgb2gray rgb2ind imapprox dither cmpermute cmunique print saveas getframe savefig openfig orient hgexport printopt get set reset inspect gca gcf gcbf gcbo gco groot ancestor allchild findall findobj findfigs gobjects isgraphics ishandle copyobj delete gobjects isgraphics isempty isequal isa clf cla close uicontextmenu uimenu dragrect rbbox refresh shg hggroup hgtransform makehgtform eye hold ishold newplot clf cla drawnow opengl readtable detectimportoptions writetable textscan dlmread dlmwrite csvread csvwrite type readtable detectimportoptions writetable xlsfinfo xlsread xlswrite importdata im2java imfinfo imread imwrite nccreate ncdisp ncinfo ncread ncreadatt ncwrite ncwriteatt ncwriteschema h5create h5disp h5info h5read h5readatt h5write h5writeatt hdfinfo hdfread hdftool imread imwrite hdfan hdfhx hdfh hdfhd hdfhe hdfml hdfpt hdfv hdfvf hdfvh hdfvs hdfdf24 hdfdfr8 fitsdisp fitsinfo fitsread fitswrite multibandread multibandwrite cdfinfo cdfread cdfepoch todatenum audioinfo audioread audiowrite videoreader videowriter mmfileinfo lin2mu mu2lin audiodevinfo audioplayer audiorecorder sound soundsc beep xmlread xmlwrite xslt load save matfile disp who whos clear clearvars openvar fclose feof ferror fgetl fgets fileread fopen fprintf fread frewind fscanf fseek ftell fwrite tcpclient web webread webwrite websave weboptions sendmail jsondecode jsonencode readasync serial serialbreak seriallist stopasync instrcallback instrfind instrfindall record tabulartextdatastore imagedatastore spreadsheetdatastore filedatastore datastore tall datastore mapreducer gather head tail topkrows istall classunderlying isaunderlying write mapreduce datastore add addmulti hasnext getnext mapreducer gcmr matfile memmapfile ismissing rmmissing fillmissing missing standardizemissing isoutlier filloutliers smoothdata movmean movmedian detrend filter filter2 discretize histcounts histcounts2 findgroups splitapply rowfun varfun accumarray min max bounds mean median mode std var corrcoef cov cummax cummin movmad movmax movmean movmedian movmin movprod movstd movsum movvar pan zoom rotate rotate3d brush datacursormode ginput linkdata linkaxes linkprop refreshdata figurepalette plotbrowser plotedit plottools propertyeditor propedit showplottool if for parfor switch try while break continue end pause return edit input publish grabcode snapnow function nargin nargout varargin varargout narginchk nargoutchk validateattributes validatestring inputname isvarname namelengthmax persistent assignin global mlock munlock mislocked try error warning lastwarn assert oncleanup addpath rmpath path savepath userpath genpath pathsep pathtool restoredefaultpath rehash dir ls pwd fileattrib exist isdir type visdiff what which cd copyfile delete recycle mkdir movefile rmdir open winopen zip unzip gzip gunzip tar untar fileparts fullfile filemarker filesep tempdir tempname matlabroot toolboxdir dbclear dbcont dbdown dbquit dbstack dbstatus dbstep dbstop dbtype dbup checkcode keyboard mlintrpt edit echo eval evalc evalin feval run builtin mfilename pcode uiaxes uibutton uibuttongroup uicheckbox uidropdown uieditfield uilabel uilistbox uiradiobutton uislider uispinner uitable uitextarea uitogglebutton scroll uifigure uipanel uitabgroup uitab uigauge uiknob uilamp uiswitch uialert questdlg inputdlg listdlg uisetcolor uigetfile uiputfile uigetdir uiopen uisave appdesigner figure axes uicontrol uitable uipanel uibuttongroup uitab uitabgroup uimenu uicontextmenu uitoolbar uipushtool uitoggletool actxcontrol align movegui getpixelposition setpixelposition listfonts textwrap uistack inspect errordlg warndlg msgbox helpdlg waitbar questdlg inputdlg listdlg uisetcolor uisetfont export2wsdlg uigetfile uiputfile uigetdir uiopen uisave printdlg printpreview exportsetupdlg dialog uigetpref guide uiwait uiresume waitfor waitforbuttonpress closereq getappdata setappdata isappdata rmappdata guidata guihandles uisetpref class isobject enumeration events methods properties classdef classdef import properties isprop mustbefinite mustbegreaterthan mustbegreaterthanorequal mustbeinteger mustbelessthan mustbelessthanorequal mustbemember mustbenegative mustbenonempty mustbenonnan mustbenonnegative mustbenonpositive mustbenonsparse mustbenonzero mustbenumeric mustbenumericorlogical mustbepositive mustbereal methods ismethod isequal eq events superclasses enumeration isenum numargumentsfromsubscript subsref subsasgn subsindex substruct builtin empty disp display details saveobj loadobj edit metaclass properties methods events superclasses step clone getnuminputs getnumoutputs islocked resetsystemobject releasesystemobject mexext inmem loadlibrary unloadlibrary libisloaded calllib libfunctions libfunctionsview libstruct libpointer import isjava javaaddpath javaarray javachk javaclasspath javamethod javamethodedt javaobject javaobjectedt javarmpath usejava net enablenetfromnetworkdrive cell begininvoke endinvoke combine remove removeall bitand bitor bitxor bitnot actxserver actxcontrol actxcontrollist actxcontrolselect actxgetrunningserver iscom addproperty deleteproperty inspect fieldnames methods methodsview invoke isevent eventlisteners registerevent unregisterallevents unregisterevent isinterface interfaces release move pyversion pyargs pyargs pyargs builddocsearchdb try assert runtests testsuite functiontests runtests testsuite runtests testsuite runperf testsuite timeit tic toc cputime profile bench memory inmem pack memoize clearallmemoizedcaches clipboard computer system dos unix getenv setenv perl winqueryreg commandhistory commandwindow filebrowser workspace getpref setpref addpref rmpref ispref mex execute getchararray putchararray getfullmatrix putfullmatrix getvariable getworkspacedata putworkspacedata maximizecommandwindow minimizecommandwindow regmatlabserver enableservice mex dbmex mexext inmem ver computer mexext dbmex inmem mex mexext matlabwindows matlabmac matlablinux exit quit matlabrc startup finish prefdir preferences version ver verlessthan license ispc ismac isunix isstudent javachk usejava doc help docsearch lookfor demo echodemo)
