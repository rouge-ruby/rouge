<?hh // strict

// Unlike PHP, there's no top-level content (e.g. HTML) before `<?hh`, and `?>` is unsupported.

namespace Foo\Bar;

async function main(Vector<string> $argv): Awaitable<void> {
  var_dump($argv->map($x ==> 'Arg: '.$x."\n"));
}

// vec: new by-value container
// Vector: old by-ref (object semantics) container
async function wrap(vec<string> $argv): Awaitable<void> {
  await main(new Vector($argv));
}

function foo(int $x): string {
  // UNSAFE
  return $x;
}

function bar(int $x): string {
  return /* UNSAFE_EXPR */ $x;
}

/* HH_FIXME[1002] pseudomain in strict file */
HH\Asio\join(main());
