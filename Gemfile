source 'https://rubygems.org'
ruby '2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use Bootstrap for styling the application
gem 'bootstrap-sass', '~> 3.3.4'
# Use font-awesome for icons
gem 'font-awesome-rails', '~> 4.7.0'
# Used for web scraping
gem 'nokogiri', '~> 1.6.6.2'
# Compares strings to see how similar they are to each other
gem 'similar_text'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use geocoder gym for getting neighborhood coordinates
gem 'geocoder'
# Use the httparty gem for doing rest calls with
gem 'httparty'

gem 'fuzzily', '~> 0.3.3'
gem 'select2-rails', '~> 4.0.3'

# Add routes to frontend of the app
gem 'js-routes'

# Assists with querying the socrata apis
gem 'soda-ruby', require: 'soda'

# Allows us to easily parse xlsx files
gem 'roo', '~> 2.5.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Deploy to a passenger server
gem "passenger", "5.0.25", require: "phusion_passenger/rack_handler"

# Encodes polylines for us
gem "polylines", '~> 0.3.0'

# Generate PDF's
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary', '~> 0.12.3.1'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Debugging Gem
  gem 'pry'
  gem 'pry-remote'
end

group :test do
  gem 'rspec-rails', '~> 3.6.0'
end

group :production do
  gem 'pg'
  gem 'wkhtmltopdf-heroku', '~> 2.12.4.0'
end
