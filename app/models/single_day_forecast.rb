class SingleDayForecast
  attr_reader :current_temp, :date, :min_temp, :max_temp, :conditions_icon_name

  # Converts API Conditions to font-awesome classes for icons
  CONDITIONS_ICON_MAP = {
    "snow" => "fa-solid fa-cloud",
    "rain" => "fa-solid fa-cloud-rain",
    "fog" => "fa-solid fa-smog",
    "wind" => "fa-solid fa-wind",
    "cloudy" => "fa-solid fa-cloud",
    "partly-cloudy-day" => "fa-solid fa-cloud-sun",
    "partly-cloudy-night" => "fa-solid fa-cloud-moon",
    "clear-day" => "fa-solid fa-sun",
    "clear-night" => "fa-solid fa-moon"
  }

  def initialize(single_day_forecast:, current_temp: nil)
    @current_temp = current_temp
    @date = single_day_forecast["date"]
    @min_temp = single_day_forecast["minTemp"]
    @max_temp = single_day_forecast["maxTemp"]
    @conditions_icon_name = single_day_forecast["conditionsIcon"]
  end

  # Return first 3 letters of the day of the week
  def day_of_the_week
    Date.parse(date).strftime('%A').slice(0,3)
  end

  def conditions_icon_classes
    CONDITIONS_ICON_MAP[conditions_icon_name]
  end
end
