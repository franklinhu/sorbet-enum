# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'tapioca'

module Tapioca
  module Compilers
    class SorbetEnum < Tapioca::Dsl::Compiler
      extend T::Sig

      ConstantType = type_member {{ fixed: T.class_of(SorbetEnum) }}

      sig { override.returns(T::Enumerable[Module]) }
      def self.gather_constants
        all_classes.select { |c| c < ::SorbetEnum }
      end

      sig { override.void }
      def decorate
        root.create_path(constant) do |klass|
          constant.sorbet_enum_attributes.each do |attr_name, attr_type|
            klass.create_method("#{attr_name}_enum", return_type: attr_type.class.name)
            klass.create_method(
              "#{attr_name}_enum=",
              parameters: [ create_param("value", type: attr_type.class.name) ],
              return_type: "void",
            )
          end
        end
      end
    end
  end
end
