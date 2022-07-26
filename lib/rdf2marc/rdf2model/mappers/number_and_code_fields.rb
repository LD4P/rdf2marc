# frozen_string_literal: true

module Rdf2marc
  module Rdf2model
    module Mappers
      # Mapping to Number and Code Fields model.
      class NumberAndCodeFields < BaseMapper
        def generate
          {
            oclc_record_number: oclc_record_number,
            lccn: lccn,
            isbns: isbns,
            cataloging_source: cataloging_source,
            geographic_area_code: geographic_area_codes,
            lc_call_numbers: lc_call_numbers
          }
        end

        private

        def oclc_record_number
          item.admin_metadata.query.path_first_literal([[BF.identifiedBy, BF.Local], [RDF::RDFV.value]])
        end

        def lccn
          # Can be multiple non-cancelled LCCNs. However, only using one.
          lccn = {
            cancelled_lccns: []
          }
          id_terms = item.instance.query.path_all([[BF.identifiedBy, BF.Lccn]])

          id_terms.sort.each do |id_term|
            lccn_value = item.instance.query.path_first_literal([RDF::RDFV.value], subject_term: id_term)
            next if lccn_value.nil?

            is_cancelled = item.instance.query.path_first([BF.status],
                                                          subject_term: id_term) == LC_VOCAB['mstatus/cancinv']
            if is_cancelled
              lccn[:cancelled_lccns] << lccn_value
            else
              lccn[:lccn] = lccn_value
            end
          end
          lccn
        end

        def isbns
          id_terms = item.instance.query.path_all([[BF.identifiedBy, BF.Isbn]])

          # Cancelled ISBNs should probably be associated with an ISBN. However, RDF model does not support.
          id_terms.sort.map do |id_term|
            isbn_value = item.instance.query.path_first_literal([RDF::RDFV.value], subject_term: id_term)
            next if isbn_value.nil?

            is_cancelled = item.instance.query.path_first([BF.status],
                                                          subject_term: id_term) == LC_VOCAB['mstatus/cancinv']
            isbn = {}
            if is_cancelled
              isbn[:cancelled_isbns] = [isbn_value]
            else
              isbn[:isbn] = isbn_value
            end
            qualifier_values = item.instance.query.path_all_literal([BF.qualifier], subject_term: id_term)
            isbn[:qualifying_infos] = qualifier_values if qualifier_values
            isbn
          end.compact
        end

        def cataloging_source
          {
            cataloging_agency: agency,
            cataloging_language: cataloging_language,
            transcribing_agency: agency,
            modifying_agencies: modifying_agencies,
            description_conventions: description_conventions
          }
        end

        def agency
          agency_uri = item.admin_metadata.query.path_first_uri([[BF.assigner, BF.Agent]]) ||
                       item.admin_metadata.query.path_first_uri([BF.source])

          return if agency_uri.nil?

          Resolver::CulturalHeritageInstitution.resolve_code(agency_uri)
        end

        def cataloging_language
          language_uri = item.admin_metadata.query.path_first_uri([BF.descriptionLanguage])

          return if language_uri.nil?

          language_uri.sub(%r{^https?://id.loc.gov/vocabulary/languages/}, '')
        end

        def modifying_agencies
          item.admin_metadata.query.path_all_uri([BF.descriptionModifier]).sort.map do |agency_uri|
            Resolver::CulturalHeritageInstitution.resolve_code(agency_uri)
          end
        end

        def description_conventions
          item.admin_metadata.query.path_all_uri([BF.descriptionConventions]).sort.map do |agency_uri|
            agency_uri.sub(%r{^https?://id.loc.gov/vocabulary/descriptionConventions/}, '')
          end
        end

        def geographic_area_codes
          gac_uris = item.work.query.path_all_uri([BF.geographicCoverage])
          gacs = gac_uris.map do |gac_uri|
            Resolver.resolve_geographic_area_code(gac_uri)
          end
          {
            geographic_area_codes: gacs.compact.sort
          }
        end

        def lc_call_numbers
          classification_terms = item.work.query.path_all([[BF.classification, BF.ClassificationLcc]])

          classification_terms.sort.map do |classification_term|
            {
              classification_numbers: item.work.query.path_all_literal([BF.classificationPortion],
                                                                       subject_term: classification_term).sort,
              # Can be multiple, however only using one.
              item_number: item.work.query.path_first_literal([BF.itemPortion], subject_term: classification_term)
            }
          end
        end
      end
    end
  end
end
