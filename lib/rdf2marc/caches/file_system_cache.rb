# frozen_string_literal: true

module Rdf2marc
  module Caches
    # Cache backed by file system.
    class FileSystemCache
      def initialize(path = 'cache')
        @path = path
        FileUtils.mkdir_p(path)
      end

      def set_cache(key, value)
        File.write(filepath_from(key), value)
      end

      def get_cache(key)
        File.read(filepath_from(key))
      rescue Errno::ENOENT
        nil
      end

      private

      attr_reader :path

      def filepath_from(key)
        "#{path}/#{Digest::MD5.hexdigest(key)}.blob"
      end
    end
  end
end
