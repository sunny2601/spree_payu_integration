# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_payu_integration'
  s.version     = '2.3.0'
  s.summary     = 'Spree integration with PayU.'
  s.description = 'Spree integration with PayU.'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Sebastian Sito'
  s.email     = 'hi@netguru.co'
  s.homepage  = 'https://github.com/netguru/spree_payu_integration'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '= 2.4.7.beta'
  s.add_dependency 'openpayu', '~> 0.1.2'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
