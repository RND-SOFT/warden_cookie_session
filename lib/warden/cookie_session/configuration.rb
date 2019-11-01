require 'logger'

module Warden
  module CookieSession
    class Configuration

      attr_accessor :cookie, :secret, :wrapper, :logger

      # Override defaults for configuration
      # @param cookie [String] cookie name to store encrypted data
      # @param secret [String] secret key(shared between applications) to use in ActiveSupport::MessageEncryptor
      def initialize(cookie = 'cookie_session', secret = nil)
        @cookie = cookie
        @secret = secret
        @logger = Logger.new(STDOUT, level: Logger::INFO, progname: 'CookieSession')
      end

      def serialize_record(record)
        @wrapper&.serialize_record(record)
      end

      def fetch_record(key)
        @wrapper&.fetch_record(key)
      end

      def validate_record(record, salt)
        @wrapper&.validate_record(record, salt)
      end


    end
  end
end

