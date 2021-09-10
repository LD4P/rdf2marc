# frozen_string_literal: true

load_paths = Dir['lib']
$LOAD_PATH.unshift(*load_paths)

require 'rdf2marc'
require 'aws-sdk-s3'

def lambda_handler(event:, context:)
  instance_uri = event['instance_uri']
  marc_path = event['marc_path']
  marc_txt_path = event['marc_txt_path']
  error_path = event['error_path']
  bucket_name = event['bucket']
  delete_from_s3(bucket_name, marc_path)
  delete_from_s3(bucket_name, marc_txt_path)
  delete_from_s3(bucket_name, error_path)
  graph, instance_term, work_term, admin_metadata_term = Rdf2marc::GraphsLoader.from_instance_uri(instance_uri)

  Rdf2marc.cache_implementation = ['Rdf2marc::Caches::S3Cache', event['bucket'], 'cache']

  record_model = Rdf2marc::Rdf2model.to_model(graph, instance_term, work_term, admin_metadata_term)
  marc_record = Rdf2marc::Model2marc::Record.new(record_model)
  write_to_s3(marc_record.to_marc, bucket_name, marc_path)
  write_to_s3(marc_record.to_s, bucket_name, marc_txt_path)
rescue Rdf2marc::UnhandledError => e
  write_to_s3("The conversion you requested is not yet supported: #{e.message}", bucket_name, error_path)
rescue Rdf2marc::BadRequestError => e
  write_to_s3("There is a problem with the supplied RDF: #{e.message}", bucket_name, error_path)
rescue StandardError => e
  write_to_s3("Ooops, something went wrong: #{e.message}", bucket_name, error_path)
  # Log to cloudwatch too:
  raise e
end

def write_to_s3(value, bucket_name, path)
  s3 = Aws::S3::Resource.new
  s3.bucket(bucket_name).object("marc/#{path}").put(body: value)
end

def delete_from_s3(bucket_name, path)
  s3 = Aws::S3::Resource.new
  s3.bucket(bucket_name).object("marc/#{path}").delete
end
