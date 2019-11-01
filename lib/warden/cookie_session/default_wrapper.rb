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

