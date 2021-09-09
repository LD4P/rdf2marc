# frozen_string_literal: true

module Rdf2marc
  # Global cache
  class Converter
    def self.convert(url: nil, files: [])
      if url
        graph, instance_term, work_term, admin_metadata_term = Rdf2marc::GraphsLoader.from_instance_uri(url)
      else
        graph, instance_term, work_term, admin_metadata_term = Rdf2marc::GraphsLoader.from_filepaths(files)
      end

      Rdf2marc::Rdf2model.to_model(graph, instance_term, work_term, admin_metadata_term)
    end
  end
end
