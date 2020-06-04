# frozen_string_literal: true

load_paths = Dir['lib']
$LOAD_PATH.unshift(*load_paths)

require 'rdf2marc'

def lambda_handler(event:, context:)
  instance_graph, work_graph, admin_metadata_graph = Rdf2marc::GraphsLoader.from_instance_uri(event['queryStringParameters']['instance'])

  record_model = Rdf2marc::Rdf2model.to_model(instance_graph, work_graph, admin_metadata_graph)
  marc_record = Rdf2marc::Model2marc::Record.new(record_model)
  response(200, marc_record.to_s)
rescue Rdf2marc::UnhandledError => e
  response(500, "The conversion you requested is not yet supported: #{e.message}")
rescue Rdf2marc::BadRequestError => e
  response(400, "There is a problem with the supplied RDF: #{e.message}")
rescue StandardError => e
  response(500, "Ooops, something went wrong: #{e.message}")
end

def response(code, body)
  {
      'statusCode' => code,
      'headers' => {
          'Content-Type' => 'text/plain'
      },
      'body' => body
  }
end
