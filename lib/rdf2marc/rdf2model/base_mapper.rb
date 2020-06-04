# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    # Base class for Mappers.
    class BaseMapper
      def initialize(item_context)
        @item = item_context
      end

      protected

      attr_reader :item
    end
  end
end
