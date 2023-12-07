# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Leader model.
      class Leader < BaseMapper
        def generate
          {
            type:,
            bibliographic_level:,
            encoding_level:,
            cataloging_form:
          }
        end

        private

        def type
          type = type_map.find do |type_map_entry|
            type_map_types = Array(type_map_entry.first)
            (type_map_types - work_types).empty?
          end&.last
          type || 'language_material'
        end

        def work_types
          @work_types ||= item.work.query.path_all_uri([RDF.type])
        end

        def type_map
          @type_map ||= [
            [[BF.Text.value, BF.Manuscript.value], 'manuscript'],
            [BF.Text.value, 'language_material'],
            [[BF.NotatedMusic.value, BF.Manuscript.value], 'manuscript_notated_music'],
            [BF.NotatedMusic.value, 'notated_music'],
            [[BF.Cartography.value, BF.Manuscript.value], 'cartographic'],
            [BF.Cartography.value, 'cartographic'],
            [BF.MovingImage.value, 'projected_medium'],
            [BF.NonMusicAudio.value, 'nonmusical_sound_recording'],
            [BF.MusicAudio.value, 'musical_sound_recording'],
            [BF.StillImage.value, '2d_nonprojectable_graphic'],
            [BF.Multimedia.value, 'computer_file'],
            [BF.MixedMaterial.value, 'mixed_materials'],
            [BF.Object.value, '3d']
          ]
        end

        def bibliographic_level
          first_level = work_types.map { |work_type| bibliographic_level_map[work_type] }.compact.first
          first_level || 'monographic_component'
        end

        def bibliographic_level_map
          @bibliographic_level_map ||= {
            BF.Collection.value => 'collection',
            BF.Integrating.value => 'integrating_resource',
            BF.Serial.value => 'serial',
            BF.Monograph.value => 'monographic_component'
          }
        end

        def encoding_level
          encoding_level_term = item.admin_metadata.query.path_first([BFLC.encodingLevel])
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
          description_convention_term = item.admin_metadata.query.path_first([BF.descriptionConventions])
          case description_convention_term
          when LC_VOCAB['descriptionConventions/aacr']
            'aacr2'
          when LC_VOCAB['descriptionConventions/isbd']
            'isbd'
          end
        end
      end
    end
  end
end
