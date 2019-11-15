class Warden::CookieSession::EncryptedCookie

  attr_reader :store, :cookie, :secret, :encryptor

  def initialize(store:, cookie:, secret:)
    @store = store
    @cookie = cookie
    @secret = secret
    raise ArgumentError.new('secret must be 32 bytes') if @secret.length != 32

    @encryptor ||= ActiveSupport::MessageEncryptor.new(secret)
  end

  def get
    value = store[cookie]
    return nil unless value

    JSON(encryptor.decrypt_and_verify(value))
  end

  def put(data, domain)
    store[cookie] = {
      value:  encryptor.encrypt_and_sign(data.to_json),
      domain: domain,
      secure: false
    }
  end

  def clear(domain)
    store.delete(cookie, domain: domain)
  end

end

