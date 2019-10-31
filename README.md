
```ruby

Warden::SharedSession.configure do |config|
  config.cookie = Rails.application.secrets['shared_cookie']
  config.secret = Rails.application.secrets['shared_secret']

  config.serialize_from_cookie = ->(key, salt) {
    # like in https://github.com/plataformatec/devise/blob/master/lib/devise/models/authenticatable.rb
    record = User::FindOrCreate.run!(uid: key.first.to_s) rescue nil
    record if record && record.authenticatable_salt == salt
  }

  config.serialize_into_cookie = ->(record) {
    # like in https://github.com/plataformatec/devise/blob/master/lib/devise/models/authenticatable.rb
    [[record.uid], record.authenticatable_salt]
  }
end
```