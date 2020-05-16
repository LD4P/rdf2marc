module Rdf2marc
  module Resolver
    def self.resolve(uri, model_class)
      case uri
      when uri.start_with?('http://id.loc.gov/authorities/names/')
        resolve_loc_name(uri, model_class)
      else
        nil
      end
    end

    def self.resolve_loc_name(uri, model_class)
      case model_class.name
      when Rdf2marc::Models::MainEntryField::PersonalName.name
        Resolver::IdLocGovResolver.new.resolve_personal_name(uri)
      else
        nil
      end
    end
  end
end