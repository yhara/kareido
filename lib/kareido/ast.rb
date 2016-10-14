module Kareido
  class Ast
    class Node
      extend Props
    end

    class Program < Node
      props :defs, :main_stmts

      def to_ll
        defs.map(&:to_ll).join +
          main_stmts.map(&:to_ll).join
      end
    end

    class Defun < Node
      props :name, :param_names, :stmts
    end

    class Extern < Node
      props :body

      def to_ll
        @body + "\n"
      end
    end

    class If < Node
      props :cond_expr, :then_stmts, :else_stmts
    end

    class For < Node
      props :varname, :nbegin, :nend, :step
    end

    class BinExpr < Node
      props :op, :left, :right
    end

    class UnaryExpr < Node
      props :op, :expr
    end

    class FunCall < Node
      props :name, :args
    end

    class VarRef < Node
      props :name
    end

    class Literal < Node
      props :value

      def to_ll
        case @value
        when Numeric
          @value.to_s
        else
          raise
        end
      end
    end
  end
end
