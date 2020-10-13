# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Leader model.
      class Leader < BaseMapper
        def generate
          {
            record_status: item.admin_metadata.query.path_first_literal([[BF.status, BF.Status], BF.code]),
            type: type,
            bibliographic_level: bibliographic_level,
            encoding_level: encoding_level,
            cataloging_form: cataloging_form
          }
        end

        private

        def type
          # Mapping from instance resource template id
          resource_template_id = item.instance.query.path_first_literal([SINOPIA.hasResourceTemplate])
          case resource_template_id&.downcase
          when /cartographic/
            'cartographic'
          when /35mmfeaturefilm/
            'projected_medium'
          when /notatedmusic/
            'notated_music'
          when /analog/, /soundrecording/, /soundcdr/
            'nonmusical_sound_recording'
          when /printphoto/
            '2d_nonprojectable_graphic'
          else
            'language_material'
          end
        end

        def bibliographic_level
          # Record may contain multiple. Only using one and which is selected is indeterminate.
          case item.instance.query.path_first([BF.issuance])
          when LC_VOCAB['issuance/intg']
            'integrating_resource'
          when LC_VOCAB['issuance/serl']
            'serial'
          else
            'item'
          end
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
