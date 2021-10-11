# frozen_string_literal: true

module Rdf2marc
  module Model2marc
    # Maps thesaurus to indicator2 value for 6xx fields
    class Thesaurus
      def self.code_for(value)
        case value
        when 'lcsh'
          '0'
        when 'lcsh_childrens_literature'
          '1'
        when 'mesh'
          '2'
        when 'nal_subject_authority'
          '3'
        when 'canadian_subject_headings'
          '5'
        when 'répertoire_de_vedettes-matière'
          '6'
        when 'subfield2'
          '7'
        else
          '4'
        end
      end
    end
  end
end
