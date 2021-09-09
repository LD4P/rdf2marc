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

        expect_type(uri, EXPECTED_TYPES.fetch(model_class))
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
        resp = connection.get(url)
        raise Error, "Error getting #{url}." unless resp.success?

        resp.body
      end

      def connection
        @connection ||= Faraday.new do |builder|
          builder.use :http_cache, store: Rdf2marc.cache
          builder.use FaradayMiddleware::FollowRedirects
          builder.response :encoding # use Faraday::Encoding middleware
          builder.adapter Faraday.default_adapter
        end
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
        "Rdf2marc::Resolver::IdLocGovResolvers::#{model_class.name.demodulize}".constantize
      end

      EXPECTED_TYPES = {
        Rdf2marc::Models::General::PersonalName => %w[personal_name family_name],
        Rdf2marc::Models::General::CorporateName => ['corporate_name'],
        Rdf2marc::Models::General::MeetingName => ['meeting_name'],
        Rdf2marc::Models::SubjectAccessField::GeographicName => ['geographic_name'],
        Rdf2marc::Models::SubjectAccessField::GenreForm => ['genre_form'],
        Rdf2marc::Models::SubjectAccessField::TopicalTerm => ['topic']
      }.freeze
    end
  end
end
