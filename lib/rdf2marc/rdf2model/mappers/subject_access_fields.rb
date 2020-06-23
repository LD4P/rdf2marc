# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Subject Access Fields model.
      class SubjectAccessFields < BaseMapper
        def generate
          # Note that this is only partially implemented.
          subj_fields = {
            personal_names: [],
            corporate_names: [],
            meeting_names: [],
            geographic_names: [],
            genre_forms: genre_forms
          }
          subject_uris = item.work.query.path_all_uri([BF.subject])
          subject_uris.each do |subject_uri|
            subject_type = Resolver.resolve_type(subject_uri)
            if subject_type == 'corporate_name'
              subj_fields[:corporate_names] << Resolver.resolve_model(subject_uri,
                                                                      Rdf2marc::Models::General::CorporateName)
            elsif %w[personal_name family_name].include?(subject_type)
              subj_fields[:personal_names] << Resolver.resolve_model(subject_uri,
                                                                     Rdf2marc::Models::General::PersonalName)
            elsif subject_type == 'meeting_name'
              subj_fields[:meeting_names] << Resolver.resolve_model(subject_uri,
                                                                    Rdf2marc::Models::General::MeetingName)
            elsif subject_type == 'geographic_name'
              subj_fields[:geographic_names] << Resolver.resolve_model(
                subject_uri,
                Rdf2marc::Models::SubjectAccessField::GeographicName
              )
            elsif subject_type
              Logger.warn("Resolving subject for #{subject_uri} not supported.")
            end
          end
          subj_fields
        end

        private

        def genre_forms
          genre_form_uris = item.work.query.path_all_uri([BF.genreForm])
          genre_form_uris.map do |genre_form_uri|
            Resolver.resolve_model(genre_form_uri, Models::SubjectAccessField::GenreForm)
          end
        end
      end
    end
  end
end
