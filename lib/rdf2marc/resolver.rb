# frozen_string_literal: true

module Rdf2marc
  # Resolves and maps entities to models.
  module Resolver
    def self.resolve(uri, model_class, field = nil)
      return if uri.nil?

      resolve_loc_name(uri, model_class, field) if uri.start_with?('http://id.loc.gov/authorities/names/')
    end

    def self.resolve_loc_name(uri, model_class, field = nil)
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
      when Rdf2marc::Models::NumberAndCodeField::GeographicAreaCode.name
        Resolver::IdLocGovResolver.new.resolve_gac(uri) if field == 'geographic_area_code'
      end
    end
  end
end
