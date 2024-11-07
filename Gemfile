source "https://rubygems.org"

# Backend and Rails
gem "rails", "~> 8.0.0"
gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "jbuilder"
gem "turbo-rails"

# Database
gem "kredis"
gem "redis"
gem "pg"

# Front End
gem "tailwindcss-rails"
gem "sass-rails"
gem "font-awesome-sass"

# Tools
gem "bootsnap", require: false
# gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "faraday"
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"   # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "dotenv"
end

group :development do
  gem "web-console"   # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "rack-mini-profiler"
  gem "awesome_print"
end

group :test do
  gem "rspec-rails"
  gem "webmock"
end
