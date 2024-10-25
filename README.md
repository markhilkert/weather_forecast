# README

## Background

weather_forecast is a simple app to check the weather forecast in your area.
The backend is built with [Ruby on Rails](https://github.com/rails/rails) and [valkey](https://github.com/valkey-io/valkey) (redis alternative), 
and the frontend uses [Tailwind CSS](https://tailwindcss.com/)
and [turbo](https://github.com/hotwired/turbo-rails).

The weather forecast are sourced from [Visual Crossing's weather API](https://www.visualcrossing.com/weather-api).
weather_forecast runs on the free tier, so at maximum it can handle 1000 requests per day.

The application prioritizes simplicity, accepting just a street address and zipcode 
(only the zipcode is used to generate a weather forecast):

![weather_forecast_homepage](https://github.com/user-attachments/assets/6589fe95-55c9-40b3-8399-df478e04e639)

After the user submits their address, a simple forecast is displayed. The user will see

1. The current temperature in Fahrenheit the requested zipcode
2. The current weather conditions (via an icon)
3. A 6 day forecast of weather conditions, low temperature, high temperature. Of the extended forecast, the first is for the current day, followed by a 5 day extended forecast.

![example_forecast](https://github.com/user-attachments/assets/2e1a98d0-c560-41f1-b43d-0589627c9c1e)

## Dependencies

To run this application, the user must have Ruby 3.3.5 installed and Valkey (or redis) running.

## Getting Started

After confirming that Ruby 3.3.5 is installed and cloning the repo, ensure that valkey or redis is running.

In the application's root directory, run this command to add a .env file with Redis's information 
(check to confirm that the url and port match your system). See below for installing valkey on
macOS if needed. Valkey and redis APIs are compatible, so redis will work if you use its url and port.

```shell
echo 'VALKEY_URL="redis://127.0.0.1:6379/0"' > .env
```

Please note that because valkey data is intended to be ephemeral, we are not creating a separate
database for tests and production.

If valkey or redis is running properly, the test suite will pass:

```shell
bundle exec rspec
```

Run the app locally using the development server:

```shell
bin/dev
```

After starting the rails server, you will be able to access the application from your browser at `http://localhost:3000/`

### Secrets

If this project was shared with you by the developer, you can put the tarball provided 
(`weather_forecast_master_key.tar.gz`) in your root directory and extract it. In MacOS,
run `tar xvf weather_forecast_master_key.tar.gz`. This should extract `master.key` into
`config/`

Alternatively, you can sign up for a free account at [Visual Crossing](https://www.visualcrossing.com/weather-api).
You can get a free API key with a 1000 query limit without providing a credit card.

If you get your own key, add it to rails credential by running the following command:

```shell
bin/rails credentials:edit
```

And adding the API key:

```yml
```

### MacOS valkey installation

If you have homebrew installed, you can get valkey up and running by running the following commands:

```shell
brew install valkey
brew services start valkey
```

