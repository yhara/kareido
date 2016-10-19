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
          %reg1 = add double 0.0, 65.0
          %reg2 = fptosi double %reg1 to i32
          %reg3 = call i32 @putchar(i32 %reg2)
          %reg4 = sitofp i32 %reg3 to double
          ret i32 0
        }
      EOD
    end
  end

  context "binary expr" do
    describe "`+`" do
      it "should conveted to add" do
        ll = to_ll(<<~EOD)
          extern i32 putchar(i32);
          putchar(60 + 5);
        EOD
        expect(ll).to eq(<<~EOD)
          declare i32 @putchar(i32)
          define i32 @main() {
            %reg1 = add double 0.0, 60.0
            %reg2 = add double 0.0, 5.0
            %reg3 = fadd double %reg1, %reg2
            %reg4 = fptosi double %reg3 to i32
            %reg5 = call i32 @putchar(i32 %reg4)
            %reg6 = sitofp i32 %reg5 to double
            ret i32 0
          }
        EOD
      end
    end
  end

  #describe "defun"
  #describe "if"
  #describe "for"
  #describe "unary expr"
  #describe "varref"
end
