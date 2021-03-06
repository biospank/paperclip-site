source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bootstrap-sass'

gem "slim-rails"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'activerecord-tableless'
# gem 'compass-rails', '~> 2.0.alpha.0'
gem 'figaro'
gem 'devise'
gem 'font-awesome-sass', '~> 4.1.0'
# gem 'gibbon'
# gem 'google_drive'
gem 'high_voltage'
#gem 'simple_form'

gem 'paypal-sdk-rest', '~> 0.7.2'

gem 'pundit'

gem 'kramdown', '~> 1.4.0'

gem 'forem', :github => "radar/forem", :branch => "rails4"
gem 'forem-bootstrap', github: "radar/forem-bootstrap"
gem 'forem-redcarpet', github: "radar/forem-redcarpet"
gem 'gemoji'
#requiring 'emoji/railtie' is deprecated. Please manually add Emoji.images_path to your config.assets.paths.

gem 'kaminari', '0.15.1'

group :development do
  gem 'better_errors'
  gem 'pry-rails'
  gem 'byebug', '~> 3.5.1'
#  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
# install mailcatcher
# gem install mailcatcher
# configure development environment
# config.action_mailer.delivery_method = :smtp
# config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
end

group :development, :test do
  gem "rspec-rails", ">= 3.0.0"
  gem "factory_girl_rails", "~> 4.4.1"
end

group :test do
  gem "faker"
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver"
end

group :production do
  gem 'pg'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
