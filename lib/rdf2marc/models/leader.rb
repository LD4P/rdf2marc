# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for Leader.
    class Leader < Struct
      TYPES = %w[language_material notated_music manuscript_notated_music cartographic manuscript_cartographic
                 projected_medium nonmusical_sound_recording musical_sound_recording 2d_nonprojectable_graphic
                 computer_file kit mixed_materials 3d manuscript].freeze
      BIBLIOGRAPHIC_LEVELS = %w[monographic_component serial_component collection subunit
                                integrating_resource item serial].freeze
      ENCODING_LEVELS = %w[full full_not_examined less_full_not_examined abbreviated core partial
                           minimum prepublication unknown not_applicable].freeze
      CATALOGING_FORMS = %w[non_isbd aacr2 isbd_no_punctuation isbd non_isbd_no_punctuation unknown].freeze
      attribute :record_status, Types::String.default('n').enum('a', 'c', 'd', 'n', 'p')
      # Not clear where to map this from.
      attribute :type, Types::String.default('language_material').enum(*TYPES)
      attribute :bibliographic_level, Types::String.default('item').enum(*BIBLIOGRAPHIC_LEVELS)
      attribute :archival, Types::Bool.default(false)
      attribute :encoding_level, Types::String.default('unknown').enum(*ENCODING_LEVELS)
      attribute :cataloging_form, Types::String.default('unknown').enum(*CATALOGING_FORMS)
    end
  end
end
