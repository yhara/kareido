require 'spec_helper'

MANDEL = <<EOD
extern putchard(char);

func printdensity(d) {
  if (d > 8) {
    putchard(32);  // ' '
  }
  else if (d > 4) {
    putchard(46);  // '.'
  }
  else if (d > 2) {
    putchard(43);  // '+'
  }
  else {
    putchard(42); // '*'
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
    putchard(10);
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
    p ast: ast
    expect(ast).to be_kind_of(Kareido::Ast::Node)
  end
end
