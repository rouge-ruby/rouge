// Copyright (c) 2019 Foretellix. All right reserved.

/**
 * Python style SDL lexer
 */

lexer grammar PySdlLexer;
@lexer::header {
package com.ftx.sdl;
}

tokens {
    INDENT,
    DEDENT,
    LINE
}
channels {
    COMMENTS,
    PREPROC
}

@lexer::members {
    private java.util.Queue<Token> tokens = new java.util.LinkedList<Token>();
    private java.util.Stack<Integer> indentStack = new java.util.Stack<>();
    private java.util.Stack<Integer> interpolationStack = new java.util.Stack<>();
    private int line = 0;
    private int listNesting = 0;

    void init() {
        indentStack.empty();
        indentStack.push(0);
        interpolationStack.empty();
        interpolationStack.push(-1);
    }

    public void enterInterpolation() {
        interpolationStack.push(listNesting);
    }

    public void checkInterpolationClose() {
        if (interpolationStack.peek() == listNesting) {
            interpolationStack.pop();
            popMode();
        }
    }

    @Override
    public void emit(Token t) {
        line = t.getLine();
        tokens.offer(t);
        /* Lexer debug only...
        System.out.println(t.getText() + " at "+ line + "    <"+
        PySdlLexer.VOCABULARY.getSymbolicName(t.getType())+ ">");
        */
    }

    @Override
    public Token nextToken() {
        if (tokens.isEmpty()) {
            super.nextToken();
        }
        return tokens.poll();
    }

    private void indent(int count) {
        CommonToken tok = new CommonToken(com.ftx.sdl.PySdlLexer.INDENT,"INDENT");
        tok.setLine(line);
        emit(tok);
        indentStack.push(count);
    }

    private void dedent() {
        CommonToken tok = new CommonToken(com.ftx.sdl.PySdlLexer.LINE,"LINE");
        tok.setLine(line);
        emit(tok);
        tok = new CommonToken(com.ftx.sdl.PySdlLexer.DEDENT,"DEDENT");
        tok.setLine(line);
        emit(tok);
        indentStack.pop();
    }

    private void line() {
        CommonToken tok = new CommonToken(com.ftx.sdl.PySdlLexer.LINE,"LINE");
        tok.setLine(line);
        emit(tok);
    }

    /*
     * Called only when last clause is missing a newline
     */
    private void handleEof() {
        throw new ParseCancellationException("Missing newline at end of file");
    }

    private void scanWhitespace() {
        if (listNesting > 0) return;
        int c = _input.LA(-1);
        int count = 0;
        boolean done = false;

        while (!done) {
            c = _input.LA(1);
            switch (c) {
                case ' '  : count++; break;
                case '\t' :
                    throw new ParseCancellationException("Replace TAB(s) at line "+ line);
                case '#'  : return;
                case '\n' : return;
                case '\r' : return;
                case '/'  :  if (_input.LA(2) == '*') return;
                case EOF  :
                    while (indentStack.size() > 1) dedent();
                    line();
                    return;
                default   :  done= true; break;
            }
            if (!done) _input.consume();
        }

        if (count > indentStack.peek()) {
            indent(count);
        } else if (count < indentStack.peek()) {
            while (count < indentStack.peek()) {
                dedent();
            }
            if (count != indentStack.peek()) {
                // ERROR - inconsistent indentation
				throw new ParseCancellationException("Inconsistent indentation following line "+ line);
            }
        } else {
            line();
        }
    }

    /**
     * preProcessor is called with the full macro string, passed down to the Kotlin
     * pre-processor that parses the macro, expands it, passes it to a new instance
     * of this lexer and returns the resulting token stream.
     * That token stream is traversed, and the tokens are pushed into this lexer buffer
     * so that the main parser is unaware of the underlying processing.
     */
    private void preProcessor() {
        String cmd = _input.toString().substring(_tokenStartCharIndex,_input.index());
        TokenStream ts = SdlCompilerKt.preProcess(cmd);
        Token t = ts.get(ts.index());
        while(t.getType() != Token.EOF) {
            emit(t);
            ts.consume();
            t = ts.get(ts.index());
        }
    }
}
/*
 * handling Python like syntax constructs
 */
fragment NL     : '\r'? '\n' | '\r';
fragment WS     : '\t' | ' ';
EscNewLine: '\\' NL WS? -> skip;
NewLine : NL WS? {scanWhitespace();} -> skip;
Separator : WS -> skip;
LastLine : ~[\n\r]+ EOF {handleEof();};

/*
 *  Keywords
 */
  AGENT:     'agent' ;
  ANY:       'any' ;
  CALL:      'call' ;
  COVER:     'cover' ;
  DEF:       'def' ;
  DEFAULT:   'default' ;
  DO:        'do' ;
  ELSE:      'else' ;
  EMIT:      'emit' ;
  EMPTY:     'empty' ;
  EVENT:     'event' ;
  EXTEND:    'extend' ;
  IF:        'if' ;
  IMPORT:    'import' ->pushMode(FILE_PATH_MODE) ;
  IN:        'in' ;
  ISFIRST:   'is'[ ]+'first';
  ISONLY:    'is'[ ]+'only';
  ISALSO:    'is'[ ]+'also';
  IS:        'is' ;
  KEEP:      'keep' ;
  LIKE:      'like' ;
  LISTOF:    'list'[ ]+'of';
  MATCH:     'match';
  MODIFIER:  'modifier';
  MULTIMATCH:'multi_match';
  NOT:       'not';
  ON:        'on' ;
  OUTER:     'outer';
  PROPERTIES: 'properties';
  REPEAT:    'repeat';
  SAMPLE:    'sample';
  SCENARIO:  'scenario' ;
  SOFT:      'soft';
  STRUCT:    'struct' ;
  THEN:      'then' ;
  TRY:       'try' ;
  TYPE:      'type' ;
  UNDEFINED: 'undefined';
  WAIT:      'wait';
  WHEN:      'when';
  WITH:      'with' ;
/*
 * Other reserved words
 */

  TRUE:   'true' ;
  FALSE:  'false' ;
  NULL:   'null' ;
  THIS:   'this' ;
  IT:     'it' ;

/*
 * Separators and other punctuation
 */

  QUANTIFIED_CLOSE_BRACKET:  ']'[a-z_]+ {listNesting--;};
  OPEN_BRACKET:   '[' {listNesting++;};
  CLOSE_BRACKET:  ']' {listNesting--;};

  OPEN_PAREN:     '(' {listNesting++;};
  CLOSE_PAREN:    ')' {checkInterpolationClose(); listNesting--;};

  OPEN_CURLY:     '{';
  CLOSE_CURLY:    '}';

  DOTDOT:     '..' ;
  DOT:        '.' ;
  COMMA:      ',' ;
  DOUBLE_COL: '::' ;
  COLON:      ':' ;
  SEMICOLON:  ';' ;


/*
 * Operator tokens
 */

  TILDA:          '~';
  EXCLAMATION:    '!';
  QUESTION:       '?';
  DOLLAR:         '$';
  AT:             '@';

  MULTIPLY: '*';
  DIVIDE: '/';
  MODULO: '%';
  PLUS: '+';
  MINUS: '-';
  LESS_THAN: '<';
  GREATER_THAN: '>';
  LESS_THAN_OR_EQUALS: '<=';
  GREATER_THAN_OR_EQUALS: '>=';
  EQUALS: '==';
  NOT_EQUALS: '!=';
  BIT_AND: '&';
  BIT_XOR: '^';
  BIT_OR: '|';
  LOGICAL_AND: 'and';
  LOGICAL_OR: 'or';
  IMPLY:      '=>';
  SINGLE_EQUAL: '=';

/*
 * Identifier
 */

  fragment IdentifierLead : [_a-zA-Z] ;
  fragment IdentifierMiddle : [_a-zA-Z0-9!] ;
  fragment IdentifierTail : [_a-zA-Z0-9] ;

  Identifier
    : IdentifierLead
    | IdentifierLead IdentifierMiddle* IdentifierTail
    ;

/*
 * Number formats
 */

  BinaryIntegerLiteral: ('0b' | '0B') BinaryDigit (BinaryDigitOrUnderscore* BinaryDigit)? ;
  fragment BinaryDigit: [01] ;
  fragment BinaryDigitOrUnderscore: BinaryDigit | '_' ;

  OctalIntegerLiteral: '0' OctalDigitOrUnderscore* OctalDigit ;
  fragment OctalDigit: [0-7];
  fragment OctalDigitOrUnderscore: OctalDigit | '_';

  DecimalIntegerLiteral: '0' | DecimalNonZeroDigit (DecimalDigitOrUnderscore* DecimalDigit)? ;
  fragment DecimalNonZeroDigit: [1-9];
  fragment DecimalDigit: [0-9];
  fragment DecimalDigitOrUnderscore: DecimalDigit | '_';

  HexIntegerLiteral: ('0x' | '0X') HexDigit (HexDigitOrUnderscore* HexDigit)? ;
  fragment HexDigit: [0-9a-fA-F];
  fragment HexDigitOrUnderscore: HexDigit | '_';

  FloatLiteral
   : DecimalInteger '.' DecimalDigit+ ExponentPart?
   | '.' DecimalDigit+ ExponentPart?
   | DecimalInteger ExponentPart?
   ;
  fragment ExponentPart: [eE] [+-]? DecimalDigit+ ;
  fragment DecimalInteger : '0' | [1-9] DecimalDigit* ;

/*
 * Quantifier experiment
 */

 QuantifiedIntegerLiteral
    : DecimalIntegerLiteral [a-zA-Z_]+
    | FloatLiteral [a-zA-Z_]+
    ;

/*
 * String, RegExp and such
 */

//  StringLiteral
//    : '"' (ESC | ~["\\])* '"'
//    ;

  STRING_OPEN : '"' -> pushMode(STRING) ;

   /*
    * Comments, whitespace etc.
    */
  SKIP_FILE_PRAGMA : '#COMPILER_SKIP_FILE' -> pushMode(IGNORE_PRAGMA_MODE);
  IGNORE_PRAGMA_BEGIN : '#COMPILER_IGNORE_BEGIN' ->  skip, pushMode(IGNORE_PRAGMA_MODE);
  BLOCK_COMMENT      :   '/*' (BLOCK_COMMENT|.)*? '*/' -> channel(COMMENTS) ;
  LINE_COMMENT : '#' ~('\r' | '\n')* ->channel(COMMENTS);

/*
 * Preprocessor tokens
 */
 fragment PP_BODY: '<<' .*? '$<<';
 PREPROCESSOR_CMD: '$' .*? (NL | PP_BODY) {preProcessor();} -> channel(PREPROC) ;

/*
 * Other modes
 */

// PRAGMA mode is to overcome native e embedded in SDL files
mode IGNORE_PRAGMA_MODE;
  IGNORE_PRAGMA_END : .* '#COMPILER_IGNORE_END' ->  skip, popMode;
  EOF_REACHED: .* EOF -> skip, popMode;

// Handle file path parsing by pattern matching, Lexer to pass this through
mode FILE_PATH_MODE;
  PATH_EXP: ~[\n]+ -> popMode ;

mode STRING;
  fragment ESC : '\\' . ;
  BARE_STRING  : (ESC | ~[$"\\])+ ;
  INTER_OPEN   : '$(' {listNesting++; enterInterpolation();} -> pushMode(DEFAULT_MODE) ;
  STRING_CLOSE : '"' -> popMode;



