require 'logger'

module Warden
  module SharedSession
    class Configuration

      attr_accessor :cookie, :secret, :logger

      # Override defaults for configuration
      # @param cookie [String] cookie name to store encrypted data
      # @param secret [String] secret key(shared between applications) to use in ActiveSupport::MessageEncryptor
      def initialize(cookie = 'shared_session', secret = nil)
        @cookie = cookie
        @secret = secret
        @logger = Logger.new(STDOUT, level: Logger::INFO, progname: 'SharedSession')
      end

      def serialize_into_cookie=(lambda = nil, &block)
        @serialize_into_cookie = lambda || block
      end

      def serialize_from_cookie=(lambda = nil, &block)
        @serialize_from_cookie = lambda || block
      end

      def serialize_into_cookie(*args)
        @serialize_into_cookie&.call(*args)
      end

      def serialize_from_cookie(*args)
        @serialize_from_cookie&.call(*args)
      end

    end
  end
end

