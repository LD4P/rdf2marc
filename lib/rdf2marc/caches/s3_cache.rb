# frozen_string_literal: true

module Rdf2marc
  module Caches
    # Cache backed by S3
    # See https://github.com/aws/aws-sdk-ruby#configuration for configuration.
    class S3Cache
      def initialize(bucket_name, path = 'cache')
        @bucket_name = bucket_name
        @path = path
      end

      def set_cache(key, value)
        bucket.object(objpath_from(key)).put(body: value)
      end

      def get_cache(key)
        bucket.object(objpath_from(key)).get.body.string
      rescue Aws::S3::Errors::NoSuchKey
        nil
      end

      private

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
