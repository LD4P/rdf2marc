module Rdf2marc
  module Rdf2model
    class BaseMapper
      def initialize(item_context)
        @item = item_context
      end

      protected

      attr_reader :item

    end
  end
end