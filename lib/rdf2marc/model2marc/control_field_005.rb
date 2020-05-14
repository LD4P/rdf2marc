module Rdf2marc
  module Model2marc
    class ControlField005 < ControlField
      def initialize(marc_record, model)
        super(marc_record, model, '005')
      end

      def value
        return nil if model.latest_transaction.nil?
        model.latest_transaction.strftime("%Y%m%d%H%M%S.f")
      end
    end
  end
end