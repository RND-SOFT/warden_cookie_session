require 'warden/cookie_session/encrypted_cookie'

class Warden::CookieSession::Strategy < ::Warden::Strategies::Base

  def valid?
    cookies[Warden::CookieSession.config.cookie]
  end

  def store?
    false
  end

  def authenticate!
    key, salt = encrypted_cookie.get
    record = Warden::CookieSession.config.fetch_record(key)
    success!(record) if record && Warden::CookieSession.config.validate_record(record, salt)
  rescue StandardError => e
    logger.warn "Warden::CookieSession::Strategy failed: #{e}"
    fail!(e)
    logger.debug { e.backtrace }
  end

  def self.encrypted_cookie(cookies)
    Warden::CookieSession::EncryptedCookie.new(
      store:  cookies,
      cookie: Warden::CookieSession.config.cookie,
      secret: Warden::CookieSession.config.secret
    )
  end

  def encrypted_cookie
    @encrypted_cookie ||= Warden::CookieSession::Strategy.encrypted_cookie(cookies)
  end

  private

    def logger
      Warden::CookieSession.config.logger || Logger.new(nil)
    end

end

