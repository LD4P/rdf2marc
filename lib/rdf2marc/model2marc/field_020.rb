module Rdf2marc
  module Model2marc
    class Field020 < Field
      def initialize(marc_record, model)
        super(marc_record, model, '020')
      end

      def build
        append('a', model.isbn)
        append_repeatable('q', model.qualifying_infos)
        append_repeatable('z', model.cancelled_isbns)
      end
    end
  end
end