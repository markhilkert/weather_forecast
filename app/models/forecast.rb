class Forecast
  attr_reader :zipcode, :current_temp, :extended_forecast, :current_conditions_icon_classes,
              :returned_from_cache, :cache_expiration

  CACHE_EXPIRATION_TIME = 30.minutes
  DAYS_IN_EXTENDED_FORECAST = 5

  def initialize(zipcode:, cache_expiration_time: nil)
    @cache_expiration = cache_expiration_time || CACHE_EXPIRATION_TIME
    @zipcode = zipcode
    @returned_from_cache = false
    @json_forecast = get_forecast
    extract_forecast_data
  end

  def invalid?
    json_forecast.empty? || zipcode.blank?
  end

  def valid?
    json_forecast.present? && zipcode.match?(ForecastProcessor::USA_ZIPCODE_REGEX)
  end

  private
  attr_reader :json_forecast

  # 1. Check if forecast is already in redis, if so, return
  # 2. If not cached, get a fresh forecast from the api
  # 3. Set the forecast in redis and in memory
  def get_forecast
    return {} if zipcode.blank?

    cached_forecast = Kredis.json zipcode

    if cached_forecast.exists?
      @returned_from_cache = true
    else
      cache_forecast(kredis_object: cached_forecast, json_forecast: create_fresh_forecast)
    end

    cached_forecast.value
  end

  def cache_forecast(kredis_object:, json_forecast:)
    forecast = Kredis.json zipcode, expires_in: CACHE_EXPIRATION_TIME
    forecast.value = json_forecast
  end

  def create_fresh_forecast
    api_client = ForecastApiClient.new
    forecast_processor = ForecastProcessor.new
    raw_forecast_request = api_client.get_extended_forecast(zipcode)

    if raw_forecast_request.success?
      forecast_processor.build_forecast(raw_forecast_response: raw_forecast_request)
    else
      {}
    end
  end

  def extract_forecast_data
    return if json_forecast.blank?

    @current_temp = json_forecast["currentTemp"]
    @extended_forecast = json_forecast["days"].map do |single_day_json_forecast|
      SingleDayForecast.new(single_day_forecast: single_day_json_forecast)
    end
    @current_conditions_icon_classes = get_todays_forecast.conditions_icon_classes
  end

  def get_todays_forecast
    target_date = DateTime.now.new_offset(0).to_date.to_s   # new_offset(0) converts DateTime to UTC
    extended_forecast.find { |single_day_forecast| single_day_forecast.date == target_date }
  end
end