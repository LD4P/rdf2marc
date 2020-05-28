# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    # Maps AdminMetadata BFDB to model.
    class AdminMetadataBfdb
      RESOURCE_TEMPLATES = [
        'ld4p:RT:bf2:AdminMetadata:BFDB'
      ].freeze

      def initialize(graph, resource_uri)
        @graph = graph
        @resource_uri = resource_uri
        @resource_term = RDF::URI.new(resource_uri)
        @query = GraphQuery.new(graph)
      end

      def generate
        {
          leader: leader,
          control_fields: {
            control_number: control_number,
            control_number_id: control_number_id,
            latest_transaction: latest_transaction,
            general_info: general_info
          }
        }
      end

      private

      attr_reader :graph, :query, :resource_uri, :resource_term

      def leader
        {
          record_status: query.path_first_literal([[BF.status, BF.Status],
                                                   BF.code], subject_term: resource_term),
          bibliographic_level: bibliographic_level,
          encoding_level: encoding_level,
          cataloging_form: cataloging_form
        }
      end

      def bibliographic_level
        # Record may contain multiple. Only using one and which is selected is indeterminate.
        case query.path_first([BF.issuance], subject_term: resource_term)
        when LC_VOCAB['issuance/intg']
          'integrating_resource'
        when LC_VOCAB['issuance/seri']
          'serial'
        else
          'item'
        end
      end

      def encoding_level
        encoding_level_term = query.path_first([BFLC.encodingLevel], subject_term: resource_term)
        case encoding_level_term
        when LC_VOCAB['menclvl/3']
          'abbreviated'
        when LC_VOCAB['menclvl/4']
          'core'
        when LC_VOCAB['menclvl/f']
          'full'
        when LC_VOCAB['menclvl/1']
          'full_not_examined'
        when LC_VOCAB['menclvl/7']
          'minimum'
        when LC_VOCAB['menclvl/5']
          'partial'
        when LC_VOCAB['menclvl/8']
          'prepublication'
        end
      end

      def cataloging_form
        # Can be more than one, but only using first.
        description_convention_term = query.path_first([BF.descriptionConventions], subject_term: resource_term)
        case description_convention_term
        when LC_VOCAB['descriptionConventions/aacr']
          'aacr2'
        when LC_VOCAB['descriptionConventions/isbd']
          'isbd'
        end
      end

      def control_number
        query.path_first_literal([[BF.identifiedBy, BF.Local], [RDF::RDFV.value]], subject_term: resource_term)
      end

      def control_number_id
        # Can be multiple but only using first.
        source_uri = query.path_first_uri([BF.source], subject_term: resource_term)
        return nil if source_uri.nil?

        source_uri.delete_prefix('http://id.loc.gov/vocabulary/organizations/')
      end

      def latest_transaction
        date_literal = query.path_first_literal([BF.changeDate], subject_term: resource_term)
        return nil if date_literal.nil?

        DateTime.iso8601(date_literal)
      end

      def general_info
        {
          date_entered: date_entered,
          date1: query.path_first_literal([[BF.provisionActivity, BF.Publication],
                                           [BF.date]], subject_term: resource_term)
        }
      end

      def date_entered
        date_literal = query.path_first_literal([BF.creationDate], subject_term: resource_term)
        return nil if date_literal.nil?

        DateTime.iso8601(date_literal)
      end
    end
  end
end
