require 'rails_helper'

RSpec.describe Forecast do
  let(:forecast_endpoint_base_url) { "#{ForecastApiClient::BASE_URL}/#{ForecastApiClient::EXTENDED_FORECAST_ENDPOINT}" }
  let(:json_success_body) {
    File.read(Rails.root.join("spec", "data", "forecast_api_client", "extended_forecast_success_body.json"))
  }
  let(:failure_body) {
    File.read(Rails.root.join("spec", "data", "forecast_api_client", "extended_forecast_bad_request_body.html"))
  }

  context "When a valid zipcode is given" do
    let(:zipcode) { "94134" }
    let(:forecast) { Forecast.new(zipcode: zipcode) }
    let(:nine_digit_zip_forecast) { Forecast.new(zipcode: "94134-2345") }
    let(:invalid_extension_forecast) { Forecast.new(zipcode: "94134-2345") }
    let(:expected_cached_forecast) {
      {
        "currentTemp"=>55.3,
        "days"=> [
          { "conditionsIcon"=>"clear-day", "date"=>"2024-10-24", "maxTemp"=>74.9, "minTemp"=>52.8 },
          { "conditionsIcon"=>"partly-cloudy-day", "date"=>"2024-10-25", "maxTemp"=>74.9, "minTemp"=>54.1 },
          { "conditionsIcon"=>"partly-cloudy-day", "date"=>"2024-10-26", "maxTemp"=>72.1, "minTemp"=>53.0 },
          { "conditionsIcon"=>"rain", "date"=>"2024-10-27", "maxTemp"=>69.5, "minTemp"=>58.6 },
          { "conditionsIcon"=>"clear-day", "date"=>"2024-10-28", "maxTemp"=>66.5, "minTemp"=>55.1 },
          { "conditionsIcon"=>"clear-day", "date"=>"2024-10-29", "maxTemp"=>66.1, "minTemp"=>53.3 } ],
        "zipcode"=>"94134"
      }
    }

    before :each do
      stub_request(:get, Regexp.new(forecast_endpoint_base_url))
        .to_return(status: 200, body: json_success_body)
    end

    describe "#get_forecast" do
      it 'should cache a given forecast if it\'s already been cached' do
        # key for zipcode should not be present
        cache_object = Kredis.json zipcode
        expect(cache_object.exists?).to eq(false)

        forecast  # instantiate the forecast (let lazily loads)
        expect(cache_object.exists?).to eq(true)
        expect(cache_object.value).to eq(expected_cached_forecast)
      end

      it 'should retreive the forecast from the cache if it already exists' do
        redis_connection = Kredis.redis
        expect(forecast.returned_from_cache).to eq(false)   # instantiates forecast and populate the cache

        duplicate_forecast = Forecast.new(zipcode: zipcode)
        expect(duplicate_forecast.returned_from_cache).to eq(true)
      end

      it 'should retreive a fresh forecast if the cache expires' do
        short_forecast = Forecast.new(zipcode: zipcode, cache_expiration_time: 1.seconds)
        expect(short_forecast.returned_from_cache).to eq(false)
      end
    end

    describe "#extract_forecast_data" do
      it 'should extract the current temperature' do
        expect(forecast.current_temp).to eq(55.3)   # note: 55.3 is taken from extended_forecast_success_body.json
      end

      it 'should extract the extended forecast' do
        single_day_forecast = forecast.extended_forecast.second

        expect(forecast.extended_forecast.size).to eq(Forecast::DAYS_IN_EXTENDED_FORECAST + 1)   # today + 5 days into the future
        expect(forecast.extended_forecast.first.class).to eq(SingleDayForecast)

        # note: see extended_forecast_success_body.json
        expect(single_day_forecast.date).to eq('2024-10-25')
        expect(single_day_forecast.min_temp).to eq(54.1)
        expect(single_day_forecast.max_temp).to eq(74.9)
        expect(single_day_forecast.conditions_icon_classes).to eq("fa-solid fa-cloud-sun")
      end
    end

    describe "#invalid?" do
      it 'should return false if the forecast has a 5 digit zipcode' do
        expect(forecast.invalid?). to eq(false)
      end

      it 'should return false if the forecast has a 9 digit zipcode' do
        expect(nine_digit_zip_forecast.invalid?). to eq(false)
      end

      it 'should return false even if the 4 digit extension is invalid' do
        expect(invalid_extension_forecast.invalid?). to eq(false)
      end
    end

    describe "#valid?" do
      it 'should return false if the forecast doesn\'t have a zipcode' do
        forecast = Forecast.new(zipcode: "")

        expect(forecast.valid?). to eq(false)
      end

      it 'should return false if the forecast doesn\'t have a json_forecast' do
        forecast = Forecast.new(zipcode: "94134")
        allow(forecast).to receive(:json_forecast).and_return({})

        expect(forecast.valid?). to eq(false)
      end
    end
  end

  context "When an invalid zipcode is given" do
    before :each do
      stub_request(:get, Regexp.new(forecast_endpoint_base_url))
        .to_return(status: 400, body: failure_body)
    end

    describe "#invalid?" do
      it 'should return true if the forecast doesn\'t have a zipcode' do
        forecast = Forecast.new(zipcode: "")

        expect(forecast.invalid?). to eq(true)
      end

      it 'should return true if the forecast isn\'t 5 or 9 digits' do
        forecast = Forecast.new(zipcode: "1234")

        expect(forecast.invalid?). to eq(true)
      end

      it 'should return true if the forecast doesn\'t have a json_forecast' do
        forecast = Forecast.new(zipcode: "94134")
        allow(forecast).to receive(:json_forecast).and_return({})

        expect(forecast.invalid?). to eq(true)
      end
    end

    describe "#valid?" do
      it 'should return false if the forecast doesn\'t have a zipcode' do
        forecast = Forecast.new(zipcode: "")

        expect(forecast.valid?). to eq(false)
      end

      it 'should return false if the forecast doesn\'t have a json_forecast' do
        forecast = Forecast.new(zipcode: "94134")
        allow(forecast).to receive(:json_forecast).and_return({})

        expect(forecast.valid?). to eq(false)
      end
    end
  end
end
