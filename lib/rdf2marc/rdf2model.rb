# frozen_string_literal: true

module Rdf2marc
  # Mapping RDF to model.
  module Rdf2model
    def self.to_model(instance_graph, work_graph, admin_metadata_graph)
      # In merge, instance trumps work
      instance_params = generate_instance(instance_graph)
      work_params = generate_work(work_graph)
      admin_metadata_params = generate_admin_metadata(admin_metadata_graph)
      record_params = admin_metadata_params.deep_merge(work_params).deep_merge(instance_params).deep_compact
      puts "record: #{JSON.pretty_generate(record_params)}"
      Rdf2marc::Models::Record.new(record_params)
    end

    def self.generate_instance(graph)
      graph_helper = GraphHelper.new(graph)
      clazz = case graph_helper.resource_template
              when *MonographInstance::RESOURCE_TEMPLATES
                MonographInstance
              else
                raise 'Unknown resource template or resource template not found'
              end
      clazz.new(graph, graph_helper.uri).generate
    end

    def self.generate_work(graph)
      graph_helper = GraphHelper.new(graph)
      clazz = case graph_helper.resource_template
              when *MonographWork::RESOURCE_TEMPLATES
                MonographWork
              else
                raise 'Unknown resource template or resource template not found'
              end
      clazz.new(graph, graph_helper.uri).generate
    end

    def self.generate_admin_metadata(graph)
      graph_helper = GraphHelper.new(graph)
      clazz = case graph_helper.resource_template
              when *AdminMetadataBfdb::RESOURCE_TEMPLATES
                AdminMetadataBfdb
              else
                raise 'Unknown resource template or resource template not found'
              end
      clazz.new(graph, graph_helper.uri).generate
    end
  end
end
