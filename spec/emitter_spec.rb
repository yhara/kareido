require 'spec_helper'

describe "ll emitter:" do
  def to_ll(src)
    ast = Kareido::Parser.new.parse(src)
    ast.to_ll
  end

  describe "extern" do
    it "should add the body to ll" do
      ll = to_ll(<<~EOD)
        extern i32 putchar(i32);
      EOD
      expect(ll).to eq(<<~EOD)
        declare i32 @putchar(i32)
        define i32 @main() {
          ret i32 0
        }
      EOD
    end
  end

  describe "main stmts" do
    it "should be the body of @main" do
      ll = to_ll(<<~EOD)
        extern i32 putchar(i32);
        putchar(65);
      EOD
      expect(ll).to eq(<<~EOD)
        declare i32 @putchar(i32)
        define i32 @main() {
        %reg1 = add i32 0, 65
        %reg2 = call i32 @putchar(i32 %reg1)
          ret i32 0
        }
      EOD
    end
  end
end
