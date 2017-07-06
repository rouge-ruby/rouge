# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Turing < RegexLexer
      title "Turing"
      desc "The Turing programming language (http://compsci.ca/holtsoft/)"
      tag 'turing'
      filenames '*.t', '*.tu'

      def self.analyze_text(text)
        return 0.9 if text =~ /whatdotcolour\s*\(|whatdotcolor\s*\(|drawmapleleaf\s*\(|drawfillmapleleaf\s*\(/
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

      reserved = %w(
        addressint all asm
        assert begin bind bits body
        break by case
        cheat checked class close collection
        condition const decreasing def deferred
        else elseif elsif end
        endfor endif endloop exit
        export external fcn
        for fork forward free function
        get handler if implement
        inherit init
        invariant label
        loop module monitor
        new
        objectclass of opaque open
        packed pause pervasive pointer post
        pre priority proc procedure process
        put quit read
        record register result
        return seek self set
        signal skip tag
        tell then timeout to
        unchecked union unqualified
        wait when write
      )

      import = %w(import include)

      declarations = %w(
        var enum type unit
      )

      types = %w(
        boolean char string
        real real4 real8
        int int1 int2 int4
        nat nat1 nat2 nat4
        flexible array
      )

      operators = %w(
        \+ - \* \/
        < > = :
        \^ #
        ~
        & \|
        \\( \\)
        , \.
      )

      wordOperators = %w(
        div mod rem
        not and or xor
        in
        shl shr
      )

      state :root do
        rule /[^\S\n]+/, Text
	rule /\n/, Text

        rule /#{operators.join('|')}/, Operator

        rule %r(%.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule /(?:#{constants.join('|')})\b/, Keyword::Constant
        rule /(?:#{declarations.join('|')})\b/, Keyword::Declaration
        rule /(?:#{reserved.join('|')})\b/, Keyword::Reserved
        rule /(?:#{types.join('|')})\b/, Keyword::Type

        rule /(?:#{import.join('|')}).*/, Name::Namespace

        rule /(?:#{modules.join('|')})(?=\.)\b/, Name::Builtin
        rule /(?:#{methods.join('|')})\b/, Name::Function


        rule /"(\\\\|\\"|[^"])*"/, Literal::String
        rule /'\\?.'/, Literal::String::Char
        rule /(?:\d*\.)?\d+/, Literal::Number

        rule /\b(#{wordOperators.join('|')})\b/, Operator::Word

        rule /[a-zA-Z_][a-zA-Z0-9_]*/, Name

      end
    end
  end
end
