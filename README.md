# Kareido

Yet another LLVM example program, inspired by [the official one](http://llvm.org/docs/tutorial/)

## The Language

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

## License

MIT
