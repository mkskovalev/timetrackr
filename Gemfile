source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "7.1.2"

gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "devise", "~> 4.9"
gem 'inline_svg'
gem 'groupdate'
gem 'acts_as_list'
gem 'sitemap_generator'
gem 'ransack'
gem 'pagy'
gem 'telegram-bot-ruby'
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-scheduler'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.1.0'
  gem 'factory_bot_rails'
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'shoulda-matchers', '~> 6.0'
  gem 'warden', require: false
  gem 'database_cleaner-active_record'
end
