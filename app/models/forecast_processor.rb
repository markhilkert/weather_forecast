# JSON Forecast Example
#
# {"zipcode"=>94134,
#  "currentTemp"=>54.3,
#  "days"=>
#    [{"date"=>"2024-10-22", "minTemp"=>53.3, "maxTemp"=>67.9, "conditionsIcon"=>"partly-cloudy-day"},
#     {"date"=>"2024-10-23", "minTemp"=>52.1, "maxTemp"=>72.9, "conditionsIcon"=>"partly-cloudy-day"},
#     {"date"=>"2024-10-24", "minTemp"=>54.9, "maxTemp"=>74.9, "conditionsIcon"=>"clear-day"}},
#     {"date"=>"2024-10-25", "minTemp"=>55.8, "maxTemp"=>74.2, "conditionsIcon"=>"clear-day"}},
#     {"date"=>"2024-10-26", "minTemp"=>55.1, "maxTemp"=>72.4, "conditionsIcon"=>"partly-cloudy-day"},
#     {"date"=>"2024-10-27", "minTemp"=>57.3, "maxTemp"=>61.6, "conditionsIcon"=>"partly-cloudy-day"}]}
class ForecastProcessor
  # Matches 5 or 9 digit zipcodes (e.g., 94134 or 94134-2345).
  # If four digits do not trail the hyphen, returns only the first 5 digits
  USA_ZIPCODE_REGEX = /\b\d{5}(-\d{4})?\b/
  DAYS_IN_EXTENDED_FORECAST = 5

  def build_forecast(raw_forecast_response:)
    return {} unless raw_forecast_response.success?

    json_raw_forecast = JSON.parse(raw_forecast_response.body)
    zipcode = get_zipcode_from_address(json_raw_forecast["address"])

    forecast = {
      "zipcode" => zipcode,
      "currentTemp" => json_raw_forecast.dig("currentConditions", "temp"),
      "days" => []
    }

    json_raw_forecast.dig("days").each_with_index do |day, index|
      break if index > DAYS_IN_EXTENDED_FORECAST
      forecast["days"] << {
        "date" => day["datetime"],
        "minTemp" => day["tempmin"],
        "maxTemp" => day["tempmax"],
        "conditionsIcon" => day["icon"]
      }
    end

    forecast
  end

  private
  def get_zipcode_from_address(address)
    address.try(:[], USA_ZIPCODE_REGEX)
  end
end
