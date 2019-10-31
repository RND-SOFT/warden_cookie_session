require 'warden/shared_session/encrypted_cookie'

class Warden::SharedSession::Strategy < ::Warden::Strategies::Base

  def valid?
    logger.debug { "Warden::SharedSession#valid?: #{cookies[Warden::SharedSession.config.cookie]}" }
    cookies[Warden::SharedSession.config.cookie]
  end

  def store?
    false
  end

  def authenticate!
    key, salt = encrypted_cookie.get
    logger.debug { "Warden::SharedSession#authenticate!: #{key} #{salt}" }
    user = Warden::SharedSession.config.serialize_from_cookie(key, salt)
    logger.debug { "Warden::SharedSession#authenticate!: result: #{user}" }
    success!(user) if user
  rescue StandardError => e
    logger.warn "Warden::SharedSession::Strategy failed: #{e}"
    logger.debug { e.backtrace }
  end

  def self.encrypted_cookie(cookies)
    Warden::SharedSession::EncryptedCookie.new(
      store:  cookies,
      cookie: Warden::SharedSession.config.cookie,
      secret: Warden::SharedSession.config.secret
    )
  end

  def encrypted_cookie
    @encrypted_cookie ||= Warden::SharedSession::Strategy.encrypted_cookie(cookies)
  end

  private

    def logger
      Warden::SharedSession.config.logger || Logger.new(nil)
    end

end

