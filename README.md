# Kareido

Yet another LLVM example program, inspired by [the official one](http://llvm.org/docs/tutorial/)

## Prerequisites

- Ruby (tested with 2.3)
- LLVM (eg. `brew install llvm` on macOS. Tested with 3.8.1)

## How to run

```
$ bundle install
```

Make a file `a.kar` like:

```
extern i32 putchar(i32);
putchar(65);
```

```
$ bundle exec kareido compile a.kar   #=> creates a.ll
$ bundle exec kareido exec a.kar      #=> creates a.ll and run it with lli
```

## How to run test

```
$ bundle exec rake test
```

## The Language

Comment

    // this is comment

Number (all numbers are treated as `double`)

    12345
    1.3

Unary operators

    -x
    (Note: unary + (eg. +x) is not supported)

Binary operators

    1 + 2
    1 - 2
    1 * 2
    1 / 2   //=> 0.5
    1 < 2   //=> true
    1 != 1  //=> false

Conditional

    if (x == 1) {
      y = 2
    }
    else {
      y = 3
    }

Loop

    for (i = 0, y < 3, +1) {
      x *= 5
    }

Extern

    // only 'i32' or 'double' is supported
    extern i32 putchar(i32);

Function

    extern i32 putchar(i32);
    func add(x, y) {
      return x + y;
      // Note: 0.0 is returned if `return` is omit in a function definition
    }
    // main
    putchar(add(60, 5));

## License

MIT
