module Rouge
  module Lexers
    class Sbsl < RegexLexer
      title "1C (SBSL)"
      desc "The 1C:Executor programming language"
      tag 'sbsl'
      filenames '*.sbsl', '*.xbsl'

      def self.detect?(text)
        return true if text.shebang? 'executor'
      end

      keywords = %w(
        вконце finally
        возврат return
        выбор	case
        выбросить	throw
        для	for
        если if
        знч	val
        и	and
        из in
        или	or
        импорт import
        иначе	else
        исключение exception
        исп	use
        как	as
        когда	when
        конст	const
        конструктор	constructor
        метод	method
        не not
        неизвестно any
        новый	new
        обз	req
        область	scope
        пер	var
        перечисление enum
        по to
        поймать	catch
        пока while
        попытка	try
        прервать break
        продолжить continue
        структура	structure
        умолчание	default
        это	is
        статический static
      )
      keywords_constants = %w(
        Истина True
        Ложь False

      )
      types = %w(
        String Строка
        Number Число
        Boolean Булево
        Неопределено Undefined
        Момент
        ДатаВремя
        Дата
        Время
        Длительность
        ЧасовойПояс
        Ууид
        неизвестно
        Сравнимое
        Закрываемое
        Обходимое
        Форматируемое
        Байты
        Контекст
      )
      id = /[[:alpha:]_][[:word:]]*/
      string_literal = /(\\\\|\\"|[^"])*/
      keyword_declaration = /(?<=[^\wа-яё]|^)/
      state :root do
        rule %r/\n/, Text
        rule %r/[^\S\n]+/, Text
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
        rule %r(//.*$), Comment::Single
        rule %r(#!.*$), Comment::Single
        rule %r/[\[\]:(),;]/, Punctuation
        rule %r/#{keyword_declaration}\&#{id}/, Keyword::Declaration
        rule %r/#{keyword_declaration}\#.*$/, Keyword::Declaration
        rule %r/(?:#{types.join('|')})\b/, Keyword::Type
        rule %r/[-+\/|*%$=<>.:?!&{}]/, Operator
        rule %r/(?:#{keywords.join('|')})\b/, Keyword
        rule %r/(?:#{keywords_constants.join('|')})\b/, Keyword::Constant
        rule %r/@#{id}/, Name::Decorator
        rule %r/[\wа-яё][\wа-яё]*/i, Name::Variable
        rule %r/\b((\h{8}-(\h{4}-){3}\h{12})|\d+\.?\d*)\b/, Literal::Number
        rule %r/"#{string_literal}"/, Literal::String::Single
        rule %r/'#{string_literal}'/, Literal::String::Single
      end
    end
  end
end
