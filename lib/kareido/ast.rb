module Kareido
  class Ast
    class Node
      extend Props

      # For testing
      def self.reset_regnum
        @@reg = 0
      end
      reset_regnum

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
        Node.reset_regnum

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

    BINOPS = {
      "+" => "fadd",
      "-" => "fsub",
      "*" => "fmul",
      "/" => "fdiv",
      "%" => "frem",
    }
    # TODO: > < >= <= == != && ||
    class BinExpr < Node
      props :op, :left_expr, :right_expr

      def to_ll_r(prog)
        ll1, r1 = @left_expr.to_ll_r(prog)
        ll2, r2 = @right_expr.to_ll_r(prog)
        ope = BINOPS[@op] or raise "op #{@op} not implemented yet"

        ll = ll1 + ll2
        r3 = newreg
        ll << "  %reg#{r3} = #{ope} double %reg#{r1}, %reg#{r2}"
        return ll, r3
      end
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

        ll = []
        args_and_types = []
        @args.map{|x| x.to_ll_r(prog)}.each.with_index do |(arg_ll, arg_r), i|
          type = target.param_types[i]
          ll.concat(arg_ll)
          case type
          when "i32"
            rr = newreg
            ll << "  %reg#{rr} = fptosi double %reg#{arg_r} to i32"
            args_and_types << "i32 %reg#{rr}"
          when "double"
            args_and_types << "double %reg#{arg_r}"
          else
            raise "type #{type} is not supported"
          end
        end

        r = newreg
        ll << "  %reg#{r} = call #{target.ret_type} @#{name}(#{args_and_types.join(', ')})"
        case target.ret_type
        when "i32"
          rr = newreg
          ll << "  %reg#{rr} = sitofp i32 %reg#{r} to double"
          return ll, rr
        when "double"
          return ll, r
        else
          raise "type #{type} is not supported"
        end
      end
    end

    class VarRef < Node
      props :name
    end

    class Literal < Node
      props :value

      def to_ll_r(prog)
        case @value
        when Float
          r = newreg
          return ["  %reg#{r} = add double 0.0, #{@value}"], r
        when Integer
          r = newreg
          return ["  %reg#{r} = add double 0.0, #{@value}.0"], r
        else
          raise
        end
      end
    end
  end
end
