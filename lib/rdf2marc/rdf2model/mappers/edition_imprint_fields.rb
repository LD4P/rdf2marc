# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Edition Imprint Fields model.
      class EditionImprintFields < BaseMapper
        def generate
          {
            editions: editions,
            publication_distributions: publication_distributions
          }
        end

        private

        def editions
          edition_statements = item.instance.query.path_all_literal([BF.editionStatement])

          edition_statements.map { |edition_statement| { edition: edition_statement } }
        end

        def publication_distributions
          publications = publication_distributions_for(item.instance.query.path_all([[BF.provisionActivity,
                                                                                      BF.Publication]]),
                                                       'publication')
          distributions = publication_distributions_for(item.instance.query.path_all([[BF.provisionActivity,
                                                                                       BF.Distribution]]),
                                                        'publication')
          manufactures = publication_distributions_for(item.instance.query.path_all([[BF.provisionActivity,
                                                                                      BF.Manufacture]]),
                                                       'manufacture')
          publications + distributions + manufactures
        end

        def publication_distributions_for(terms, entity_function)
          terms.map do |term|
            {
              entity_function: entity_function,
              publication_distribution_places: publication_distributions_places(term),
              publisher_distributor_names: publication_distributions_names(term),
              publication_distribution_dates: item.instance.query.path_all_literal([BF.date], subject_term: term)
            }
          end
        end

        def publication_distributions_places(subject_term)
          item.instance.query.path_all_uri([BF.place], subject_term: subject_term).map do |place_uri|
            Resolver.resolve_label(place_uri)
          end
        end

        def publication_distributions_names(subject_term)
          item.instance.query.path_all_uri([[BF.agent, BF.Agent], BF.Agent],
                                           subject_term: subject_term).map do |agent_uri|
            Resolver.resolve_label(agent_uri)
          end
        end
      end
    end
  end
end
