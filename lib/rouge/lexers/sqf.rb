# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class SQF < RegexLexer
      tag "sqf"
      filenames "*.sqf"

      title "SQF"
      desc "Status Quo Function, a Real Virtuality engine scripting language"

      def self.wordoperators
        @wordoperators = Set.new %w(
          and or not
        )
      end

      def self.initializers
        @initializers = Set.new %w(
          private param params
        )
      end

      def self.controlflow
        @controlflow = Set.new %w(
          if then else exitwith switch do case default while for from to step
          foreach
        )
      end

      def self.constants
        @constants = Set.new %w(
          true false player confignull controlnull displaynull grpnull
          locationnull netobjnull objnull scriptnull tasknull teammembernull
        )
      end

      def self.namespaces
        @namespaces = Set.new %w(
          currentnamespace missionnamespace parsingnamespace profilenamespace
          uinamespace
        )
      end

      def self.commands
        @commands = Set.new %w(
          abs acctime acos action actionids actionkeys actionkeysimages
          actionkeysnames actionkeysnamesarray actionname actionparams
          activateaddons activatedaddons activatekey add3denconnection
          add3deneventhandler add3denlayer addaction addbackpack
          addbackpackcargo addbackpackcargoglobal addbackpackglobal addcamshake
          addcuratoraddons addcuratorcameraarea addcuratoreditableobjects
          addcuratoreditingarea addcuratorpoints addeditorobject addeventhandler
          addforce addforcegeneratorrtd addgoggles addgroupicon addhandgunitem
          addheadgear additem additemcargo additemcargoglobal additempool
          additemtobackpack additemtouniform additemtovest addlivestats
          addmagazine addmagazineammocargo addmagazinecargo
          addmagazinecargoglobal addmagazineglobal addmagazinepool addmagazines
          addmagazineturret addmenu addmenuitem addmissioneventhandler
          addmpeventhandler addmusiceventhandler addownedmine addplayerscores
          addprimaryweaponitem addpublicvariableeventhandler addrating
          addresources addscore addscoreside addsecondaryweaponitem
          addswitchableunit addteammember addtoremainscollector addtorque
          adduniform addvehicle addvest addwaypoint addweapon addweaponcargo
          addweaponcargoglobal addweaponglobal addweaponitem addweaponpool
          addweaponturret admin agent agents agltoasl aimedattarget aimpos
          airdensitycurvertd airdensityrtd airplanethrottle airportside
          aisfinishheal alive all3denentities allcontrols allcurators
          allcutlayers alldead alldeadmen alldisplays allgroups allmapmarkers
          allmines allmissionobjects allow3dmode allowcrewinimmobile
          allowcuratorlogicignoreareas allowdamage allowdammage
          allowfileoperations allowfleeing allowgetin allowsprint allplayers
          allsimpleobjects allsites allturrets allunits allunitsuav allvariables
          ammo ammoonpylon and animate animatebay animatedoor animatepylon
          animatesource animationnames animationphase animationsourcephase
          animationstate append apply armorypoints arrayintersect asin asltoagl
          asltoatl assert assignascargo assignascargoindex assignascommander
          assignasdriver assignasgunner assignasturret assigncurator
          assignedcargo assignedcommander assigneddriver assignedgunner
          assigneditems assignedtarget assignedteam assignedvehicle
          assignedvehiclerole assignitem assignteam assigntoairport atan atan2
          atg atltoasl attachedobject attachedobjects attachedto attachobject
          attachto attackenabled backpack backpackcargo backpackcontainer
          backpackitems backpackmagazines backpackspacefor behaviour benchmark
          binocular blufor boundingbox boundingboxreal boundingcenter breakout
          breakto briefingname buildingexit buildingpos buldozer_enableroaddiag
          buldozer_isenabledroaddiag buldozer_loadnewroads
          buldozer_reloadopermap buttonaction buttonsetaction cadetmode call
          callextension camcommand camcommit camcommitprepared camcommitted
          camconstuctionsetparams camcreate camdestroy cameraeffect
          cameraeffectenablehud camerainterest cameraon cameraview
          campaignconfigfile campreload campreloaded campreparebank
          campreparedir campreparedive campreparefocus campreparefov
          campreparefovrange campreparepos campreparerelpos campreparetarget
          camsetbank camsetdir camsetdive camsetfocus camsetfov camsetfovrange
          camsetpos camsetrelpos camsettarget camtarget camusenvg canadd
          canadditemtobackpack canadditemtouniform canadditemtovest
          cancelsimpletaskdestination canfire canmove canslingload canstand
          cansuspend cantriggerdynamicsimulation canunloadincombat
          canvehiclecargo captive captivenum case catch cbchecked cbsetchecked
          ceil channelenabled cheatsenabled checkaifeature checkvisibility
          civilian classname clear3denattribute clear3deninventory
          clearallitemsfrombackpack clearbackpackcargo clearbackpackcargoglobal
          clearforcesrtd cleargroupicons clearitemcargo clearitemcargoglobal
          clearitempool clearmagazinecargo clearmagazinecargoglobal
          clearmagazinepool clearoverlay clearradio clearweaponcargo
          clearweaponcargoglobal clearweaponpool clientowner closedialog
          closedisplay closeoverlay collapseobjecttree collect3denhistory
          collectivertd combatmode commandartilleryfire commandchat commander
          commandfire commandfollow commandfsm commandgetout commandingmenu
          commandmove commandradio commandstop commandsuppressivefire
          commandtarget commandwatch comment commitoverlay compile compilefinal
          completedfsm composetext configclasses configfile confighierarchy
          configname confignull configproperties configsourceaddonlist
          configsourcemod configsourcemodlist confirmsensortarget
          connectterminaltouav controlnull controlsgroupctrl copyfromclipboard
          copytoclipboard copywaypoints cos count countenemy countfriendly
          countside counttype countunknown create3dencomposition
          create3denentity createagent createcenter createdialog creatediarylink
          creatediaryrecord creatediarysubject createdisplay creategeardialog
          creategroup createguardedpoint createlocation createmarker
          createmarkerlocal createmenu createmine createmissiondisplay
          creatempcampaigndisplay createsimpleobject createsimpletask createsite
          createsoundsource createtask createteam createtrigger createunit
          createvehicle createvehiclecrew createvehiclelocal crew ctaddheader
          ctaddrow ctclear ctcursel ctdata ctfindheaderrows ctfindrowheader
          ctheadercontrols ctheadercount ctremoveheaders ctremoverows
          ctrlactivate ctrladdeventhandler ctrlangle ctrlautoscrolldelay
          ctrlautoscrollrewind ctrlautoscrollspeed ctrlchecked ctrlclassname
          ctrlcommit ctrlcommitted ctrlcreate ctrldelete ctrlenable ctrlenabled
          ctrlfade ctrlhtmlloaded ctrlidc ctrlidd ctrlmapanimadd
          ctrlmapanimclear ctrlmapanimcommit ctrlmapanimdone ctrlmapcursor
          ctrlmapmouseover ctrlmapscale ctrlmapscreentoworld
          ctrlmapworldtoscreen ctrlmodel ctrlmodeldirandup ctrlmodelscale
          ctrlparent ctrlparentcontrolsgroup ctrlposition
          ctrlremovealleventhandlers ctrlremoveeventhandler ctrlscale
          ctrlsetactivecolor ctrlsetangle ctrlsetautoscrolldelay
          ctrlsetautoscrollrewind ctrlsetautoscrollspeed ctrlsetbackgroundcolor
          ctrlsetchecked ctrlsetdisabledcolor ctrlseteventhandler ctrlsetfade
          ctrlsetfocus ctrlsetfont ctrlsetfonth1 ctrlsetfonth1b ctrlsetfonth2
          ctrlsetfonth2b ctrlsetfonth3 ctrlsetfonth3b ctrlsetfonth4
          ctrlsetfonth4b ctrlsetfonth5 ctrlsetfonth5b ctrlsetfonth6
          ctrlsetfonth6b ctrlsetfontheight ctrlsetfontheighth1
          ctrlsetfontheighth2 ctrlsetfontheighth3 ctrlsetfontheighth4
          ctrlsetfontheighth5 ctrlsetfontheighth6 ctrlsetfontheightsecondary
          ctrlsetfontp ctrlsetfontpb ctrlsetfontsecondary ctrlsetforegroundcolor
          ctrlsetmodel ctrlsetmodeldirandup ctrlsetmodelscale ctrlsetposition
          ctrlsetscale ctrlsetstructuredtext ctrlsettext ctrlsettextcolor
          ctrlsettextcolorsecondary ctrlsettextsecondary ctrlsettooltip
          ctrlsettooltipcolorbox ctrlsettooltipcolorshade
          ctrlsettooltipcolortext ctrlshow ctrlshown ctrltext ctrltextheight
          ctrltextsecondary ctrltype ctrlvisible ctrowcontrols ctrowcount
          ctsetcursel ctsetdata ctsetheadertemplate ctsetrowtemplate ctsetvalue
          ctvalue curatoraddons curatorcamera curatorcameraarea
          curatorcameraareaceiling curatorcoef curatoreditableobjects
          curatoreditingarea curatoreditingareatype curatormouseover
          curatorpoints curatorregisteredobjects curatorselected
          curatorwaypointcost current3denoperation currentchannel currentcommand
          currentmagazine currentmagazinedetail currentmagazinedetailturret
          currentmagazineturret currentmuzzle currentnamespace currenttask
          currenttasks currentthrowable currentvisionmode currentwaypoint
          currentweapon currentweaponmode currentweaponturret currentzeroing
          cursorobject cursortarget customchat customradio cutfadeout cutobj
          cutrsc cuttext damage date datetonumber daytime deactivatekey
          debriefingtext debugfsm debuglog default deg delete3denentities
          deleteat deletecenter deletecollection deleteeditorobject deletegroup
          deletegroupwhenempty deleteidentity deletelocation deletemarker
          deletemarkerlocal deleterange deleteresources deletesite deletestatus
          deleteteam deletevehicle deletevehiclecrew deletewaypoint detach
          detectedmines diag_activemissionfsms diag_activescripts
          diag_activesqfscripts diag_activesqsscripts diag_codeperformance
          diag_dynamicsimulationend diag_fps diag_fpsmin diag_frameno diag_log
          diag_ticktime dialog diarysubjectexists didjip didjipowner difficulty
          difficultyenabled difficultyenabledrtd difficultyoption direction
          directsay disableai disablecollisionwith disableconversation
          disabledebriefingstats disablenvgequipment disableremotesensors
          disableserialization disabletiequipment disableuavconnectability
          disableuserinput displayaddeventhandler displayctrl displaynull
          displayparent displayremovealleventhandlers displayremoveeventhandler
          displayseteventhandler dissolveteam distance distance2d distancesqr
          distributionregion do do3denaction doartilleryfire dofire dofollow
          dofsm dogetout domove doorphase dostop dosuppressivefire dotarget
          dowatch drawarrow drawellipse drawicon drawicon3d drawline drawline3d
          drawlink drawlocation drawpolygon drawrectangle driver drop
          dynamicsimulationdistance dynamicsimulationdistancecoef
          dynamicsimulationenabled dynamicsimulationsystemenabled east echo
          edit3denmissionattributes editobject editorseteventhandler
          effectivecommander else emptypositions enableai enableaifeature
          enableaimprecision enableattack enableaudiofeature
          enableautostartuprtd enableautotrimrtd enablecamshake enablecaustics
          enablechannel enablecollisionwith enablecopilot enabledebriefingstats
          enablediaglegend enabledynamicsimulation enabledynamicsimulationsystem
          enableenddialog enableengineartillery enableenvironment enablefatigue
          enablegunlights enableirlasers enablemimics enablepersonturret
          enableradio enablereload enableropeattach enablesatnormalondetail
          enablesaving enablesentences enablesimulation enablesimulationglobal
          enablestamina enablestressdamage enableteamswitch enabletraffic
          enableuavconnectability enableuavwaypoints enablevehiclecargo
          enablevehiclesensor enableweapondisassembly endl endloadingscreen
          endmission engineon enginesisonrtd enginespowerrtd enginesrpmrtd
          enginestorquertd entities environmentenabled estimatedendservertime
          estimatedtimeleft evalobjectargument everybackpack everycontainer exec
          execeditorscript execfsm execvm exit exitwith exp expecteddestination
          exportjipmessages eyedirection eyepos face faction fademusic faderadio
          fadesound fadespeech failmission false fillweaponsfrompool find
          findcover finddisplay findeditorobject findemptyposition
          findemptypositionready findnearestenemy finishmissioninit finite fire
          fireattarget firstbackpack flag flaganimationphase flagowner flagside
          flagtexture fleeing floor flyinheight flyinheightasl fog fogforecast
          fogparams for forceadduniform forceatpositionrtd forcedmap forceend
          forceflagtexture forcefollowroad forcegeneratorrtd forcemap
          forcerespawn forcespeed forcewalk forceweaponfire forceweatherchange
          foreach foreachmember foreachmemberagent foreachmemberteam
          forgettarget format formation formationdirection formationleader
          formationmembers formationposition formationtask formattext formleader
          freelook from fromeditor fuel fullcrew gearidcammocount
          gearslotammocount gearslotdata get3denactionstate get3denattribute
          get3dencamera get3denconnections get3denentity get3denentityid
          get3dengrid get3deniconsvisible get3denlayerentities
          get3denlinesvisible get3denmissionattribute get3denmouseover
          get3denselected getaimingcoef getallenvsoundcontrollers
          getallhitpointsdamage getallownedmines getallsoundcontrollers
          getammocargo getanimaimprecision getanimspeedcoef getarray
          getartilleryammo getartillerycomputersettings getartilleryeta
          getassignedcuratorlogic getassignedcuratorunit getbackpackcargo
          getbleedingremaining getburningvalue getcameraviewdirection
          getcargoindex getcenterofmass getclientstate getclientstatenumber
          getcompatiblepylonmagazines getconnecteduav getcontainermaxload
          getcursorobjectparams getcustomaimcoef getdammage getdescription
          getdir getdirvisual getdlcassetsusage getdlcassetsusagebyname getdlcs
          getdlcusagetime geteditorcamera geteditormode geteditorobjectscope
          getelevationoffset getenginetargetrpmrtd getenvsoundcontroller
          getfatigue getfieldmanualstartpage getforcedflagtexture getfriend
          getfsmvariable getfuelcargo getgroupicon getgroupiconparams
          getgroupicons gethidefrom gethit gethitindex gethitpointdamage
          getitemcargo getmagazinecargo getmarkercolor getmarkerpos
          getmarkersize getmarkertype getmass getmissionconfig
          getmissionconfigvalue getmissiondlcs getmissionlayerentities
          getmissionlayers getmodelinfo getmouseposition getnumber
          getobjectargument getobjectchildren getobjectdlc getobjectmaterials
          getobjectproxy getobjecttextures getobjecttype getobjectviewdistance
          getoxygenremaining getpersonuseddlcs getpilotcameradirection
          getpilotcameraposition getpilotcamerarotation getpilotcameratarget
          getplayerchannel getplayerscores getplayeruid getpos getposasl
          getposaslvisual getposaslw getposatl getposatlvisual getposvisual
          getposworld getpylonmagazines getreldir getrelpos
          getremotesensorsdisabled getrepaircargo getresolution getrotorbrakertd
          getshadowdistance getshotparents getslingload getsoundcontroller
          getsoundcontrollerresult getspeed getstamina getstatvalue
          getsuppression getterraingrid getterrainheightasl gettext
          gettotaldlcusagetime gettrimoffsetrtd getunitloadout getunittrait
          getvariable getvehiclecargo getweaponcargo getweaponsway
          getwingsorientationrtd getwingspositionrtd getwppos glanceat
          globalchat globalradio goggles goto group groupchat groupfromnetid
          groupiconselectable groupiconsvisible groupid groupowner groupradio
          groupselectedunits groupselectunit grpnull gunner gusts halt
          handgunitems handgunmagazine handgunweapon handshit hasinterface
          haspilotcamera hasweapon hcallgroups hcgroupparams hcleader
          hcremoveallgroups hcremovegroup hcselected hcselectgroup hcsetgroup
          hcshowbar hcshownbar headgear hidebody hideobject hideobjectglobal
          hideselection hint hintc hintcadet hintsilent hmd hostmission htmlload
          hudmovementlevels humidity if image importallgroups importance in
          inarea inareaarray incapacitatedstate independent inflame inflamed
          ingameuiseteventhandler inheritsfrom initambientlife inpolygon
          inputaction inrangeofartillery inserteditorobject intersect is3den
          is3denmultiplayer isabletobreathe isagent isaimprecisionenabled
          isarray isautohoveron isautonomous isautostartupenabledrtd isautotest
          isautotrimonrtd isbleeding isburning isclass iscollisionlighton
          iscopilotenabled isdamageallowed isdedicated isdlcavailable isengineon
          isequalto isequaltype isequaltypeall isequaltypeany isequaltypearray
          isequaltypeparams isfilepatchingenabled isflashlighton isflatempty
          isforcedwalk isformationleader isgroupdeletedwhenempty ishidden
          isinremainscollector isinstructorfigureenabled isirlaseron iskeyactive
          iskindof islighton islocalized ismanualfire ismarkedforcollection
          ismultiplayer ismultiplayersolo isnil isnull isnumber isobjecthidden
          isobjectrtd isonroad ispipenabled isplayer isrealtime isremoteexecuted
          isremoteexecutedjip issensortargetconfirmed isserver isshowing3dicons
          issimpleobject issprintallowed isstaminaenabled issteammission
          isstreamfriendlyuienabled isstressdamageenabled istext
          istouchingground isturnedout istuthintsenabled isuavconnectable
          isuavconnected isuniformallowed isvehiclecargo isvehicleradaron
          isvehiclesensorenabled iswalking isweapondeployed isweaponrested
          itemcargo items itemswithmagazines join joinas joinassilent joinsilent
          joinstring kbadddatabase kbadddatabasetargets kbaddtopic kbhastopic
          kbreact kbremovetopic kbtell kbwassaid keyimage keyname knowsabout
          land landat landresult language lasertarget lbadd lbclear lbcolor
          lbcolorright lbcursel lbdata lbdelete lbisselected lbpicture
          lbpictureright lbselection lbsetcolor lbsetcolorright lbsetcursel
          lbsetdata lbsetpicture lbsetpicturecolor lbsetpicturecolordisabled
          lbsetpicturecolorselected lbsetpictureright lbsetpicturerightcolor
          lbsetpicturerightcolordisabled lbsetpicturerightcolorselected
          lbsetselectcolor lbsetselectcolorright lbsetselected lbsettext
          lbsettextright lbsettooltip lbsetvalue lbsize lbsort lbsortbyvalue
          lbtext lbtextright lbvalue leader leaderboarddeinit leaderboardgetrows
          leaderboardinit leaderboardrequestrowsfriends
          leaderboardrequestrowsglobal leaderboardrequestrowsglobalarounduser
          leaderboardsrequestuploadscore leaderboardsrequestuploadscorekeepbest
          leaderboardstate leavevehicle librarycredits librarydisclaimers
          lifestate lightattachobject lightdetachobject lightison lightnings
          limitspeed linearconversion linebreak lineintersects
          lineintersectsobjs lineintersectssurfaces lineintersectswith linkitem
          list listobjects listremotetargets listvehiclesensors ln lnbaddarray
          lnbaddcolumn lnbaddrow lnbclear lnbcolor lnbcolorright lnbcurselrow
          lnbdata lnbdeletecolumn lnbdeleterow lnbgetcolumnsposition lnbpicture
          lnbpictureright lnbsetcolor lnbsetcolorright lnbsetcolumnspos
          lnbsetcurselrow lnbsetdata lnbsetpicture lnbsetpicturecolor
          lnbsetpicturecolorright lnbsetpicturecolorselected
          lnbsetpicturecolorselectedright lnbsetpictureright lnbsettext
          lnbsettextright lnbsetvalue lnbsize lnbsort lnbsortbyvalue lnbtext
          lnbtextright lnbvalue load loadabs loadbackpack loadfile loadgame
          loadidentity loadmagazine loadoverlay loadstatus loaduniform loadvest
          local localize locationnull locationposition lock lockcamerato
          lockcargo lockdriver locked lockedcargo lockeddriver lockedturret
          lockidentity lockturret lockwp log logentities lognetwork
          lognetworkterminate lookat lookatpos magazinecargo magazines
          magazinesallturrets magazinesammo magazinesammocargo magazinesammofull
          magazinesdetail magazinesdetailbackpack magazinesdetailuniform
          magazinesdetailvest magazinesturret magazineturretammo mapanimadd
          mapanimclear mapanimcommit mapanimdone mapcenteroncamera
          mapgridposition markasfinishedonsteam markeralpha markerbrush
          markercolor markerdir markerpos markershape markersize markertext
          markertype max members menuaction menuadd menuchecked menuclear
          menucollapse menudata menudelete menuenable menuenabled menuexpand
          menuhover menupicture menusetaction menusetcheck menusetdata
          menusetpicture menusetvalue menushortcut menushortcuttext menusize
          menusort menutext menuurl menuvalue min mineactive minedetectedby
          missionconfigfile missiondifficulty missionname missionnamespace
          missionstart missionversion mod modeltoworld modeltoworldvisual
          modeltoworldvisualworld modeltoworldworld modparams moonintensity
          moonphase morale move move3dencamera moveinany moveincargo
          moveincommander moveindriver moveingunner moveinturret moveobjecttoend
          moveout movetime moveto movetocompleted movetofailed musicvolume name
          namesound nearentities nearestbuilding nearestlocation
          nearestlocations nearestlocationwithdubbing nearestobject
          nearestobjects nearestterrainobjects nearobjects nearobjectsready
          nearroads nearsupplies neartargets needreload netid netobjnull
          newoverlay nextmenuitemindex nextweatherchange nil nmenuitems not
          numberofenginesrtd numbertodate objectcurators objectfromnetid
          objectparent objnull objstatus onbriefinggroup onbriefingnotes
          onbriefingplan onbriefingteamswitch oncommandmodechanged ondoubleclick
          oneachframe ongroupiconclick ongroupiconoverenter ongroupiconoverleave
          onhcgroupselectionchanged onmapsingleclick onplayerconnected
          onplayerdisconnected onpreloadfinished onpreloadstarted
          onshownewobject onteamswitch opencuratorinterface opendlcpage openmap
          openyoutubevideo opfor or ordergetin overcast overcastforecast owner
          param params parsenumber parsesimplearray parsetext parsingnamespace
          particlesquality pi pickweaponpool pitch pixelgrid pixelgridbase
          pixelgridnouiscale pixelh pixelw playableslotsnumber playableunits
          playaction playactionnow player playerrespawntime playerside
          playersnumber playgesture playmission playmove playmovenow playmusic
          playscriptedmission playsound playsound3d position
          positioncameratoworld posscreentoworld posworldtoscreen ppeffectadjust
          ppeffectcommit ppeffectcommitted ppeffectcreate ppeffectdestroy
          ppeffectenable ppeffectenabled ppeffectforceinnvg precision
          preloadcamera preloadobject preloadsound preloadtitleobj
          preloadtitlersc preprocessfile preprocessfilelinenumbers primaryweapon
          primaryweaponitems primaryweaponmagazine priority private
          processdiarylink productversion profilename profilenamespace
          profilenamesteam progressloadingscreen progressposition
          progresssetposition publicvariable publicvariableclient
          publicvariableserver pushback pushbackunique putweaponpool
          queryitemspool querymagazinepool queryweaponpool rad radiochanneladd
          radiochannelcreate radiochannelremove radiochannelsetcallsign
          radiochannelsetlabel radiovolume rain rainbow random rank rankid
          rating rectangular registeredtasks registertask reload reloadenabled
          remotecontrol remoteexec remoteexeccall remoteexecutedowner
          remove3denconnection remove3deneventhandler remove3denlayer
          removeaction removeall3deneventhandlers removeallactions
          removeallassigneditems removeallcontainers removeallcuratoraddons
          removeallcuratorcameraareas removeallcuratoreditingareas
          removealleventhandlers removeallhandgunitems removeallitems
          removeallitemswithmagazines removeallmissioneventhandlers
          removeallmpeventhandlers removeallmusiceventhandlers
          removeallownedmines removeallprimaryweaponitems removeallweapons
          removebackpack removebackpackglobal removecuratoraddons
          removecuratorcameraarea removecuratoreditableobjects
          removecuratoreditingarea removedrawicon removedrawlinks
          removeeventhandler removefromremainscollector removegoggles
          removegroupicon removehandgunitem removeheadgear removeitem
          removeitemfrombackpack removeitemfromuniform removeitemfromvest
          removeitems removemagazine removemagazineglobal removemagazines
          removemagazinesturret removemagazineturret removemenuitem
          removemissioneventhandler removempeventhandler removemusiceventhandler
          removeownedmine removeprimaryweaponitem removesecondaryweaponitem
          removesimpletask removeswitchableunit removeteammember removeuniform
          removevest removeweapon removeweaponattachmentcargo removeweaponcargo
          removeweaponglobal removeweaponturret reportremotetarget
          requiredversion resetcamshake resetsubgroupdirection resistance resize
          resources respawnvehicle restarteditorcamera reveal revealmine reverse
          reversedmousey roadat roadsconnectedto roledescription
          ropeattachedobjects ropeattachedto ropeattachenabled ropeattachto
          ropecreate ropecut ropedestroy ropedetach ropeendposition ropelength
          ropes ropeunwind ropeunwound rotorsforcesrtd rotorsrpmrtd round
          runinitscript safezoneh safezonew safezonewabs safezonex safezonexabs
          safezoney save3deninventory savegame saveidentity savejoysticks
          saveoverlay saveprofilenamespace savestatus savevar savingenabled say
          say2d say3d scopename score scoreside screenshot screentoworld
          scriptdone scriptname scriptnull scudstate secondaryweapon
          secondaryweaponitems secondaryweaponmagazine select selectbestplaces
          selectdiarysubject selectededitorobjects selecteditorobject
          selectionnames selectionposition selectleader selectmax selectmin
          selectnoplayer selectplayer selectrandom selectweapon
          selectweaponturret sendaumessage sendsimplecommand sendtask
          sendtaskresult sendudpmessage servercommand servercommandavailable
          servercommandexecutable servername servertime set set3denattribute
          set3denattributes set3dengrid set3deniconsvisible set3denlayer
          set3denlinesvisible set3denlogictype set3denmissionattribute
          set3denmissionattributes set3denmodelsvisible set3denobjecttype
          set3denselected setacctime setactualcollectivertd setairplanethrottle
          setairportside setammo setammocargo setammoonpylon setanimspeedcoef
          setaperture setaperturenew setarmorypoints setattributes setautonomous
          setbehaviour setbleedingremaining setbrakesrtd setcamerainterest
          setcamshakedefparams setcamshakeparams setcamuseti setcaptive
          setcenterofmass setcollisionlight setcombatmode setcompassoscillation
          setconvoyseparation setcuratorcameraareaceiling setcuratorcoef
          setcuratoreditingareatype setcuratorwaypointcost setcurrentchannel
          setcurrenttask setcurrentwaypoint setcustomaimcoef setcustomweightrtd
          setdamage setdammage setdate setdebriefingtext setdefaultcamera
          setdestination setdetailmapblendpars setdir setdirection setdrawicon
          setdriveonpath setdropinterval setdynamicsimulationdistance
          setdynamicsimulationdistancecoef seteditormode seteditorobjectscope
          seteffectcondition setenginerpmrtd setface setfaceanimation setfatigue
          setfeaturetype setflaganimationphase setflagowner setflagside
          setflagtexture setfog setforcegeneratorrtd setformation
          setformationtask setformdir setfriend setfromeditor setfsmvariable
          setfuel setfuelcargo setgroupicon setgroupiconparams
          setgroupiconsselectable setgroupiconsvisible setgroupid
          setgroupidglobal setgroupowner setgusts sethidebehind sethit
          sethitindex sethitpointdamage sethorizonparallaxcoef
          sethudmovementlevels setidentity setimportance setleader
          setlightambient setlightattenuation setlightbrightness setlightcolor
          setlightdaylight setlightflaremaxdistance setlightflaresize
          setlightintensity setlightnings setlightuseflare setlocalwindparams
          setmagazineturretammo setmarkeralpha setmarkeralphalocal
          setmarkerbrush setmarkerbrushlocal setmarkercolor setmarkercolorlocal
          setmarkerdir setmarkerdirlocal setmarkerpos setmarkerposlocal
          setmarkershape setmarkershapelocal setmarkersize setmarkersizelocal
          setmarkertext setmarkertextlocal setmarkertype setmarkertypelocal
          setmass setmimic setmouseposition setmusiceffect setmusiceventhandler
          setname setnamesound setobjectarguments setobjectmaterial
          setobjectmaterialglobal setobjectproxy setobjecttexture
          setobjecttextureglobal setobjectviewdistance setovercast setowner
          setoxygenremaining setparticlecircle setparticleclass setparticlefire
          setparticleparams setparticlerandom setpilotcameradirection
          setpilotcamerarotation setpilotcameratarget setpilotlight setpipeffect
          setpitch setplayable setplayerrespawntime setpos setposasl setposasl2
          setposaslw setposatl setposition setposworld setpylonloadout
          setpylonspriority setradiomsg setrain setrainbow setrandomlip setrank
          setrectangular setrepaircargo setrotorbrakertd setshadowdistance
          setshotparents setside setsimpletaskalwaysvisible
          setsimpletaskcustomdata setsimpletaskdescription
          setsimpletaskdestination setsimpletasktarget setsimpletasktype
          setsimulweatherlayers setsize setskill setslingload setsoundeffect
          setspeaker setspeech setspeedmode setstamina setstaminascheme
          setstatvalue setsuppression setsystemofunits settargetage
          settaskmarkeroffset settaskresult settaskstate setterraingrid settext
          settimemultiplier settitleeffect settrafficdensity settrafficdistance
          settrafficgap settrafficspeed settriggeractivation settriggerarea
          settriggerstatements settriggertext settriggertimeout settriggertype
          settype setunconscious setunitability setunitloadout setunitpos
          setunitposweak setunitrank setunitrecoilcoefficient setunittrait
          setunloadincombat setuseractiontext setusermfdvalue setvariable
          setvectordir setvectordirandup setvectorup setvehicleammo
          setvehicleammodef setvehiclearmor setvehiclecargo setvehicleid
          setvehiclelock setvehicleposition setvehicleradar
          setvehiclereceiveremotetargets setvehiclereportownposition
          setvehiclereportremotetargets setvehicletipars setvehiclevarname
          setvelocity setvelocitymodelspace setvelocitytransformation
          setviewdistance setvisibleiftreecollapsed setwantedrpmrtd setwaves
          setwaypointbehaviour setwaypointcombatmode setwaypointcompletionradius
          setwaypointdescription setwaypointforcebehaviour setwaypointformation
          setwaypointhouseposition setwaypointloiterradius setwaypointloitertype
          setwaypointname setwaypointposition setwaypointscript setwaypointspeed
          setwaypointstatements setwaypointtimeout setwaypointtype
          setwaypointvisible setweaponreloadingtime setwind setwinddir
          setwindforce setwindstr setwingforcescalertd setwppos show3dicons
          showchat showcinemaborder showcommandingmenu showcompass
          showcuratorcompass showgps showhud showlegend showmap
          shownartillerycomputer shownchat showncompass showncuratorcompass
          showneweditorobject showngps shownhud shownmap shownpad shownradio
          shownscoretable shownuavfeed shownwarrant shownwatch showpad showradio
          showscoretable showsubtitles showuavfeed showwarrant showwatch
          showwaypoint showwaypoints side sideambientlife sidechat sideempty
          sideenemy sidefriendly sidelogic sideradio sideunknown simpletasks
          simulationenabled simulclouddensity simulcloudocclusion simulinclouds
          simulweathersync sin size sizeof skill skillfinal skiptime sleep
          sliderposition sliderrange slidersetposition slidersetrange
          slidersetspeed sliderspeed slingloadassistantshown soldiermagazines
          someammo sort soundvolume spawn speaker speed speedmode splitstring
          sqrt squadparams stance startloadingscreen step stop stopenginertd
          stopped str sunormoon supportinfo suppressfor surfaceiswater
          surfacenormal surfacetype swimindepth switch switchableunits
          switchaction switchcamera switchgesture switchlight switchmove
          synchronizedobjects synchronizedtriggers synchronizedwaypoints
          synchronizeobjectsadd synchronizeobjectsremove synchronizetrigger
          synchronizewaypoint systemchat systemofunits tan targetknowledge
          targets targetsaggregate targetsquery taskalwaysvisible taskchildren
          taskcompleted taskcustomdata taskdescription taskdestination taskhint
          taskmarkeroffset tasknull taskparent taskresult taskstate tasktype
          teammember teammembernull teamname teams teamswitch teamswitchenabled
          teamtype terminate terrainintersect terrainintersectasl
          terrainintersectatasl text textlog textlogformat tg then throw time
          timemultiplier titlecut titlefadeout titleobj titlersc titletext to
          toarray tofixed tolower tostring toupper triggeractivated
          triggeractivation triggerarea triggerattachedvehicle
          triggerattachobject triggerattachvehicle triggerdynamicsimulation
          triggerstatements triggertext triggertimeout triggertimeoutcurrent
          triggertype true try turretlocal turretowner turretunit tvadd tvclear
          tvcollapse tvcollapseall tvcount tvcursel tvdata tvdelete tvexpand
          tvexpandall tvpicture tvpictureright tvsetcolor tvsetcursel tvsetdata
          tvsetpicture tvsetpicturecolor tvsetpicturecolordisabled
          tvsetpicturecolorselected tvsetpictureright tvsetpicturerightcolor
          tvsetpicturerightcolordisabled tvsetpicturerightcolorselected
          tvsetselectcolor tvsettext tvsettooltip tvsetvalue tvsort
          tvsortbyvalue tvtext tvtooltip tvvalue type typename typeof uavcontrol
          uinamespace uisleep unassigncurator unassignitem unassignteam
          unassignvehicle underwater uniform uniformcontainer uniformitems
          uniformmagazines unitaddons unitaimposition unitaimpositionvisual
          unitbackpack unitisuav unitpos unitready unitrecoilcoefficient units
          unitsbelowheight unlinkitem unlockachievement unregistertask
          updatedrawicon updatemenuitem updateobjecttree
          useaiopermapobstructiontest useaisteeringcomponent
          useaudiotimeformoves userinputdisabled vectoradd vectorcos
          vectorcrossproduct vectordiff vectordir vectordirvisual vectordistance
          vectordistancesqr vectordotproduct vectorfromto vectormagnitude
          vectormagnitudesqr vectormodeltoworld vectormodeltoworldvisual
          vectormultiply vectornormalized vectorup vectorupvisual
          vectorworldtomodel vectorworldtomodelvisual vehicle
          vehiclecargoenabled vehiclechat vehicleradio
          vehiclereceiveremotetargets vehiclereportownposition
          vehiclereportremotetargets vehicles vehiclevarname velocity
          velocitymodelspace verifysignature vest vestcontainer vestitems
          vestmagazines viewdistance visiblecompass visiblegps visiblemap
          visibleposition visiblepositionasl visiblescoretable visiblewatch
          waituntil waves waypointattachedobject waypointattachedvehicle
          waypointattachobject waypointattachvehicle waypointbehaviour
          waypointcombatmode waypointcompletionradius waypointdescription
          waypointforcebehaviour waypointformation waypointhouseposition
          waypointloiterradius waypointloitertype waypointname waypointposition
          waypoints waypointscript waypointsenableduav waypointshow
          waypointspeed waypointstatements waypointtimeout
          waypointtimeoutcurrent waypointtype waypointvisible weaponaccessories
          weaponaccessoriescargo weaponcargo weapondirection weaponinertia
          weaponlowered weapons weaponsitems weaponsitemscargo weaponstate
          weaponsturret weightrtd west wfsidetext while wind winddir windrtd
          windstr wingsforcesrtd with worldname worldsize worldtomodel
          worldtomodelvisual worldtoscreen
        )
      end

      def self.detect?(text)
        false
      end

      state :root do
        # Whitespace
        rule %r"\s+", Text

        # Preprocessor instructions
        rule %r"/\*.*?\*/"m, Comment::Multiline
        rule %r"//.*\n", Comment::Single
        rule %r"#(define|undef|if(n)?def|else|endif|include)", Comment::Preproc
        rule %r"\\\r?\n", Comment::Preproc
        rule %r"__(EVAL|EXEC|LINE__|FILE__)", Name::Builtin

        # Literals
        rule %r"\".*?\"", Literal::String
        rule %r"'.*?'", Literal::String
        rule %r"(\$|0x)[0-9a-fA-F]+", Literal::Number::Hex
        rule %r"[0-9]+(\.)?(e[0-9]+)?", Literal::Number::Float

        # Symbols
        rule %r"[\!\%\&\*\+\-\/\<\=\>\^\|]", Operator
        rule %r"[\(\)\{\}\[\]\,\:\;]", Punctuation

        # Identifiers (variables and functions)
        rule %r"[a-zA-Z0-9_]+" do |m|
          name = m[0].downcase
          if self.class.wordoperators.include? name
            token Operator::Word
          elsif self.class.initializers.include? name
            token Keyword::Declaration
          elsif self.class.controlflow.include? name
            token Keyword::Reserved
          elsif self.class.constants.include? name
            token Keyword::Constant
          elsif self.class.namespaces.include? name
            token Keyword::Namespace
          elsif self.class.commands.include? name
            token Name::Function
          elsif %r"_.+" =~ name
            token Name::Variable
          else
            token Name::Variable::Global
          end
        end
      end

    end
  end
end
