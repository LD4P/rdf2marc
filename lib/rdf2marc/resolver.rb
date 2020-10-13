# frozen_string_literal: true

module Rdf2marc
  # Resolves and maps entities to models.
  module Resolver
    def self.resolve_model(uri, model_class)
      if uri.nil?
        nil
      elsif id_loc?(uri)
        resolve_loc_name_model(uri, model_class)
      else
        Logger.warn("Resolving #{uri} to #{model_class} not supported.")
        nil
      end
    end

    def self.resolve_loc_name_model(uri, model_class)
      case model_class.name
      when Rdf2marc::Models::General::PersonalName.name
        Resolver::IdLocGovResolver.new.resolve_personal_name(uri)
      when Rdf2marc::Models::General::CorporateName.name
        Resolver::IdLocGovResolver.new.resolve_corporate_name(uri)
      when Rdf2marc::Models::General::MeetingName.name
        Resolver::IdLocGovResolver.new.resolve_meeting_name(uri)
      when Rdf2marc::Models::SubjectAccessField::GeographicName.name
        Resolver::IdLocGovResolver.new.resolve_geographic_name(uri)
      when Rdf2marc::Models::SubjectAccessField::GenreForm.name
        Resolver::IdLocGovResolver.new.resolve_genre_form(uri)
      when Rdf2marc::Models::SubjectAccessField::TopicalTerm.name
        Resolver::IdLocGovResolver.new.resolve_topical_term(uri)
      else
        Logger.warn("Resolving #{uri} to #{model_class} not supported.")
        nil
      end
    end

    def self.resolve_label(uri)
      if uri.nil?
        nil
      elsif id_loc?(uri)
        Resolver::IdLocGovResolver.new.resolve_label(uri)
      else
        Logger.warn("Resolving label for #{uri} not supported.")
        nil
      end
    end

    def self.resolve_geographic_area_code(uri)
      if uri.nil?
        nil
      elsif id_loc?(uri)
        Resolver::IdLocGovResolver.new.resolve_gac(uri)
      else
        Logger.warn("Resolving geographic area code for #{uri} not supported.")
        nil
      end
    end

    # personal_name, family_name, corporate_name, meeting_name, uniform_title, named_event,
    # chronological_term, topical_term, geographic_name
    def self.resolve_type(uri)
      if uri.nil?
        nil
      elsif id_loc?(uri)
        Resolver::IdLocGovResolver.new.resolve_type(uri)
      else
        Logger.warn("Resolving type for #{uri} not supported.")
        nil
      end
    end

    def self.id_loc?(uri)
      uri.start_with?(%r{https?://id.loc.gov/authorities/})
    end
    private_class_method :id_loc?
  end
end
