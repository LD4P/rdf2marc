# frozen_string_literal: true

module Rdf2marc
  # Resolves and maps entities to models.
  module Resolver
    def self.resolve_model(uri, model_class)
      return nil if uri.nil?

      resolver_class = resolver_class_for(uri)

      if resolver_class.nil? || !resolver_class.method_defined?('resolve_model')
        Logger.warn("Resolving #{uri} to #{model_class} not supported.")
        return nil
      end

      resolver_class.new.resolve_model(uri, model_class)
    end

    def self.resolve_label(uri)
      return nil if uri.nil?

      resolver_class = resolver_class_for(uri)

      if resolver_class.nil? || !resolver_class.method_defined?('resolve_label')
        Logger.warn("Resolving label for #{uri} not supported.")
        return nil
      end

      resolver_class.new.resolve_label(uri)
    end

    def self.resolve_geographic_area_code(uri)
      return nil if uri.nil?

      resolver_class = resolver_class_for(uri)

      if resolver_class.nil? || !resolver_class.method_defined?('resolve_gac')
        Logger.warn("Resolving geographic area code for #{uri} not supported.")
        return nil
      end

      resolver_class.new.resolve_gac(uri)
    end

    # personal_name, family_name, corporate_name, meeting_name, uniform_title, named_event,
    # chronological_term, topical_term, geographic_name
    def self.resolve_type(uri)
      return nil if uri.nil?

      resolver_class = resolver_class_for(uri)

      if resolver_class.nil? || !resolver_class.method_defined?('resolve_type')
        Logger.warn("Resolving type for #{uri} not supported.")
        return nil
      end

      resolver_class.new.resolve_type(uri)
    end

    def self.resolver_class_for(uri)
      # Additional resolvers can be added here.
      return Resolver::IdLocGovResolver if uri.start_with?(%r{https?://id.loc.gov/(authorities|vocabulary)})

      nil
    end
    private_class_method :resolver_class_for
  end
end
