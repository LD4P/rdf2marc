module Rdf2marc
  module Resolver
    class IdLocGovResolver
      def resolve_personal_name(uri)
        marc_record = get_marc(uri)
        field = marc_record['100']
        {
            type: name_type_for(field.indicator1),
            personal_name: clean(field['a']),
            numeration: field['b'],
            title_and_words: subfield_values(field, 'c'),
            dates: field['d'],
            relator_terms: subfield_values(field, 'e'),
            work_date: field['f'],
            misc_infos: subfield_values(field, 'g'),
            attribution_qualifiers: subfield_values(field, 'j'),
            form_subheadings: subfield_values(field, 'k'),
            work_language: field['l'],
            part_numbers: subfield_values(field, 'n'),
            part_names: subfield_values(field, 'p'),
            fuller_form: field['q'],
            work_title: field['t'],
            affiliation: field['u'],
            authority_record_control_number: subfield_values(field, '0'),
            uri: field['1'],
            heading_source: field['2'],
            relationship: subfield_values(field, '4'),
            linkage: field['6'],
            field_link: subfield_values(field, '8')
        }
      end

      private

      def get_marc(uri)
        resp = Faraday.get("#{uri}.marcxml.xml")
        raise unless resp.success?
        MARC::XMLReader.new(StringIO.new(resp.body)).first
      end

      def name_type_for(indicator1)
        case indicator1
        when '0'
          "forename"
        when "1"
          "surname"
        else
          "family_name"
        end
      end

      def clean(value)
        value.gsub(/[,]$/, '')
      end

      def subfield_values(field, code)
        field.find_all {|subfield| subfield.code == code}.map {|subfield| subfield.value}
      end
    end
  end
end