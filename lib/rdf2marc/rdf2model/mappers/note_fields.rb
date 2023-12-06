# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Note Fields model.
      class NoteFields < BaseMapper
        def generate
          notes = general_notes
          notes << provision_activity_statement if provision_activity_statement
          {
            general_notes: notes,
            table_of_contents:
          }
        end

        private

        def table_of_contents
          item.work.query.path_all_literal([[BF.tableOfContents, BF.TableOfContents], RDF::RDFS.label])
        end

        def general_notes
          notes = item.instance.query.path_all_literal([[BF.note, BF.Note], RDF::RDFS.label]) +
                  item.work.query.path_all_literal([[BF.note, BF.Note], RDF::RDFS.label])
          notes.sort.map do |note|
            {
              general_note: note
            }
          end
        end

        def provision_activity_statement
          value = item.instance.query.path_first_literal([BF.provisionActivityStatement])
          return unless value.present?

          {
            general_note: "Transcribed publication statement: #{value}"
          }
        end
      end
    end
  end
end
