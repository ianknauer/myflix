source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap_form'
gem 'bcrypt-ruby'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: false
gem 'slim'
gem 'unicorn'
gem 'newrelic_rpm'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'
gem 'figaro'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara-email'
end
