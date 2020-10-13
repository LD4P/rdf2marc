# frozen_string_literal: true

module Rdf2marc
  # Global logger
  class Logger
    include Singleton

    def initialize
      @logger = ::Logger.new($stdout)
    end

    class << self
      def configure(logger)
        instance.logger = logger
        self
      end

      delegate :fatal, :error, :debug, :info, :warn, to: :instance
    end

    delegate :fatal, :error, :debug, :info, :warn, to: :logger

    attr_accessor :logger
  end
end
