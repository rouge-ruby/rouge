@module ref

ref value = Ref (spawn [ ! => loop value ])

loop value = receive [
  .set new-value => loop new-value
  p, id, .get => { send p (id, value); loop value }
]

# a comment

@object Ref pid [
  set val = .set val > send pid
  get! = .get > send-wait pid
]

@def @module [
  [ <name:IDENT> = [ <*body> ] ] => \q[<*body>]
                                  > compile-module
                                  > $ns/mount-module name
]

partial-cons x = [.cons x $]

foo = ~(bar)
start-sprinklers -when: 'later
prune -harvest

one `and two `or three

foo = ...

@method map _ %

@check %list [
  .cons _ _
  .nil
]

5 > add 3

< foo : IDENT >

"{interpolation $(thing (with (parentheses)))}

print '{hello world}

print "hello double \" quotes"

print \thing{hello world}

print \with-escapes{here is a curly: \} <- }

print \with-nesting{ some curlies: {} <- }
