# frozen_string_literal: true
source 'https://rubygems.org'

group :development do
  gem 'rspec'
  gem 'rake'
  gem 'rdoc'
  gem 'json'
  gem 'simplecov' if RUBY_VERSION >= '2.7.'
  gem 'coveralls_reborn', :require => false if RUBY_VERSION >= '2.7.'
  gem 'webrick'
end

group :asciidoc do
  gem 'asciidoctor'
end

group :markdown do
  gem 'redcarpet'
  gem 'commonmarker'
end

group :textile do
  gem 'RedCloth'
end

group :server do
  gem 'rackup'
end

group :i18n do
  gem 'gettext'
end
