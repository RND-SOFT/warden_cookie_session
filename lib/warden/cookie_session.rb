require 'warden'
require 'warden/cookie_session/version'
require 'warden/cookie_session/default_wrapper'
require 'warden/cookie_session/configuration'
require 'warden/cookie_session/strategy'

module Warden
  module CookieSession

    class << self

      attr_accessor :config

    end

    self.config ||= Warden::CookieSession::Configuration.new

    class << self

      def configure
        self.config ||= Warden::CookieSession::Configuration.new
        yield(config)
        setup_warden(config)
      end

      def setup_warden(config)
        Warden::Strategies.add(:cookie_session, Warden::CookieSession::Strategy)

        Warden::Manager.after_set_user do |user, auth, _opts|
          encrypted_cookie = Warden::CookieSession::Strategy.encrypted_cookie(auth.cookies)
          encrypted_cookie.put(config.serialize_record(user))
        end

        Warden::Manager.before_logout do |_user, auth, _opts|
          encrypted_cookie = Warden::CookieSession::Strategy.encrypted_cookie(auth.cookies)
          encrypted_cookie.clear
        end
      end

    end

  end
end

