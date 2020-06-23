# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Title Fields model.
      class TitleFields < BaseMapper
        def generate
          {
            translated_titles: translated_titles,
            title_statement: title_statement,
            variant_titles: variant_titles,
            former_titles: former_titles
          }
        end

        private

        def translated_titles
          # VariantTitles where variantType='translated'
          translated_title_terms = item.instance.query.path_all([[BF.title, BF.VariantTitle]])
          translated_title_terms.keep_if do |title_term|
            item.instance.query.path_first_literal([BF.variantType], subject_term: title_term) == 'translated'
          end

          translated_title_terms.map do |title_term|
            {
              title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
              part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term),
              part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term)
            }
          end
        end

        def title_statement
          # Record may contain multiple bf:Title. Only using one and which is selected is indeterminate.
          title_term = item.instance.query.path_first([[BF.title, BF.Title]])
          return nil if title_term.nil?

          {
            title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
            remainder_of_title: item.instance.query.path_first_literal([BF.subtitle], subject_term: title_term),
            part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term),
            part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term)
          }
        end

        def variant_titles
          # VariantTitle and ParallelTitle
          variant_title_terms = item.instance.query.path_all([[BF.title, BF.VariantTitle]])
          # Filter variant titles where variantType='translated' or 'former'
          variant_title_terms.delete_if do |title_term|
            %w[translated former].include?(item.instance.query.path_first_literal([BF.variantType],
                                                                                  subject_term: title_term))
          end

          parallel_title_terms = item.instance.query.path_all([[BF.title, BF.ParallelTitle]])
          title_terms = variant_title_terms + parallel_title_terms

          title_terms.map do |title_term|
            {
              type: variant_title_type(title_term, parallel_title_terms.include?(title_term)),
              title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
              part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term),
              part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term)
            }
          end
        end

        def variant_title_type(title_term, is_parallel)
          return 'parallel' if is_parallel

          variant_type = item.instance.query.path_first_literal([BF.variantType], subject_term: title_term)
          return variant_type if Rdf2marc::Models::TitleField::VariantTitle::TYPES.include?(variant_type)

          'none'
        end

        def former_titles
          # VariantTitles where variantType='former'
          former_title_terms = item.instance.query.path_all([[BF.title, BF.VariantTitle]])
          former_title_terms.keep_if do |title_term|
            item.instance.query.path_first_literal([BF.variantType], subject_term: title_term) == 'former'
          end

          former_title_terms.map do |title_term|
            {
              title: item.instance.query.path_first_literal([BF.mainTitle], subject_term: title_term),
              part_numbers: item.instance.query.path_all_literal([BF.partNumber], subject_term: title_term),
              part_names: item.instance.query.path_all_literal([BF.partName], subject_term: title_term)
            }
          end
        end
      end
    end
  end
end
