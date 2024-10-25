# README

weather_forecast is a simple app to check the weather forecast in your area.
The backend is built with Ruby on Rails, and the frontend uses [Tailwind CSS](https://tailwindcss.com/).

The weather forecast are sourced from [Visual Crossing's weather API](https://www.visualcrossing.com/weather-api).
weather_forecast runs on the free tier, so at maximum it can handle 1000 requests per day.




Things you may want to cover:

* Ruby version: 3.3.5

* System dependencies
  * Redis or Valkey

* Configuration

* Database creation
  * Note here that we'll use the same DB for test and development, since all use for time-limited caching and will not remain permanently

* Database initialization

* How to run the test suite
  * bundle exec rspec

* Running locally: `bin/dev`
  * Secrets (API Key)
