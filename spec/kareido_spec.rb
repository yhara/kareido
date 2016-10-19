require 'spec_helper'

MANDEL = <<EOD
extern i32 putchar(i32);

func printdensity(d) {
  if (d > 8) {
    putchar(32);  // ' '
  }
  else if (d > 4) {
    putchar(46);  // '.'
  }
  else if (d > 2) {
    putchar(43);  // '+'
  }
  else {
    putchar(42); // '*'
  }
}

func mandleconverger(real, imag, iters, creal, cimag) {
  if (iters > 255 || (real*real + imag*imag > 4)) {
    iters;
  }
  else {
    mandleconverger(real*real - imag*imag + creal,
                    2*real*imag + cimag,
                    iters+1, creal, cimag);
  }
}

func mandleconverge(real, imag) {
  mandleconverger(real, imag, 0, real, imag);
}

func mandelhelp(xmin, xmax, xstep, ymin, ymax, ystep) {
  for (y ; ymin ... ymax ; ystep) {
    for (x ; xmin ... xmax ; xstep) {
       printdensity(mandleconverge(x,y));
    }
    putchar(10);
  }
}

func mandel(realstart, imagstart, realmag, imagmag) {
  mandelhelp(realstart, realstart+realmag*78, realmag,
             imagstart, imagstart+imagmag*40, imagmag);
}

mandel(-2.3, -1.3, 0.05, 0.07);
EOD

describe Kareido do
  it 'should parse example program' do
    ast = Kareido::Parser.new.parse(MANDEL)
    expect(ast).to be_kind_of(Kareido::Ast::Node)
  end

  describe '.run' do
    it 'should run kareido program (with llc)' do
      out = Kareido.run(<<~EOD)
        extern i32 putchar(i32);
        putchar(65);
      EOD
      expect(out).to eq("A")
    end
  end

  describe 'programs' do
    it 'defun' do
      src = <<-EOD
        extern i32 putchar(i32);
        func add(x, y){ return x + y; }
        putchar(add(60, 5));
      EOD
      expect(Kareido.run(src)).to eq("A")
    end

    it '+' do
      src = "extern i32 putchar(i32); putchar(60 + 5);"
      expect(Kareido.run(src)).to eq("A")
    end

    it '-' do
      src = "extern i32 putchar(i32); putchar(70 - 5);"
      expect(Kareido.run(src)).to eq("A")
    end

    it '*' do
      src = "extern i32 putchar(i32); putchar(13 * 5);"
      expect(Kareido.run(src)).to eq("A")
    end

    it '/' do
      src = "extern i32 putchar(i32); putchar(157 / 2.41);"
      expect(Kareido.run(src)).to eq("A")
    end

    it '==' do
      src = "extern i32 putchar(i32); if (1 == 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (1 == 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '>' do
      src = "extern i32 putchar(i32); if (2 > 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (1 > 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '>=' do
      src = "extern i32 putchar(i32); if (1 >= 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (1 >= 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '<' do
      src = "extern i32 putchar(i32); if (1 < 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (2 < 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '<=' do
      src = "extern i32 putchar(i32); if (1 <= 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (2 <= 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '!=' do
      src = "extern i32 putchar(i32); if (1 != 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (1 != 1) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '&&' do
      src = "extern i32 putchar(i32); if (1 == 1 && 2 == 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (1 == 1 && 2 == 0) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it '||' do
      src = "extern i32 putchar(i32); if (1 == 0 || 2 == 2) { putchar(65); }"
      expect(Kareido.run(src)).to eq("A")
      src = "extern i32 putchar(i32); if (1 == 0 || 2 == 0) { putchar(65); }"
      expect(Kareido.run(src)).to eq("")
    end

    it 'unary -' do
      src = "extern i32 putchar(i32); putchar(-(-65));"
      expect(Kareido.run(src)).to eq("A")
    end
  end
end
