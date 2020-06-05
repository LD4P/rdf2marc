# frozen_string_literal: true

module Rdf2marc
  module Resolver
    # Resolver for id.loc.gov.
    class IdLocGovResolver
      def resolve_personal_name(uri)
        marc_record = get_marc(uri)
        field = marc_record['100']
        {
          type: personal_name_type_for(field.indicator1),
          personal_name: clean(field['a']),
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
        marc_record = get_marc(uri)
        field = marc_record['110']
        {
          type: corporate_name_type_for(field.indicator1),
          corporate_name: clean(field['a']),
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

      def resolve_gac(uri)
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

      def corporate_name_type_for(indicator1)
        case indicator1
        when '0'
          'inverted'
        when '1'
          'jurisdiction'
        else
          'direct'
        end
      end

      def clean(value)
        value.gsub(/[,]$/, '')
      end

      def subfield_values(field, code)
        field.find_all { |subfield| subfield.code == code }.map(&:value)
      end

      def type_for(mads_uri)
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
        # Not yet mapped: uniform_title, named_event, chronological_term, topical_term
      end
    end
  end
end
