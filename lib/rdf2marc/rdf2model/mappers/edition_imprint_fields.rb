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

          edition_statements.sort.map { |edition_statement| { edition: edition_statement } }
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
          item.instance.query.path_all([BF.place], subject_term: subject_term).map do |place_term|
            place_term.is_a?(RDF::Literal) ? place_term.value : Resolver.resolve_label(place_term&.value)
          end
        end

        def publication_distributions_names(subject_term)
          item.instance.query.path_all([[BF.agent, BF.Agent]],
                                       subject_term: subject_term).map do |agent_term|
            next Resolver.resolve_label(agent_term&.value) unless agent_term.is_a?(RDF::Node)

            item.instance.graph.query(subject: agent_term,
                                      predicate: RDF::RDFS.label).map(&:object).map(&:value).join(', ')
          end
        end
      end
    end
  end
end
