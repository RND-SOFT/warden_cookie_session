# Warden Cookie Session

Warden Cookie Session is a warden strategy to store auth in custom encrypted cookie(instead of rack:session).
The main puprpose to allow store authorization between multiple rails applications, without sharing `secret_key_base`.  


# Usage

Setup `Warden::CookieSession` in initializer and provide wrapper.

```ruby

Warden::CookieSession.configure do |config|
  config.cookie = Rails.application.secrets['shared_cookie']
  config.secret = Rails.application.secrets['shared_secret']

  config.wrapper = Warden::CookieSession::DefaultWrapper.new(User)
end
```

Default wrapper just fetch user from model:
```ruby
module Warden
  module CookieSession
    class DefaultWrapper

      def initialize(klass = nil)
        @klass = klass
      end

      def serialize_record(record)
        # like in https://github.com/plataformatec/devise/blob/master/lib/devise/models/authenticatable.rb
        [record.to_key, record.authenticatable_salt]
      end

      def fetch_record(key)
        @klass.find(key.first)
      end

      def validate_record(record, salt)
        # like in https://github.com/plataformatec/devise/blob/master/lib/devise/models/authenticatable.rb
        record if record && record.authenticatable_salt == salt
      end

    end
  end
end
```

# Advansed Usage

With `Warden::CookieSession` we can fetch user data remotly ex. from API:

```ruby

Warden::CookieSession.configure do |config|
  config.cookie = Rails.application.secrets['shared_cookie']
  config.secret = Rails.application.secrets['shared_secret']

    class RemoteWrapper
      def serialize_record(record)
        [record.to_key, record.authenticatable_salt]
      end

      def fetch_record(key)
        FetchRemoteUserAndSalt.run!(key)
      end

      def validate_record(record, salt)
        record if record && record.authenticatable_salt == salt
      end

    end

  config.wrapper = Warden::CookieSession::DefaultWrapper.new(User)
end


# Installation

It's a gem:
```bash
  gem install warden_cookie_session
```
There's also the wonders of [the Gemfile](http://bundler.io):
```ruby
  gem 'warden_cookie_session'
```