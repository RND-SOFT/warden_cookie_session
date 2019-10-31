require "warden"
require 'warden/shared_session/version'
require 'warden/shared_session/configuration'
require 'warden/shared_session/strategy'

module Warden
  module SharedSession

    class << self

      attr_accessor :config

    end

    self.config ||= Warden::SharedSession::Configuration.new

    class << self

      def configure
        self.config ||= Warden::SharedSession::Configuration.new
        yield(config)
        setup_warden(config)
      end

      def setup_warden(config)
        Warden::Strategies.add(:shared_session, Warden::SharedSession::Strategy)

        Warden::Manager.after_set_user do |user, auth, opts|
          config.logger.debug{ "after_set_user: #{user}, #{auth}, #{opts}" }
          encrypted_cookie = Warden::SharedSession::Strategy.encrypted_cookie(auth.cookies)
          encrypted_cookie.put(config.serialize_into_cookie(user))
        end

        Warden::Manager.before_logout do |user, auth, opts|
          config.logger.debug{ "before_logout: #{user}, #{auth}, #{opts}" }
          encrypted_cookie = Warden::SharedSession::Strategy.encrypted_cookie(auth.cookies)
          encrypted_cookie.clear
        end
      end

    end

  end
end

