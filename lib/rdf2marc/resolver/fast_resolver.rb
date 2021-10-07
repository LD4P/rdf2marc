# frozen_string_literal: true

module Rdf2marc
  module Resolver
    # Resolver for http://id.worldcat.org/fast/
    class FastResolver
      def resolve_type(uri)
        graph = RDF::Graph.load(uri)
        type_for(graph.query(subject: RDF::URI(uri), predicate: RDF::RDFV.type).map(&:object).first)
      end

      def resolve_model(uri, model_class)
        mapper_class = mapper_class_for(model_class)
        mapper_class.new(uri, RDF::Graph.load(uri)).map
      end

      private

      def mapper_class_for(model_class)
        "Rdf2marc::Resolver::FastResolvers::#{model_class.name.demodulize}".constantize
      end

      TYPES = {
        'http://schema.org/Place' => 'geographic_name',
        'http://schema.org/Event' => 'event_name',
        'http://schema.org/Intangible' => 'topic'
      }.freeze

      def type_for(type_uri)
        TYPES.fetch(type_uri.to_s)
      end
    end
  end
end
