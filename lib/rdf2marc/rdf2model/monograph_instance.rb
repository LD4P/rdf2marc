# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    # Maps Monograph Instance to model.
    class MonographInstance
      RESOURCE_TEMPLATES = [
        'ld4p:RT:bf2:Monograph:Instance:Un-nested'
      ].freeze

      def initialize(graph, resource_uri)
        @graph = graph
        @resource_uri = resource_uri
        @resource_term = RDF::URI.new(resource_uri)
        @query = GraphQuery.new(graph)
      end

      def generate
        {
          number_and_code_fields: {
            lccn: lccn,
            isbns: isbns
          },
          title_fields: {
            translated_titles: translated_titles,
            title_statement: title_statement,
            variant_titles: variant_titles,
            former_titles: former_titles
          },
          physical_description_fields: {
            physical_descriptions: physical_descriptions
          },
          edition_imprint_fields: {
            editions: editions
          }
        }
      end

      private

      attr_reader :graph, :sparql, :resource_uri, :query, :resource_term

      def title_statement
        # Record may contain multiple bf:Title. Only using one and which is selected is indeterminate.
        title_term = query.path_first([[BF.title, BF.Title]], subject_term: resource_term)
        return nil if title_term.nil?

        {
          title: query.path_first_literal([BF.mainTitle], subject_term: title_term),
          remainder_of_title: query.path_first_literal([BF.subtitle], subject_term: title_term),
          part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term),
          part_names: query.path_all_literal([BF.partName], subject_term: title_term)
        }
      end

      def variant_titles
        # VariantTitle and ParallelTitle
        variant_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term) || []
        # Filter variant titles where variantType='translated' or 'former'
        variant_title_terms.delete_if do |title_term|
          %w[translated former].include?(query.path_first_literal([BF.variantType], subject_term: title_term))
        end

        parallel_title_terms = query.path_all([[BF.title, BF.ParallelTitle]], subject_term: resource_term) || []
        title_terms = variant_title_terms + parallel_title_terms
        return nil if title_terms.empty?

        title_terms.map do |title_term|
          {
            type: variant_title_type(title_term, parallel_title_terms.include?(title_term)),
            title: query.path_first_literal([BF.mainTitle], subject_term: title_term),
            part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term),
            part_names: query.path_all_literal([BF.partName], subject_term: title_term)
          }
        end
      end

      def variant_title_type(title_term, is_parallel)
        return 'parallel' if is_parallel

        variant_type = query.path_first_literal([BF.variantType], subject_term: title_term)
        return variant_type if Rdf2marc::Models::TitleField::VariantTitle::TYPES.include?(variant_type)

        'none'
      end

      def former_titles
        # VariantTitles where variantType='former'
        former_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term) || []
        former_title_terms.keep_if do |title_term|
          query.path_first_literal([BF.variantType], subject_term: title_term) == 'former'
        end

        return nil if former_title_terms.empty?

        former_title_terms.map do |title_term|
          {
            title: query.path_first_literal([BF.mainTitle], subject_term: title_term),
            part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term),
            part_names: query.path_all_literal([BF.partName], subject_term: title_term)
          }
        end
      end

      def translated_titles
        # VariantTitles where variantType='translated'
        translated_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term) || []
        translated_title_terms.keep_if do |title_term|
          query.path_first_literal([BF.variantType], subject_term: title_term) == 'translated'
        end

        return nil if translated_title_terms.empty?

        translated_title_terms.map do |title_term|
          {
            title: query.path_first_literal([BF.mainTitle], subject_term: title_term),
            part_numbers: query.path_all_literal([BF.partNumber], subject_term: title_term),
            part_names: query.path_all_literal([BF.partName], subject_term: title_term)
          }
        end
      end

      def lccn
        # Can be multiple non-cancelled LCCNs. However, only using one.
        lccn = {
          cancelled_lccns: []
        }
        id_terms = query.path_all([[BF.identifiedBy, BF.Lccn]], subject_term: resource_term)
        return if id_terms.nil?

        id_terms.each do |id_term|
          lccn_value = query.path_first_literal([RDF::RDFV.value], subject_term: id_term)
          next if lccn_value.nil?

          is_cancelled = query.path_first([BF.status], subject_term: id_term) == LC_VOCAB['mstatus/cancinv']
          if is_cancelled
            lccn[:cancelled_lccns] << lccn_value
          else
            lccn[:lccn] = lccn_value
          end
        end
        lccn
      end

      def isbns
        id_terms = query.path_all([[BF.identifiedBy, BF.Isbn]], subject_term: resource_term)
        return if id_terms.nil?

        # Cancelled ISBNs should probably be associated with an ISBN. However, RDF model does not support.
        id_terms.map do |id_term|
          isbn_value = query.path_first_literal([RDF::RDFV.value], subject_term: id_term)
          next if isbn_value.nil?

          is_cancelled = query.path_first([BF.status], subject_term: id_term) == LC_VOCAB['mstatus/cancinv']
          isbn = {}
          if is_cancelled
            isbn[:cancelled_isbns] = [isbn_value]
          else
            isbn[:isbn] = isbn_value
          end
          qualifier_values = query.path_all_literal([BF.qualifier], subject_term: id_term)
          isbn[:qualifying_infos] = qualifier_values if qualifier_values
          isbn
        end.compact
      end

      def editions
        edition_statements = query.path_all_literal([BF.editionStatement], subject_term: resource_term)
        return if edition_statements.nil?

        edition_statements.map { |edition_statement| { edition: edition_statement } }
      end

      def physical_descriptions
        extent_terms = (query.path_all([[BF.extent, BF.Extent]], subject_term: resource_term) || [])
        extent_physical_description = extent_terms.map do |extent_term|
          {
            extents: query.path_all_literal([RDF::RDFS.label], subject_term: extent_term),
            # Can be multiple notes, but only using one.
            materials_specified: query.path_first_literal([[BF.note, BF.Note],
                                                           RDF::RDFS.label], subject_term: extent_term)
          }
        end
        dimensions = {
          dimensions: query.path_all_literal([BF.dimensions], subject_term: resource_term)
        }
        extent_physical_description + [dimensions]
      end
    end
  end
end
