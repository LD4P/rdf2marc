# frozen_string_literal: true

module Rdf2marc
  module Caches
    # Cache backed by S3
    # See https://github.com/aws/aws-sdk-ruby#configuration for configuration.
    class S3Cache < ActiveSupport::Cache::Store
      def initialize(bucket_name, path, **options)
        super(options)
        @bucket_name = bucket_name
        @path = path
      end

      private

      # @param [ActiveSupport::Cache::Entry] entry the cache entry
      def write_entry(key, entry, **options)
        write_serialized_entry(key, serialize_entry(entry, **options), **options)
      end

      def read_entry(key, **options)
        deserialize_entry(read_serialized_entry(key, **options))
      end

      def write_serialized_entry(key, payload, **_options)
        bucket.object(objpath_from(key)).put(body: payload)
      end

      def read_serialized_entry(key, **_options)
        bucket.object(objpath_from(key)).get.body.string
      rescue Aws::S3::Errors::NoSuchKey
        nil
      end

      attr_reader :bucket_name, :path

      def objpath_from(key)
        "#{path}/#{Digest::MD5.hexdigest(key)}.blob"
      end

      def s3
        @s3 ||= Aws::S3::Resource.new
      end

      def bucket
        @bucket ||= s3.bucket(bucket_name)
      end
    end
  end
end
