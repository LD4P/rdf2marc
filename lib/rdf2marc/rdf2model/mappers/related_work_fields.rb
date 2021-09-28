# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to related work model.
      class RelatedWorkFields < BaseMapper
        def generate
          {
            title: title,
            uri: uri.to_s
          }
        end

        private

        def title
          item.instance.query.path_first_literal([[BF.title, BF.Title], BF.mainTitle], subject_term: uri)
        end

        def uri
          item.work.term
        end
      end
    end
  end
end
