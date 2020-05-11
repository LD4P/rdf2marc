# frozen_string_literal: true

module Rdf2marc
  module Models
    class Leader < Struct
      TYPES = ['language_material', 'notated_music', 'manuscript_notated_music', 'cartographic', 'projected_medium', 'nonmusical_sound_recording', 'musical_sound_recording', '2d_nonprojectable_graphic', 'computer_file', 'kit', 'mixed_materials', '3d', 'manuscript']
      BIBLIOGRAPHIC_LEVELS = ['monographic_component', 'serial_component', 'collection', 'subunit', 'integrating_resource', 'item', 'serial']
      attribute :record_status, Types::String.default('n').enum('a', 'c', 'd', 'n', 'p')
      # Not clear where to map this from.
      attribute :type, Types::String.default('language_material').enum(*TYPES)
      attribute :bibliographic_level, Types::String.default('item').enum(*BIBLIOGRAPHIC_LEVELS)
    end
  end
end
