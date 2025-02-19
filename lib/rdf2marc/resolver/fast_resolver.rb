# frozen_string_literal: true

module Rdf2marc
  module Resolver
    # Resolver for http://id.worldcat.org/fast/
    class FastResolver
      def self.resolve_model(uri, model_class)
        new.resolve_model(uri, model_class)
      end

      def resolve_type(uri)
        graph = RDF::Graph.load(uri)
        type_term = type_term_from(graph, uri)
        TYPES.fetch(type_term)
      end

      def resolve_model(uri, model_class)
        mapper_class = mapper_class_for(model_class)
        adapt(mapper_class.new(uri, get_marc(uri)).map)
      end

      private

      def get_marc(uri)
        resp = Rdf2marc.caching_http_adapter.get("#{uri}.mrc.xml")
        raise Error, "Error getting #{url}." unless resp.success?

        MARC::XMLReader.new(StringIO.new(resp.body)).first
      end

      def mapper_class_for(model_class)
        "Rdf2marc::Resolver::MarcMappers::#{model_class.name.demodulize}".constantize
      end

      TYPES = {
        FAST['facet-Geographic'] => 'geographic_name',
        FAST['facet-Meeting'] => 'meeting_name',
        FAST['facet-Event'] => 'event_name',
        FAST['facet-Topical'] => 'topic'
      }.freeze
      private_constant :TYPES

      def type_term_from(graph, uri)
        query = GraphQuery.new(graph)
        type_terms = query.path_all([SKOS.inScheme], subject_term: RDF::URI(uri))

        type_terms.find { |type_term| type_term != FAST.fast }
      end

      # Adapt a generic mapping to FAST.
      def adapt(model)
        model.merge({
                      thesaurus: 'subfield2',
                      source: 'fast'
                    })
      end
    end
  end
end
