# frozen_string_literal: true

module Rdf2marc
  module Resolver
    # Resolver for id.loc.gov.
    class IdLocGovResolver
      def resolve_personal_name(uri)
        expect_type(uri, %w[personal_name family_name])
        marc_record = get_marc(uri)
        field = marc_record['100']
        {
          type: personal_name_type_for(field.indicator1),
          personal_name: subfield_value(field, 'a', clean: true),
          numeration: field['b'],
          title_and_words: subfield_values(field, 'c'),
          dates: field['d'],
          relator_terms: subfield_values(field, 'e'),
          work_date: field['f'],
          misc_infos: subfield_values(field, 'g'),
          medium: field['h'],
          attribution_qualifiers: subfield_values(field, 'j'),
          form_subheadings: subfield_values(field, 'k'),
          work_language: field['l'],
          music_performance_mediums: subfield_values(field, 'm'),
          part_numbers: subfield_values(field, 'n'),
          music_arranged_statment: field['o'],
          part_names: subfield_values(field, 'p'),
          fuller_form: field['q'],
          music_key: field['r'],
          versions: subfield_values(field, 's'),
          work_title: field['t'],
          # No affiliation: field['u'],
          form_subdivisions: subfield_values(field, 'v'),
          general_subdivisions: subfield_values(field, 'x'),
          chronological_subdivisions: subfield_values(field, 'y'),
          geographic_subdivisions: subfield_values(field, 'z'),
          authority_record_control_numbers: [uri],
          # No uri: field['1'],
          # No heading_source: field['2'],
          # No materials_specified: field['3'],
          # No relationships: subfield_values(field, '4'),
          linkage: field['6'],
          field_links: subfield_values(field, '8')
        }
      end

      def resolve_corporate_name(uri)
        expect_type(uri, ['corporate_name'])
        marc_record = get_marc(uri)
        field = marc_record['110']
        {
          type: name_type_for(field.indicator1),
          corporate_name: subfield_value(field, 'a', clean: true),
          subordinate_unit: field['b'],
          meeting_location: subfield_values(field, 'c'),
          meeting_date: field['d'],
          relator_terms: subfield_values(field, 'e'),
          work_date: field['f'],
          misc_infos: subfield_values(field, 'g'),
          medium: field['h'],
          form_subheadings: subfield_values(field, 'k'),
          work_language: field['l'],
          music_performance_mediums: subfield_values(field, 'm'),
          part_numbers: subfield_values(field, 'n'),
          music_arranged_statment: field['o'],
          part_names: subfield_values(field, 'p'),
          music_key: field['r'],
          versions: subfield_values(field, 's'),
          work_title: field['t'],
          # No affiliation: field['u'],
          form_subdivisions: subfield_values(field, 'v'),
          general_subdivisions: subfield_values(field, 'x'),
          chronological_subdivisions: subfield_values(field, 'y'),
          geographic_subdivisions: subfield_values(field, 'z'),
          authority_record_control_number: [uri],
          # No uri: field['1'],
          # No heading_source: field['2'],
          # No materials_specified: field['3'],
          # No relationship: subfield_values(field, '4'),
          linkage: field['6'],
          field_link: subfield_values(field, '8')
        }
      end

      def resolve_meeting_name(uri)
        expect_type(uri, ['meeting_name'])
        marc_record = get_marc(uri)
        field = marc_record['111']
        {
          type: name_type_for(field.indicator1),
          meeting_name: subfield_value(field, 'a', clean: true),
          meeting_locations: subfield_values(field, 'c', clean: true),
          meeting_dates: subfield_values(field, 'd', clean: true),
          subordinate_units: subfield_values(field, 'e'),
          work_date: field['f'],
          misc_infos: subfield_values(field, 'g'),
          medium: field['h'],
          # No relationship_info: subfield_values(field, 'i')
          relator_terms: subfield_values(field, 'j'),
          form_subheadings: subfield_values(field, 'k'),
          work_language: field['l'],
          part_numbers: subfield_values(field, 'n', clean: true),
          part_names: subfield_values(field, 'p'),
          following_meeting_name: field['q'],
          versions: subfield_values(field, 's'),
          work_title: field['t'],
          # No affiliation: field['u'],
          form_subdivisions: subfield_values(field, 'v'),
          general_subdivisions: subfield_values(field, 'x'),
          # No issn field['x']
          chronological_subdivisions: subfield_values(field, 'y'),
          geographic_subdivisions: subfield_values(field, 'z'),
          authority_record_control_numbers: [uri],
          # No uri: field['1'],
          # No heading_source: field['2'],
          # No materials_specified: field['3'],
          # No relationshipa: subfield_values(field, '4'),
          linkage: field['6'],
          field_links: subfield_values(field, '8')
        }
      end

      def resolve_gac(uri)
        expect_type(uri, ['geographic_name'])
        marc_record = get_marc(uri)
        marc_record['043']['a']
      end

      def resolve_label(uri)
        graph = RDF::Repository.load("#{uri}.skos.nt")
        query = GraphQuery.new(graph)
        query.path_first_literal([SKOS.prefLabel], subject_term: RDF::URI.new(uri))
      end

      def resolve_type(uri)
        graph = RDF::Repository.load("#{uri}.madsrdf.nt")
        query = GraphQuery.new(graph)
        mads_uris = query.path_all_uri([RDF::RDFV.type], subject_term: RDF::URI.new(uri))
        mads_uris.map { |mad_uri| type_for(mad_uri) }.compact.first
      end

      private

      def get_marc(uri)
        resp = Faraday.get("#{uri}.marcxml.xml")
        raise Error, "Error getting MARCXML for #{uri}." unless resp.success?

        MARC::XMLReader.new(StringIO.new(resp.body)).first
      end

      def personal_name_type_for(indicator1)
        case indicator1
        when '0'
          'forename'
        when '1'
          'surname'
        else
          'family_name'
        end
      end

      def name_type_for(indicator1)
        case indicator1
        when '0'
          'inverted'
        when '1'
          'jurisdiction'
        when '2'
          'direct'
        else ' '
        end
      end

      def clean_value(value)
        return nil if value.nil?

        value.gsub(/[[,)]]$/, '').gsub(/^[(]/, '').gsub(/[ :]$/, '').strip
      end

      def subfield_values(field, code, clean: false)
        field.find_all { |subfield| subfield.code == code }.map do |subfield|
          clean ? clean_value(subfield.value) : subfield.value
        end
      end

      def subfield_value(field, code, clean: false)
        clean ? clean_value(field[code]) : field[code]
      end

      def type_for(mads_uri)
        # Not yet mapped: uniform_title, named_event, chronological_term, topical_term
        case mads_uri
        when 'http://www.loc.gov/mads/rdf/v1#FamilyName'
          'family_name'
        when 'http://www.loc.gov/mads/rdf/v1#PersonalName'
          'personal_name'
        when 'http://www.loc.gov/mads/rdf/v1#CorporateName'
          'corporate_name'
        when 'http://www.loc.gov/mads/rdf/v1#ConferenceName'
          'meeting_name'
        when 'http://www.loc.gov/mads/rdf/v1#Geographic'
          'geographic_name'
        end
      end

      def expect_type(uri, types)
        raise BadRequestError, "#{uri} is not a #{types.join(' or ')}" unless types.include?(resolve_type(uri))
      end
    end
  end
end
