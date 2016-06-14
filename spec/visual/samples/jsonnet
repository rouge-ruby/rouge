/*
Here is a multi-line comment.
*/

local foo = import "bar/baz.jsonnet";

// Single line comment.
local CCompiler = {
  cFlags: [],
  out: "a.out",
  local flags_str = std.join(" ", self.cFlags),
  local files_str = std.join(" ", self.files),
  cmd: "%s %s %s -o %s" % [self.compiler, flags_str, files_str, self.out],
};

// Compiler specializations
local Gcc = CCompiler { compiler: "gcc" };
local Clang = CCompiler { compiler: "clang" };

// Mixins - append flags
local Opt = {
  cFlags: super.cFlags + ["-O3", "-DNDEBUG"]
};
local Dbg = {
  cflags: super.cFlags + ["-g"]
};

local script = |||
  #!/bin/bash
  if [ $# -lt 1 ]; then
    echo "No arguments!"
  else
    echo "$# arguments!"
  fi
|||;

{
  targets: [
    Gcc {
      files: ["a.c", "b.c"]
    },
    Clang {
      files: ["test.c"],
      out: "test"
    },
    Clang + Opt {
      files: ['test2.c'], out: "test2"
    }
    Gcc + Opt + Dbg { files: ["foo.c", "bar.c"], out: "baz" },
  ],
  values: {
    string: "newline \n tab quote\" \tunicode\u0af4",
    integer: 12,
    negativeInteger: -12,
    integerExponent: 12e+4,
    float: 0.04,
    floatExponent: 4.0e-2,
    boolean: true,
    nullValue: null,
    targets: $.targets,
  }
}
