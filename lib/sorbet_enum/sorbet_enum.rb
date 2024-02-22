# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

module SorbetEnum
  extend T::Helpers
  interface!

  module ClassMethods
    extend T::Sig
    extend T::Helpers
    abstract!

    include ActiveRecord::Enum

    sig {params(name: Symbol, type: T.class_of(T::Enum)).void}
    def sorbet_enum(name, type)
      enum(name, type.values.map(&:serialize).index_with(&:to_s))

      T.unsafe(self).define_method("#{name}_enum") do
        type.deserialize(T.unsafe(self).public_send(name))
      end
    end
  end

  mixes_in_class_methods(ClassMethods)
end

