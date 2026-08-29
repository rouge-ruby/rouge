:- encoding(Encoding).	% this is a single-line comment

/*
this is
a block
comment
*/


:- if(Goal).
	% conditional
:- elif(Goal).
	% compilation
:- else.
	% directives
:- endif.


:- initialization(Goal).
:- op(Precedence, Associativity, Operator).
:- ensure_loaded(File).
:- include(File).
:- set_prolog_flag(Flag, Value).
:- set_logtalk_flag(Flag, Value).


:- object(prototype,
	implements(protocol),
	imports(category),
	extends(parent)).

	:- info([
		version is 1:49:0,
		author is 'Paulo Moura',
		date is 2022-11-04,
		comment is 'Sample prototype for testing syntax coloring.'
	]).

	:- built_in.
	:- threaded.
	:- dynamic.

	:- initialization(some_goal(X, Y)).

	:- uses([
		foobar as fb
	]).

	:- alias(set, [member/2 as set_member/2]).
	:- alias(words, [singular//0 as peculiar//0]).

	:- uses(list, [append/3, member/2]).
	:- uses(queues, [new/1 as new_queue/1]).

	:- use_module(module).
	:- use_module(module, [append/3, member/2]).

	:- multifile(zzz/1).
	:- multifile(module:zzz/1).
	:- multifile(object::zzz/1).

	:- coinductive(comember/1).

	:- use_module(module, [xxx/1, yyy/2, zzz/3]).
	:- export(bbb/3).
	:- reexport(cccc/4).

	:- public(aaa/2).
	:- meta_predicate(aaa(::, *)).
	:- discontiguous(aaa/2).
	:- mode(aaa(+callable, ?integer), zero_or_one).
	:- info(position/2, [
		comment is 'Predicate brief description.',
		arguments is ['Arg1'-'Arg1 description', 'Arg2'-'Arg2 description']
	]).

	:- public(nt//2).
	:- meta_non_terminal(nt(1, *)).

	:- protected(bbb/2).
	:- synchronized(bbb/2).
	:- mode(bbb(+integer, -float), one).
	:- info(bbb/2, [
		comment is 'Predicate brief description.',
		argnames is ['Arg1', 'Arg2']
	]).

	:- private(ccc/2).
	:- dynamic(ccc/2).
	:- mode(ccc(@atom, ?atom, ++list, --ground), one_or_more).
	:- info(ccc/2, [
		comment is 'Predicate brief description.',
		argnames is ['Arg1', 'Arg2']
	]).

	enumerating_entities(Object, Protocol, Category) :-
		current_category(Category),
		current_object(Object),
		current_protocol(Protocol).

	enumerating_properties :-
		category_property(Category, Property),
		object_property(Object, Property),
		protocol_property(Protocol, Property).

	creating_entities(Object, Protocol, Category) :-
		create_category(Category, Relations, Directives, Clauses),
		create_object(Object, Relations, Directives, Clauses),
		create_protocol(Protocol, Relations, Directives).

	abolishing_entities(Object, Protocol, Category) :-
		abolish_category(Category),
		abolish_object(Object),
		abolish_protocol(Protocol).

	entity_relations :-
		extends_object(Prototype, Parent, Scope),
		extends_protocol(Protocol1, Protocol2, Scope),
		extends_category(Category1, Category2, Scope),
		implements_protocol(Object, Protocol, Scope),
		imports_category(Object, Category, Scope),
		instantiates_class(Instance, Class, Scope),
		specializes_class(Class, Superclass, Scope),
		complements_object(Category, Object),
		conforms_to_protocol(ObjOrCtg, Protocol, Scope).

	event_handling :-
		abolish_events(Event, Object, Message, Sender, Monitor),
		current_event(Event, Object, Message, Sender, Monitor),
		define_events(Event, Object, Message, Sender, Monitor).

	multi_threading :-
		threaded(Goals),
		threaded_call(Goal),
		threaded_call(Goal, Tag),
		threaded_once(Goal),
		threaded_once(Goal, Tag),
		threaded_ignore(Goal),
		threaded_exit(Goal),
		threaded_exit(Goal, Tag),
		threaded_peek(Goal),
		threaded_peek(Goal, Tag),
		threaded_cancel(Tag),
		threaded_wait(Notification),
		threaded_notify(Notification).

	engines :-
		threaded_engine(Engine),
		threaded_engine_create(AnswerTemplate, Goal, Engine),
		threaded_engine_destroy(Engine),
		threaded_engine_self(Engine),
		threaded_engine_next(Engine, Answer),
		threaded_engine_next_reified(Engine, Answer),
		threaded_engine_yield(Answer),
		threaded_engine_post(Engine, Term),
		threaded_engine_fetch(Term).

	compiling_and_loading :-
		logtalk_compile(File, Options),
		logtalk_load(File, Options),
		logtalk_library_path(Library, Path),
		logtalk_load_context(Key, Value),
		logtalk_make(Action),
		logtalk_make,
		logtalk_make_target_action(Target).

	flags :-
		current_logtalk_flag(Flag, Value),
		set_logtalk_flag(Flag, Value),
		create_logtalk_flag(Flag, Value, Options).

	execution_context_methods :-
		context(Context),
		parameter(N, Parameter),
		self(Self),
		sender(Sender),
		this(This).

	reflection_methods :-
		current_predicate(Predicate),
		predicate_property(Predicate, Property).

	database_methods :-
		abolish(Name/Arity),
		asserta(Clause),
		assertz(Clause),
		clause(Head, Body),
		retract(Clause),
		retractall(Head).

	exception_methods :-
		catch(Goal, Error, Catcher),
		throw(Error),
		instantiation_error,
		uninstantiation_error(Culprit),
		type_error(Type, Culprit),
		domain_error(Domain, Culprit),
		existence_error(Thing, Culprit),
		permission_error(Operation, Permission, Culprit),
		representation_error(Flag),
		evaluation_error(Exception),
		resource_error(Resource),
		syntax_error(Description),
		system_error.

	all_solutions_methods :-
		bagof(Term, Goal, List),
		bagof(Term, Var^Goal, List),
		findall(Term, Goal, List),
		forall(Generate, Test),
		setof(Term, Goal, List),
		setof(Term, Var1^Var2^Goal, List).

	event_handler_methods :-
		before(Object, Message, Sender),
		after(Object, Message, Sender).

	message_forwarding_method :-
		forward(Message).

	dcg_rules_parsing_methods :-
		phrase(NonTerminal, Input, Rest).

	term_expansion_methods :-
		expand_term(Term, Expanded),
		expand_goal(Goal, Expanded),
		term_expansion(Term, Expanded),
		goal_expansion(Goal, Expanded).

	message_sending :-
		Object::Message,
		::Message,
		^^Message.

	calling_external_code :-
		{goal1, goal2, goal3}.

	context_switching_calls :-
		Object<<Goal.

	lambda_expressions :-
		{X,Y,Z}/[P,Q]>>Goal.

	explicitly_qualified_module_calls :-
		Module:Goal.

	if_then_else :-
		(	If ->
			Then
		;	Else
		).

	numbers :-
		X1 is 13, X2 is -13, X3 is +13,
		Y1 is 13.13, Y2 is -13.13, Y3 is +13.13,
		Z1 is 13.13e-23, Z2 is -13.13e-23, Z3 is +13.13e-23,
		C1 is 0'A, C2 is 0'a, C3 is 0'-, C4 is 0'*, C5 is 0'%,
		C6 is 0'\n, C7 is 0'\\, C8 is 0'\', C9 is 0'\", C10 is 0'\`,
		B1 is 0b1011101,
		O1 is 0o1234560,
		H1 is 0x1234567890abcDEF.

	functions :-
		A is atan(3.14) + atan2(1, 0) + acos(0.5) + asin(0.5) + sin(0.77) - cos(123.23) - tan(0.33),
		B is sign(-12) * abs(35/78),
		C is truncate(3.14) + round(-7.8) - ceiling(111.88),
		D is exp(3.8) - log(123.98) / sqrt(33) * 23 ** 4 + 12345^2,
		E is rem(3, 2) + mod(5, 3) - div(8, 4) * 2 rem 2 // 5 mod 3 - 8 div 4 + pi * e,
		F is float_fractional_part(3.14) + float_integer_part(3.14),
		G is float(33) + floor(99.99),
		I is min(3,4) + max(4,5).

	bitwise :-
		A is 16 >> 2,
		B is 16 << 2,
		C is 10 /\ 12,
		D is 10 \/ 12,
		E is \ 10,
		F is xor(13, 7).

	term_unification :-
		Term1 = Term2,
		Term1 \= Term2,
		unify_with_occurs_check(Term1, Term2),
		subsumes_term(General, Specific).

	term_testing :-
		atom(Atom),
		atomic(Atomic),
		integer(Integer),
		float(Float),
		callable(Term),
		compound(Term),
		nonvar(Term),
		var(Term),
		number(Number),
		ground(Term),
		acyclic_term(Term).

	term_comparison :-
		compare(Order, Term1, Term2),
		Term1 == Term2,
		Term1 \== Term2,
		Term1 @< Term2,
		Term1 @=< Term2,
		Term1 @>= Term2,
		Term1 @> Term2.

	term_creation_and_decomposition :-
		functor(Term, Name, Arity),
		arg(N, Term, Arg),
		Term =.. [Functor| Args],
		copy_term(Term, Copy),
		numbervars(Term, Start, End),
		term_variables(Term, Variables).

	arithmetic_evaluation :-
		X is Expression.

	arithmetic_comparison :-
		Exp1 =:= Exp2,
		Exp1 =\= Exp2,
		Exp1 < Exp2,
		Exp1 =< Exp2,
		Exp1 > Exp2,
		Exp1 >= Exp2.

	stream_selection_and_control :-
		current_input(Stream),
		current_output(Stream),
		set_input(Stream),
		set_output(Stream),
		open(Source, Mode, Stream, Options),
		close(Stream),
		flush_output(Stream),
		stream_property(Stream, Property),
		at_end_of_stream(Stream),
		set_stream_position(Stream, Position),
		flush_output,
		at_end_of_stream.

	character_input_output :-
		get_char(Char),
		get_code(Code),
		peek_char(Char),
		peek_code(Code),
		put_char(Char),
		put_code(Code),
		nl(Stream),
		nl.

	byte_input_output :-
		get_byte(Byte),
		peek_byte(Byte),
		put_byte(Byte).

	term_input_output :-
		read(Term),
		read_term(Stream, Term, Options),
		write(Term),
		write(Term),
		write_canonical(Term),
		write_term(Stream, Term, Options),
		current_op(Precedence, Associativity, Operator),
		op(Precedence, Associativity, Operator),
		current_char_conversion(InChar, OutChar),
		char_conversion(InChar, OutChar).

	logic_and_control :-
		\+ Goal,
		call(Goal),
		once(Goal),
		ignore(Goal),
		true,
		fail,
		false,
		repeat,
		!.

	atomic_term_processing :-
		atom_length(Atom, Length),
		atom_chars(Atom, Chars),
		atom_codes(Atom, Codes),
		atom_concat(Atom1, Atom2, Atom),
		sub_atom(Atom, Before, Length, After, SubAtom),
		char_code(Char, Code),
		number_chars(Number, Chars),
		number_codes(Number, Codes).

	implementation_defined_hooks :-
		current_prolog_flag(Flag, Value),
		set_prolog_flag(Flag, Value),
		halt(ExitCode),
		halt.

	sorting :-
		keysort(List, Sorted),
		sort(List, Sorted).

	number(C) --> "+", number(C).
	number(C) --> "-", number(X), {C is -X}.
	number(X) --> [C], {0'0 =< C, C =< 0'9, X is C - 0'0}.

	escape_sequences :-
		write('Quoted atom with a quote ('') inside.'),
		write('Quoted atom with a quote (\') inside using a control escape sequence.'),
		write('Quoted atom with a backslash (\\) inside.'),
		write('Quoted atom with control escape sequences: \a \b \r \f \t \n \v'),
		write('Quoted atom with an octal escape sequence: \123\.'),
		write('Quoted atom with an hexadecimal escape sequence: \x123f\.').

	escape_sequences :-
		write("Double-quoted term with a double-quote ("") inside."),
		write("Double-quoted term with a double-quote (\") inside using a control escape sequence."),
		write("Double-quoted term with a backslash (\\) inside."),
		write("Double-quoted term with control escape sequences: \a \b \r \f \t \n \v"),
		write("Double-quoted term with an octal escape sequence: \123\."),
		write("Double-quoted term with an hexadecimal escape sequence: \x123f\.").

	% nothing in the following predicate definition should be highlighted
	sort :-
		forall,
		object,
		write,
		number.

:- end_object.


:- object(class,
	implements(protected::protocol),
	imports(private::category),
	instantiates(metaclass),
	specializes(superclass)).

:- end_object.


:- object(parametric(Parameter, "String", 33.78),
	implements(protocol),
	imports(category),
	extends(parent(Parameter))).

:- end_object.


:- category(category,
	implements(protocol),
	extends(other_category)).

:- end_category.


:- protocol(extended,
	extends(minimal)).

:- end_protocol.


:- module(module, [foo/1, bar/2]).

:- use_module(library).
:- use_module(library, [baz/3]).

:- reexport(library).
:- reexport(library, [qux/4]).

:- export(quux/5).
