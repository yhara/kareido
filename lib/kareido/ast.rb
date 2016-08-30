module FjR
  class Ast
    class Node
      extend Props
    end

    class Program < Node
      props :exprs
    end
  end
end
