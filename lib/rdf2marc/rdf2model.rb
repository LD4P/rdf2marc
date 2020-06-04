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
      Rdf2marc::Models::Record.new(record_params)
    end

    def self.generate_instance(graph)
      graph_helper = GraphHelper.new(graph)
      Logger.info("Generating models for Instance #{graph_helper.uri}.")
      clazz = case graph_helper.resource_template
              when *MonographInstance::RESOURCE_TEMPLATES
                MonographInstance
              when nil
                raise BadRequestError, 'Resource template not provided for Instance'
              else
                Logger.warn("Unhandled instance resource template: #{graph_helper.resource_template}")
                raise UnhandledError, 'Unknown resource template for Instance'
              end
      clazz.new(graph, graph_helper.uri).generate
    end

    def self.generate_work(graph)
      graph_helper = GraphHelper.new(graph)
      Logger.info("Generating models for Work #{graph_helper.uri}.")
      clazz = case graph_helper.resource_template
              when *MonographWork::RESOURCE_TEMPLATES
                MonographWork
              when nil
                raise BadRequestError, 'Resource template not provided for Work'
              else
                Logger.warn("Unhandled work resource template: #{graph_helper.resource_template}")
                raise UnhandledError, 'Unknown resource template for Work'
              end
      clazz.new(graph, graph_helper.uri).generate
    end

    def self.generate_admin_metadata(graph)
      graph_helper = GraphHelper.new(graph)
      Logger.info("Generating models for Admin Metadata #{graph_helper.uri}.")
      clazz = case graph_helper.resource_template
              when *AdminMetadataBfdb::RESOURCE_TEMPLATES
                AdminMetadataBfdb
              when nil
                raise BadRequestError, 'Resource template not provided for Admin Metadata'
              else
                Logger.warn("Unhandled admin metadata resource template: #{graph_helper.resource_template}")
                raise UnhandledError, 'Unknown resource template for Admin Metadata'
              end
      clazz.new(graph, graph_helper.uri).generate
    end
  end
end
