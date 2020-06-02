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
          control_fields: {
            general_info: {
              place: place
            }
          },
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
            physical_descriptions: physical_descriptions,
            media_types: media_types,
            carrier_types: carrier_types
          },
          note_fields: {
            instance_general_notes: general_notes
          },
          edition_imprint_fields: {
            editions: editions,
            publication_distributions: publication_distributions
          }
        }
      end

      private

      attr_reader :graph, :sparql, :resource_uri, :query, :resource_term

      def place
        place_uri = query.path_first_uri([[BF.provisionActivity, BF.Publication], BF.place],
                                         subject_term: resource_term)

        gac = Resolver.resolve_geographic_area_code(place_uri)
        # For example, an-cn-on
        return nil if gac.nil?

        gac.split('-')[1]
      end

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
        variant_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term)
        # Filter variant titles where variantType='translated' or 'former'
        variant_title_terms.delete_if do |title_term|
          %w[translated former].include?(query.path_first_literal([BF.variantType], subject_term: title_term))
        end

        parallel_title_terms = query.path_all([[BF.title, BF.ParallelTitle]], subject_term: resource_term)
        title_terms = variant_title_terms + parallel_title_terms

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
        former_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term)
        former_title_terms.keep_if do |title_term|
          query.path_first_literal([BF.variantType], subject_term: title_term) == 'former'
        end

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
        translated_title_terms = query.path_all([[BF.title, BF.VariantTitle]], subject_term: resource_term)
        translated_title_terms.keep_if do |title_term|
          query.path_first_literal([BF.variantType], subject_term: title_term) == 'translated'
        end

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

        edition_statements.map { |edition_statement| { edition: edition_statement } }
      end

      def physical_descriptions
        extent_terms = query.path_all([[BF.extent, BF.Extent]], subject_term: resource_term)
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

      def publication_distributions
        pub_dist_terms = query.path_all([[BF.provisionActivity, BF.Publication]], subject_term: resource_term)
        pub_dists = pub_dist_terms.map do |pub_dist_term|
          {
            publication_distribution_places: publication_distributions_places(pub_dist_term),
            publisher_distributor_names: publication_distributions_names(pub_dist_term),
            publication_distribution_dates: query.path_all_literal([BF.date], subject_term: pub_dist_term)
          }
        end
        manufacture_terms = query.path_all([[BF.provisionActivity, BF.Distribution]], subject_term: resource_term)
        manufactures = manufacture_terms.map do |manufacture_term|
          {
            manufacture_places: publication_distributions_places(manufacture_term),
            manufacturer_names: publication_distributions_names(manufacture_term),
            manufacture_dates: query.path_all_literal([BF.date], subject_term: manufacture_term)
          }
        end
        pub_dists + manufactures
      end

      def publication_distributions_places(subject_term)
        query.path_all_uri([BF.place], subject_term: subject_term).map { |place_uri| Resolver.resolve_label(place_uri) }
      end

      def publication_distributions_names(subject_term)
        query.path_all_uri([[BF.agent, BF.Agent], BF.Agent], subject_term: subject_term).map do |agent_uri|
          Resolver.resolve_label(agent_uri)
        end
      end

      def media_types
        media_type_terms = query.path_all([BF.media], subject_term: resource_term)
        media_type_terms.map do |media_type_term|
          {
            media_type_terms: [query.path_first_literal([RDF::RDFS.label], subject_term: media_type_term)],
            media_type_codes: [media_type_term.value.delete_prefix('http://id.loc.gov/vocabulary/mediaTypes/')],
            authority_control_number_uri: media_type_term.value
          }
        end
      end

      def carrier_types
        carrier_type_terms = query.path_all([BF.carrier], subject_term: resource_term)
        carrier_type_terms.map do |carrier_type_term|
          {
            carrier_type_terms: [query.path_first_literal([RDF::RDFS.label], subject_term: carrier_type_term)],
            carrier_type_codes: [carrier_type_term.value.delete_prefix('http://id.loc.gov/vocabulary/carriers/')],
            authority_control_number_uri: carrier_type_term.value
          }
        end
      end

      def general_notes
        query.path_all_literal([[BF.note, BF.Note], RDF::RDFS.label], subject_term: resource_term).map do |note|
          {
            general_note: note
          }
        end
      end
    end
  end
end
