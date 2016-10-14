require 'spec_helper'

describe "ll emitter" do
  def to_ll(src)
    Kareido::Parser.new.parse(src).to_ll
  end

  describe "extern" do
    it "should add the body to ll" do
      ll = to_ll(<<~EOD)
        #extern declare i32 @putchar(i32)
      EOD
      expect(ll).to eq(<<~EOD)
        declare i32 @putchar(i32)
      EOD
    end
  end
end
