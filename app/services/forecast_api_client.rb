# API Docs: https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/
#
class ForecastApiClient
  BASE_URL = "https://weather.visualcrossing.com"
  EXTENDED_FORECAST_ENDPOINT = 'VisualCrossingWebServices/rest/services/timeline'

  class ApiError; end

  def initialize(api_key: nil)
    @api_key = api_key || Rails.application.credentials.visual_crossing_api_key
  end

  def get_extended_forecast(zipcode, additional_params: {})
    request_url = build_extended_forecast_url(zipcode, additional_params: additional_params)
    Faraday.get(request_url)
  end

  private
  attr_reader :api_key

  # Use Zipcode for the forecast, rather than address. We will be caching the result
  # for all users in the same zip code
  def build_extended_forecast_url(zipcode, additional_params: {})
    encoded_params = build_query_param_string(additional_params: additional_params)
    "#{BASE_URL}/#{EXTENDED_FORECAST_ENDPOINT}/#{zipcode}/?#{encoded_params}"
  end

  def build_query_param_string(additional_params: {})
    params = {
      "unitGroup" => "us",
      "key" => api_key,
      "contentType" => "json"
    }

    additional_params.each_pair do |key, value|
      params[key] = value
    end

    URI.encode_www_form(params)
  end
end