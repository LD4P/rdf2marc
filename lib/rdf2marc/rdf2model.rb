module Rdf2marc
  module Rdf2model
    def self.to_model(instance_graph, work_graph)
      # In merge, instance trumps work
      instance_params = generate_instance(instance_graph)
      # puts "instance: #{JSON.pretty_generate(instance_params)}"
      work_params = generate_work(work_graph)
      # puts "work: #{JSON.pretty_generate(work_params)}"
      record_params = work_params.deep_merge(instance_params).deep_compact
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

  end
end