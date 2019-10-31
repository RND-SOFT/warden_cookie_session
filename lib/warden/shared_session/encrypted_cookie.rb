class Warden::SharedSession::EncryptedCookie

  attr_reader :store, :cookie, :secret, :encryptor

  def initialize(store:, cookie:, secret:)
    @store = store
    @cookie = cookie
    @secret = secret

    @encryptor ||= ActiveSupport::MessageEncryptor.new(secret)
  end

  def get
    value = store[cookie]
    return nil unless value

    JSON(encryptor.decrypt_and_verify(value))
  end

  def put(data)
    store[cookie] = encryptor.encrypt_and_sign(data.to_json)
  end

  def clear
    store.delete(cookie)
  end

end

