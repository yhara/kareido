module Kareido
  class Ast
    class Node
      extend Props

      @@reg = 0
      def newreg
        return (@@reg += 1)
      end
    end

    class Program < Node
      props :defs, :main

      def init
        @funcs = defs.select{|x| x.is_a?(Defun)}
          .map{|x| [x.name, x]}
          .to_h
        @externs = defs.select{|x| x.is_a?(Extern)}
          .map{|x| [x.name, x]}
          .to_h
      end
      attr_reader :externs

      def to_ll
        lines = defs.flat_map{|x| x.to_ll(self)} +
                main.to_ll(self)
        return lines.join("\n") + "\n"
      end
    end

    class Main < Node
      props :stmts

      def to_ll(prog)
        [
          "define i32 @main() {",
          *stmts.map{|x| x.to_ll(prog)},
          "  ret i32 0",
          "}",
        ]
      end
    end

    class Defun < Node
      props :name, :param_names, :stmts
    end

    class Extern < Node
      props :ret_type, :name, :param_types

      def to_ll(prog)
        [
           "declare #{@ret_type} @#{@name}(#{@param_types.join ','})"
        ]
      end
    end

    class If < Node
      props :cond_expr, :then_stmts, :else_stmts
    end

    class For < Node
      props :varname, :nbegin, :nend, :step
    end

    class ExprStmt < Node
      props :expr

      def to_ll(prog)
        ll, r = @expr.to_ll_r(prog)
        return ll
      end
    end

    class BinExpr < Node
      props :op, :left, :right
    end

    class UnaryExpr < Node
      props :op, :expr
    end

    class FunCall < Node
      props :name, :args

      def to_ll_r(prog)
        unless (target = prog.externs[@name] || prog.funcs[@name])
          raise "Unkown function: #{@name}"
        end
        unless target.param_types.length == @args.length
          raise "Invalid number of arguments (#{@name})"
        end

        converted = @args.map{|x| x.to_ll_r(prog)}
        args_ll = converted.flat_map(&:first)
        arg_regs = converted.map(&:last)
        args_and_types = target.param_types.zip(arg_regs)
          .map{|ty, r| "#{ty} %reg#{r}"}.join(", ")

        r = newreg
        ll = args_ll + [
          "%reg#{r} = call #{target.ret_type} @#{name}(#{args_and_types})"
        ]
        return ll, r
      end
    end

    class VarRef < Node
      props :name
    end

    class Literal < Node
      props :value

      def to_ll_r(prog)
        case @value
        when Numeric
          r = newreg
          return ["%reg#{r} = add i32 0, #{@value}"],
                 r
        else
          raise
        end
      end
    end
  end
end
