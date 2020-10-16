# frozen_string_literal: true

module Rdf2marc
  module Resolver
    # Resolver for id.loc.gov.
    class IdLocGovResolver
      def resolve_model(uri, model_class)
        mapper_class = mapper_class_for(model_class)

        if mapper_class.nil?
          Logger.warn("Resolving #{uri} to #{model_class} not supported.")
          return nil
        end

        expect_type(uri, types_for(model_class))
        marc_record = get_marc(uri)
        mapper_class.new(uri, marc_record).map
      end

      def resolve_gac(uri)
        expect_type(uri, ['geographic_name'])
        marc_record = get_marc(uri)

        if marc_record['043'].nil?
          Logger.warn("Could not get GAC for #{uri} since missing field 043.")
          return nil
        end

        marc_record['043']['a']
      end

      def resolve_label(uri)
        graph = graph_get("#{uri}.skos.nt")
        query = GraphQuery.new(graph)
        query.path_first_literal([SKOS.prefLabel], subject_term: RDF::URI.new(uri))
      end

      def resolve_type(uri)
        graph = graph_get("#{uri}.madsrdf.nt")
        query = GraphQuery.new(graph)
        mads_uris = query.path_all_uri([RDF::RDFV.type], subject_term: RDF::URI.new(uri))
        return resolve_complex_type(uri, query) if mads_uris.include?('http://www.loc.gov/mads/rdf/v1#ComplexSubject')

        mads_uris.map { |mad_uri| type_for(mad_uri) }.compact.first
      end

      private

      def graph_get(url)
        data = StringIO.new(http_get(url))
        graph = RDF::Repository.new
        reader = RDF::Reader.for(:ntriples).new(data)
        graph << reader
        graph
      end

      def http_get(url)
        body = Cache.get_cache(url)
        if body.nil?
          conn = Faraday.new do |faraday|
            faraday.use FaradayMiddleware::FollowRedirects
          end
          resp = conn.get(url)
          raise Error, "Error getting #{url}." unless resp.success?

          body = resp.body
          Cache.set_cache(url, body)
        end
        body
      end

      def get_marc(uri)
        body = http_get("#{uri}.marcxml.xml")
        MARC::XMLReader.new(StringIO.new(body)).first
      end

      def type_for(mads_uri)
        # Not yet mapped: uniform_title, named_event, chronological_term, topical_term
        types = {
          'http://www.loc.gov/mads/rdf/v1#FamilyName' => 'family_name',
          'http://www.loc.gov/mads/rdf/v1#PersonalName' => 'personal_name',
          'http://www.loc.gov/mads/rdf/v1#CorporateName' => 'corporate_name',
          'http://www.loc.gov/mads/rdf/v1#ConferenceName' => 'meeting_name',
          'http://www.loc.gov/mads/rdf/v1#Geographic' => 'geographic_name',
          'http://www.loc.gov/mads/rdf/v1#GenreForm' => 'genre_form',
          'http://www.loc.gov/mads/rdf/v1#Topic' => 'topic'
        }
        types[mads_uri]
      end

      def expect_type(uri, types)
        raise BadRequestError, "#{uri} is not a #{types.join(' or ')}" unless types.include?(resolve_type(uri))
      end

      def resolve_complex_type(uri, query)
        mads_uris = query.path_all_uri([[MADS.componentList], [RDF::RDFV.first], [RDF::RDFV.type]],
                                       subject_term: RDF::URI.new(uri))
        mads_uris.map { |mad_uri| type_for(mad_uri) }.compact.first
      end

      def mapper_class_for(model_class)
        case model_class.name
        when Rdf2marc::Models::General::PersonalName.name
          IdLocGovResolvers::PersonalName
        when Rdf2marc::Models::General::CorporateName.name
          IdLocGovResolvers::CorporateName
        when Rdf2marc::Models::General::MeetingName.name
          IdLocGovResolvers::MeetingName
        when Rdf2marc::Models::SubjectAccessField::GeographicName.name
          IdLocGovResolvers::GeographicName
        when Rdf2marc::Models::SubjectAccessField::GenreForm.name
          IdLocGovResolvers::GenreForm
        when Rdf2marc::Models::SubjectAccessField::TopicalTerm.name
          IdLocGovResolvers::TopicalTerm
        end
      end

      def types_for(model_class)
        case model_class.name
        when Rdf2marc::Models::General::PersonalName.name
          %w[personal_name family_name]
        when Rdf2marc::Models::General::CorporateName.name
          ['corporate_name']
        when Rdf2marc::Models::General::MeetingName.name
          ['meeting_name']
        when Rdf2marc::Models::SubjectAccessField::GeographicName.name
          ['geographic_name']
        when Rdf2marc::Models::SubjectAccessField::GenreForm.name
          ['genre_form']
        when Rdf2marc::Models::SubjectAccessField::TopicalTerm.name
          ['topic']
        end
      end
    end
  end
end
