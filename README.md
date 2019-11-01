
```ruby

Warden::CookieSession.configure do |config|
  config.cookie = Rails.application.secrets['shared_cookie']
  config.secret = Rails.application.secrets['shared_secret']

  config.wrapper = Warden::CookieSession::DefaultWrapper.new(User)
end
```