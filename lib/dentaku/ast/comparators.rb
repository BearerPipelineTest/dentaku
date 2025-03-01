require_relative './operation'

module Dentaku
  module AST
    class Comparator < Operation
      def self.precedence
        5
      end

      def type
        :logical
      end

      def operator
        raise NotImplementedError
      end

      def value(context = {})
        l = validate_value(left.value(context))
        r = validate_value(right.value(context))

        l.public_send(operator, r)
      rescue ::ArgumentError => e
        raise Dentaku::ArgumentError.for(:incompatible_type, value: r, for: l.class), e.message
      end

      private

      def validate_value(value)
        unless value.respond_to?(operator)
          raise Dentaku::ArgumentError.for(:invalid_operator, operation: self.class, operator: operator),
                "#{ self.class } requires operands that respond to #{operator}"
        end

        value
      end
    end

    class LessThan < Comparator
      def operator
        :<
      end
    end

    class LessThanOrEqual < Comparator
      def operator
        :<=
      end
    end

    class GreaterThan < Comparator
      def operator
        :>
      end
    end

    class GreaterThanOrEqual < Comparator
      def operator
        :>=
      end
    end

    class NotEqual < Comparator
      def operator
        :!=
      end
    end

    class Equal < Comparator
      def operator
        :==
      end

      def display_operator
        "="
      end
    end
  end
end
