# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps model to Leader.
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
        marc_record.leader[8] = 'a' if model.archival
        marc_record.leader[9] = 'a'
        marc_record.leader[17] = encoding_level
        marc_record.leader[18] = cataloging_form
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

      def encoding_level
        case model.encoding_level
        when 'full'
          ' '
        when 'full_not_examined'
          '1'
        when 'less_full_not_examined'
          '2'
        when 'abbreviated'
          '3'
        when 'core'
          '4'
        when 'partial'
          '5'
        when 'minimum'
          '7'
        when 'prepublication'
          '8'
        when 'unknown'
          'u'
        when 'not_applicable'
          'z'
        else
          raise 'unexpected encoding level'
        end
      end

      def cataloging_form
        case model.cataloging_form
        when 'non_isbd'
          ' '
        when 'aacr2'
          'a'
        when 'isbd_no_punctuation'
          'c'
        when 'isbd'
          'i'
        when 'non_isbd_no_punctuation'
          'n'
        when 'unknown'
          'u'
        else
          raise 'unexpected cataloging form'
        end
      end
    end
  end
end
