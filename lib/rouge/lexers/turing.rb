# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Turing < RegexLexer
      title "Turing"
      desc "The Turing programming language (http://compsci.ca/holtsoft/)"
      tag 'turing'
      filenames '*.t', '*.tu'

      def self.analyze_text(text)
        return 1 if text =~ /whatdotcolour\s*\(|whatdotcolor\s*\(|drawmapleleaf\s*\(|drawfillmapleleaf\s*\(/
      end

      methods = %w(
        abs addr arctan arctand anyclass
        break buttonchoose buttonmoved buttonwait ceil
        chr clock cls color colorback
        colour colourback cos cosd date
        delay drawarc drawbox drawdot drawfill
        drawfillarc drawfillbox drawfillmapleleaf drawfilloval drawfillpolygon
        drawfillstar drawline drawmapleleaf drawoval drawpic
        drawpolygon drawstar empty eof erealstr
        exp fetcharg floor frealstr getch
        getchar getenv getpid getpriority hasch
        index intreal intstr length ln
        locate locatexy lower max maxcol
        maxcolor maxcolour maxint maxnat maxrow
        maxx maxy min minint minnat
        mousehide mouseshow mousewhere nargs natreal
        natstr nil ord palette play
        playdone pred rand randint randnext
        randomize randseed realstr repeat round
        setpriority setscreen sign simutime sin
        sind sizeof sizepic sound sqrt
        strint strintok strnat strnatok strreal
        strrealok succ sysclock sysexit system
        takepic time upper wallclock whatcol
        whatcolor whatcolorback whatcolour whatcolourback whatdotcolor
        whatdotcolour whatpalette whatrow whattextchar whattextcolor
        whattextcolorback whattextcolour whattextcolourback
      )

      modules = %w(
        Brush Button CheckBox Comm Concurrency
        Config Dir Draw DropBox EditBox
        Error ErrorNum Event File Font
        GUI Input Joytick Keyboard Limits
        ListBox Math Menu Mouse Music
        Net Obsolete PC Pen Pic
        Print RadioButton Rand RGB Sound
        Sprite Str Stream Student Sys
        Text Time TypeConv Video View
        Window
      )

      constants = %w(
        black blue brightblue brightcyan brightgreen
        brightmagenta brightpurple brightred brightwhite brown
        brushErrorBase cdMaxNumColors cdMaxNumColours cdMaxNumPages cdScreenHeight
        cdScreenWidth clLanguageVersion clMaxNumDirStreams clMaxNumRunTimeArgs clMaxNumStreams
        clRelease cmFPU cmOS cmProcessor colorbg
        colourbg colorfg colourfg configErrorBase cyan
        darkgray darkgrey defFontID defWinID dirErrorBase drawErrorBase
        errWinID fileErrorBase fontDefaultID
        fontErrorBase fsysErrorBase generalErrorBase gray green
        grey guiErrorBase joystick1 joystick2 lexErrorBase
        magenta mouseErrorBase musicErrorBase penErrorBase
        placeCenterDisplay placeCentreWindow printerErrorBase purple
        red rgbErrorBase spriteErrorBase streamErrorBase textErrorBase
        timeErrorBase unixSignalToException viewErrorBase white windowErrorBase
        yellow true false
      )

      keywords = %w(
        addressint all and array asm
        assert begin bind bits body
        boolean break by case char
        cheat checked class close collection
        condition const decreasing def deferred
        div else elseif elsif end
        endfor endif endloop enum exit
        export external fcn flexible
        for fork forward free function
        get handler if implement import
        in include inherit init int
        int1 int2 int4 invariant label
        loop mod module monitor nat
        nat1 nat2 nat4 new not
        objectclass of opaque open or
        packed pause pervasive pointer post
        pre priority proc procedure process
        put quit read real real4
        real8 record register rem result
        return seek self set shl
        shr signal skip string tag
        tell then timeout to
        type unchecked union unqualified var
        wait when write xor
      )

      declarations = %w(
        abstract const enum extends final implements native private protected
        public static strictfp super synchronized throws transient volatile
      )

      types = %w(boolean byte char double float int long short void)

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      state :root do
        rule /[^\S\n]+/, Text
        rule %r(%.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule /'.'/, Literal::String::Char
      end
    end
  end
end
