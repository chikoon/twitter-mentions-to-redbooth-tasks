source 'https://rubygems.org'

gem 'rails', '3.2.19'
gem 'sass', '3.2.13'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
end


gem 'rails_config'
gem 'oauth', '~> 0.4.7'
gem 'twitter'
gem 'rest-client'
gem 'thin'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

#gem 'jquery-rails'

gem 'pry-rails'

group :test, :development do
	gem 'rspec-rails'
	gem 'factory_girl_rails'
	gem 'byebug'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# Heroku says to load this:
ruby '2.0.0'
