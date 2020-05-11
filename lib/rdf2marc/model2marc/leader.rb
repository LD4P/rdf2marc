module Rdf2marc
  module Model2marc
    class Leader
      def initialize(marc_record, model)
        @marc_record = marc_record
        @model = model
      end

      def generate
        return if model.nil?

        marc_record.leader[5] = model.record_status
        marc_record.leader[6] = type_of_record
        marc_record.leader[7] = bibliographic_level
      end

      private

      attr_reader :marc_record, :model

      def type_of_record
        case model.type
        when 'language_material'
          'a'
        when 'notated_music'
          'c'
        when 'manuscript_notated_music'
          'd'
        when 'cartographic'
          'e'
        when 'projected_medium'
          'g'
        when 'nonmusical_sound_recording'
          'i'
        when 'musical_sound_recording'
          'j'
        when '2d_nonprojectable_graphic'
          'k'
        when 'computer_file'
          'm'
        when 'kit'
          'o'
        when 'mixed_materials'
          'p'
        when '3d'
          'r'
        when 'manuscript'
          't'
        else
          raise 'unexpected type of record'
        end
      end

      def bibliographic_level
        case model.bibliographic_level
        when 'monographic_component'
          'a'
        when 'serial_component'
          'b'
        when 'collection'
          'c'
        when 'subunit'
          'd'
        when 'integrating_resource'
          'i'
        when 'item'
          'm'
        when 'serial'
          's'
        else
          raise 'unexpected bibliographic level'
        end
      end

    end
  end
end