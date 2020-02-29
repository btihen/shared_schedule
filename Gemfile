source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

###########
# MY GEMS #
###########

# BACK END
##########
# time of day - with timezones and localizations
gem 'tod'

gem 'devise' # , '~> 4.7'  # rails 6.0 requires 4.7.0 or greater

# FRONT END
###########
gem 'bulma-rails'
gem 'bulma-extensions-rails'

# DEV / TESTS
#############
group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'

  gem 'factory_bot_rails'
  gem 'faker'

  # gem 'rspec-rails'
  gem 'rspec-rails', '~> 4.0.0.beta'

  # lets spring work with rspec
  gem 'spring-commands-rspec'
end

group :test do
  # allow cucumber to do JavaScript testing too
  gem 'selenium-webdriver'
  # https://mikecoutermarsh.com/rails-capybara-selenium-chrome-driver-setup/
  # download chromedriver from: http://chromedriver.chromium.org/
  # or use brew cask install chromedriver
  # finally in features/env.rb - switch the browser to :chrome
  # gem 'chromedriver-helper'
  gem 'webdrivers' # , '~> 3.0'

  # easier tests (inside rspec)
  gem 'shoulda-matchers' # , '~> 3.1'

  # cucumber can test emails (rspec too?)
  gem 'email_spec'

  # code coverage
  gem 'simplecov'
  gem 'simplecov-console'
end

group :development do
  # security check gems
  # https://www.occamslabs.com/blog/securing-your-ruby-and-rails-codebase
  # http://fretless.com/blog/static-security-analysis-of-your-ruby-and-rails-applications/
  gem 'brakeman', require: false
  # brakeman
  # or the opensource version
  # gem 'railroader', :require => false
  # railroader

  # code smells & churn
  gem 'rubycritic', require: false
  # rubycritic app

  gem 'bundler-audit', require: false
  # bundle audit check --update

  # also useful for sinatra, etc. (checks CVE-2013-6421 records)
  gem 'dawnscanner', :require=>false
  # bundle install
  # dawn --console .

  # rubocop (security checks with: )
  gem 'rubocop', require: false
  # rubocop --only Security
  # or
  # rubocop -c .rubocop_security.yml

  # capture emails in the web browser
  # gem 'letter_opener'
end
