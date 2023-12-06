# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Title Fields model.
      class TitleFields < BaseMapper
        def initialize(item_context, has_100_field:)
          super(item_context)
          @has_100_field = has_100_field
        end

        def generate
          {
            translated_titles:,
            title_statement: title_statement(@has_100_field),
            variant_titles:,
            former_titles:
          }
        end

        private

        def translated_titles
          translated_title_terms = item.instance.query.path_all([[BF.title, BFLC.TransliteratedTitle]])
          translated_title_terms.sort.map do |title_term|
            {
              title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
              remainder_of_title: item.instance.query.path_first_literal([BF.subtitle], subject_term: title_term),
              part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term).sort,
              part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term).sort
            }
          end
        end

        def title_statement(has_100_field)
          # Record may contain multiple bf:Title. Only using one and which is selected is indeterminate.
          title_term = item.instance.query.path_first([[BF.title, BF.Title]])
          return nil if title_term.nil?

          {
            added_entry: has_100_field ? 'added' : 'no_added',
            nonfile_characters: item.instance.query.path_first_literal([SINOPIA['bf/nonfiling']],
                                                                       subject_term: title_term)&.to_i,
            title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
            remainder_of_title: item.instance.query.path_first_literal([BF.subtitle], subject_term: title_term),
            # May be multiple bf.responsibilityStatement, but only using one.
            statement_of_responsibility: item.instance.query.path_first_literal([BF.responsibilityStatement]),
            part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term).sort,
            part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term).sort
          }
        end

        def variant_titles
          # VariantTitle and ParallelTitle
          variant_title_terms = item.instance.query.path_all([[BF.title, BF.VariantTitle]])
          # Filter variant titles where variantType='former'
          variant_title_terms.delete_if do |title_term|
            variant_types = item.instance.query.path_all_literal([BF.variantType],
                                                                 subject_term: title_term)
            variant_types.include?('former')
          end

          parallel_title_terms = item.instance.query.path_all([[BF.title, BF.ParallelTitle]])
          title_terms = variant_title_terms + parallel_title_terms

          title_terms.sort.map do |title_term|
            type = variant_title_type(title_term, parallel_title_terms.include?(title_term))
            {
              note_added_entry: note_added_entry(type),
              type:,
              title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
              part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term).sort,
              part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term).sort
            }
          end
        end

        def variant_title_type(title_term, is_parallel)
          return 'parallel' if is_parallel

          variant_type = item.instance.query.path_first_literal([BF.variantType], subject_term: title_term)
          return variant_type if Rdf2marc::Models::TitleField::VariantTitle::TYPES.include?(variant_type)

          'none'
        end

        def note_added_entry(type)
          case type
          when 'none'
            'note_no_added'
          when 'parallel'
            'no_note_added'
          else
            'note_added'
          end
        end

        def former_titles
          # VariantTitles where variantType='former'
          former_title_terms = item.instance.query.path_all([[BF.title, BF.VariantTitle]])
          former_title_terms.keep_if do |title_term|
            item.instance.query.path_all_literal([BF.variantType], subject_term: title_term).include?('former')
          end

          former_title_terms.sort.map do |title_term|
            {
              title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
              part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term).sort,
              part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term).sort
            }
          end
        end
      end
    end
  end
end
