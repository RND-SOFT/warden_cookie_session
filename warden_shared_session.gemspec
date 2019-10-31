$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'warden/shared_session/version'

Gem::Specification.new 'warden_shared_session' do |spec|
  spec.version       = ENV['BUILDVERSION'].to_i > 0 ? "#{Warden::SharedSession::VERSION}.#{ENV['BUILDVERSION'].to_i}" : Warden::SharedSession::VERSION
  spec.authors       = ['Samoilenko Yuri']
  spec.email         = ['kinnalru@gmail.com']
  spec.description   = spec.summary = '!!!!'
  spec.homepage      = 'https://github.com/RnD-Soft/timeouter'
  spec.license       = 'MIT'

  spec.files         = %w[lib/warden_shared_session.rb
                          lib/warden/shared_session.rb
                          lib/warden/shared_session/version.rb
                          lib/warden/shared_session/configuration.rb
                          lib/warden/shared_session/encrypted_cookie.rb
                          lib/warden/shared_session/strategy.rb
                          README.md LICENSE].reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_development_dependency 'bundler', '~> 2.0', '>= 2.0.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'

  spec.add_runtime_dependency 'warden'
end

