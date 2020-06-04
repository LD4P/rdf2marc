# frozen_string_literal: true

module Rdf2marc
  # Resolves and maps entities to models.
  module Resolver
    def self.resolve_model(uri, model_class)
      if uri.nil?
        nil
      elsif uri.start_with?('http://id.loc.gov/authorities/')
        resolve_loc_name_model(uri, model_class)
      else
        Logger.warn("Resolving #{uri} to #{model_class} not supported.")
        nil
      end
    end

    def self.resolve_loc_name_model(uri, model_class)
      case model_class.name
      when Rdf2marc::Models::MainEntryField::PersonalName.name
        Resolver::IdLocGovResolver.new.resolve_main_personal_name(uri)
      when Rdf2marc::Models::SubjectAccessField::PersonalName.name
        Resolver::IdLocGovResolver.new.resolve_subject_personal_name(uri)
      when Rdf2marc::Models::AddedEntryField::PersonalName.name
        Resolver::IdLocGovResolver.new.resolve_added_personal_name(uri)
      when Rdf2marc::Models::MainEntryField::CorporateName.name
        Resolver::IdLocGovResolver.new.resolve_main_corporate_name(uri)
      when Rdf2marc::Models::SubjectAccessField::CorporateName.name
        Resolver::IdLocGovResolver.new.resolve_subject_corporate_name(uri)
      when Rdf2marc::Models::AddedEntryField::CorporateName.name
        Resolver::IdLocGovResolver.new.resolve_added_corporate_name(uri)
      else
        Logger.warn("Resolving #{uri} to #{model_class} not supported.")
        nil
      end
    end

    def self.resolve_label(uri)
      if uri.nil?
        nil
      elsif uri.start_with?('http://id.loc.gov/authorities/')
        Resolver::IdLocGovResolver.new.resolve_label(uri)
      else
        Logger.warn("Resolving label for #{uri} not supported.")
        nil
      end
    end

    def self.resolve_geographic_area_code(uri)
      if uri.nil?
        nil
      elsif uri.start_with?('http://id.loc.gov/authorities/')
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
      elsif uri.start_with?('http://id.loc.gov/authorities/')
        Resolver::IdLocGovResolver.new.resolve_type(uri)
      else
        Logger.warn("Resolving type for #{uri} not supported.")
        nil
      end
    end
  end
end
