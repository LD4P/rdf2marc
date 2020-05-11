module Rdf2marc
  module Rdf2model
    class MonographInstance
      RESOURCE_TEMPLATES = [
          'ld4p:RT:bf2:Monograph:Instance:Un-nested'
      ]

      def initialize(graph, resource_uri)
        @graph = graph
        @resource_uri = resource_uri
        @resource_term = RDF::URI.new(resource_uri)
        @query = GraphQuery.new(graph)
      end

      def generate
        {
            leader: leader,
            translated_titles: translated_titles,
            title_statement: title_statement,
            variant_titles: variant_titles,
            former_titles: former_titles
        }
      end

      private

      attr_reader :graph, :sparql, :resource_uri, :query, :resource_term

      def leader
        # Record may contain multiple bf:AdminMetadata. Only using one and which is selected is indeterminate.
        admin_metadata_term = query.path_first([[BF.adminMetadata, BF.AdminMetadata]], subject_term: resource_term)
        return nil if admin_metadata_term.nil?
        {
            record_status: query.path_first_literal([[BF.status, BF.Status], BF.code], subject_term: admin_metadata_term),
            bibliographic_level: bibliographic_level
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

      def title_statement
        # Record may contain multiple bf:Title. Only using one and which is selected is indeterminate.
        title_term = query.path_first([[BF.title, BF.Title]], subject_term: resource_term)
        return nil if title_term.nil?
        {
            title: query.path_first_literal([BF.mainTitle], subject_term: title_term ),
            remainder_of_title: query.path_first_literal([BF.subtitle], subject_term: title_term ),
            part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term ),
            part_names: query.path_all_literal([BF.partName], subject_term: title_term )
        }
      end

      def variant_titles
        # VariantTitle and ParallelTitle
        variant_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term) || []
        # Filter variant titles where variantType='translated' or 'former'
        variant_title_terms.delete_if {|title_term| ['translated', 'former'].include?(query.path_first_literal([BF.variantType], subject_term: title_term)) }

        parallel_title_terms = query.path_all([[BF.title, BF.ParallelTitle]], subject_term: resource_term) || []
        title_terms = variant_title_terms + parallel_title_terms
        return nil if title_terms.empty?

        title_terms.map do |title_term|
          {
              type: variant_title_type(title_term, parallel_title_terms.include?(title_term)),
              title: query.path_first_literal([BF.mainTitle], subject_term: title_term ),
              part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term ),
              part_names: query.path_all_literal([BF.partName], subject_term: title_term )
          }
        end
      end

      def variant_title_type(title_term, is_parallel)
        return 'parallel' if is_parallel
        variant_type = query.path_first_literal([BF.variantType], subject_term: title_term )
        return variant_type if Rdf2marc::Models::VariantTitle::TYPES.include?(variant_type)
        'none'
      end

      def former_titles
        # VariantTitles where variantType='former'
        former_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term) || []
        former_title_terms.keep_if {|title_term| query.path_first_literal([BF.variantType], subject_term: title_term) == 'former' }

        return nil if former_title_terms.empty?

        former_title_terms.map do |title_term|
          {
              title: query.path_first_literal([BF.mainTitle], subject_term: title_term ),
              part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term ),
              part_names: query.path_all_literal([BF.partName], subject_term: title_term )
          }
        end
      end

      def translated_titles
        # VariantTitles where variantType='translated'
        translated_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term) || []
        translated_title_terms.keep_if {|title_term| query.path_first_literal([BF.variantType], subject_term: title_term) == 'translated' }

        return nil if translated_title_terms.empty?

        translated_title_terms.map do |title_term|
          {
              title: query.path_first_literal([BF.mainTitle], subject_term: title_term ),
              part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term ),
              part_names: query.path_all_literal([BF.partName], subject_term: title_term )
          }
        end
      end

    end
  end
end