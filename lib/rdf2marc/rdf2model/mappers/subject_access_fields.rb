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
            geographic_names: fast_places,
            event_names: [],
            topical_terms: [],
            genre_forms:
          }
          subject_terms = item.work.query.path_all([BF.subject])
          subject_terms.sort.each do |subject_term|
            subject_type = Resolver.resolve_type(subject_term.value)
            case subject_type
            when 'corporate_name'
              subj_fields[:corporate_names] <<
                LiteralOrRemoteResolver.resolve_model(term: subject_term,
                                                      item:, key_symbol: subject_type.to_sym,
                                                      model: Rdf2marc::Models::General::CorporateName)
            when 'personal_name', 'family_name'
              subj_fields[:personal_names] <<
                LiteralOrRemoteResolver.resolve_model(term: subject_term,
                                                      item:, key_symbol: :personal_name,
                                                      model: Rdf2marc::Models::General::PersonalName)
            when 'meeting_name'
              subj_fields[:meeting_names] <<
                LiteralOrRemoteResolver.resolve_model(term: subject_term,
                                                      item:, key_symbol: subject_type.to_sym,
                                                      model: Rdf2marc::Models::General::MeetingName)
            when 'geographic_name'
              subj_fields[:geographic_names] <<
                LiteralOrRemoteResolver.resolve_model(term: subject_term,
                                                      item:, key_symbol: subject_type.to_sym,
                                                      model: Rdf2marc::Models::SubjectAccessField::GeographicName)
            when 'event_name'
              subj_fields[:event_names] <<
                LiteralOrRemoteResolver.resolve_model(term: subject_term,
                                                      item:,
                                                      key_symbol: subject_type.to_sym,
                                                      model: Rdf2marc::Models::SubjectAccessField::EventName)
            when 'topic'
              subj_fields[:topical_terms] <<
                LiteralOrRemoteResolver.resolve_model(term: subject_term,
                                                      item:, key_symbol: :topic,
                                                      model: Rdf2marc::Models::SubjectAccessField::TopicalTerm)
            end
          end
          subj_fields
        end

        private

        def genre_forms
          genre_form_terms = item.work.query.path_all([BF.genreForm])
          genre_form_terms.sort.map do |genre_form_term|
            if genre_form_term.is_a?(RDF::Literal)
              {
                genre_form_data: genre_form_term.value,
                thesaurus: 'not_specified'
              }
            else
              Resolver.resolve_model(genre_form_term&.value, Models::SubjectAccessField::GenreForm)
            end
          end
        end

        def fast_places
          provision_activity_uris = item.instance.query.path_all_uri([BF.provisionActivity, BF.place])
          provision_activity_uris.select { |uri| Resolver.fast?(uri) }.sort.map do |provision_activity_uri|
            Resolver.resolve_model(provision_activity_uri, Models::SubjectAccessField::GeographicName)
          end
        end
      end
    end
  end
end
