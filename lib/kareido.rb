require 'tempfile'

module Kareido; end
require 'kareido/props'

require 'kareido/ast'
require 'kareido/parser'

module Kareido
  def self.run(src)
    ast = Parser.new.parse(src)
    ll = ast.to_ll
    #puts ll
    temp = Tempfile.new
    temp.write(ll)
    temp.close
    return `lli #{temp.path}`
  end
end
