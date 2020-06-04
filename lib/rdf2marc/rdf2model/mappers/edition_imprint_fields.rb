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
          pub_dist_terms = item.instance.query.path_all([[BF.provisionActivity, BF.Publication]])
          pub_dists = pub_dist_terms.map do |pub_dist_term|
            {
              publication_distribution_places: publication_distributions_places(pub_dist_term),
              publisher_distributor_names: publication_distributions_names(pub_dist_term),
              publication_distribution_dates: item.instance.query.path_all_literal([BF.date],
                                                                                   subject_term: pub_dist_term)
            }
          end
          manufacture_terms = item.instance.query.path_all([[BF.provisionActivity, BF.Distribution]])
          manufactures = manufacture_terms.map do |manufacture_term|
            {
              manufacture_places: publication_distributions_places(manufacture_term),
              manufacturer_names: publication_distributions_names(manufacture_term),
              manufacture_dates: item.instance.query.path_all_literal([BF.date], subject_term: manufacture_term)
            }
          end
          pub_dists + manufactures
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
