require 'rails_helper'

RSpec.describe SingleDayForecast do
  let(:forecast_processor) { ForecastProcessor.new }
  let(:raw_forecast_body) {
    File.read(Rails.root.join("spec", "data", "forecast_api_client", "extended_forecast_success_body.json"))
  }
  let(:failed_forecast_body) {
    File.read(Rails.root.join("spec", "data", "forecast_api_client", "extended_forecast_bad_request_body.html"))
  }

  let(:processed_hash) {
    {
      "zipcode"=>"94134",
      "currentTemp"=>55.3,
      "days"=>[
        {"date"=>"2024-10-24", "minTemp"=>52.8, "maxTemp"=>74.9, "conditionsIcon"=>"clear-day"},
        {"date"=>"2024-10-25", "minTemp"=>54.1, "maxTemp"=>74.9, "conditionsIcon"=>"partly-cloudy-day"},
        {"date"=>"2024-10-26", "minTemp"=>53.0, "maxTemp"=>72.1, "conditionsIcon"=>"partly-cloudy-day"},
        {"date"=>"2024-10-27", "minTemp"=>58.6, "maxTemp"=>69.5, "conditionsIcon"=>"rain"},
        {"date"=>"2024-10-28", "minTemp"=>55.1, "maxTemp"=>66.5, "conditionsIcon"=>"clear-day"},
        {"date"=>"2024-10-29", "minTemp"=>53.3, "maxTemp"=>66.1, "conditionsIcon"=>"clear-day"}
      ]
    }
  }

  describe "#build_forecast" do
    it 'should extract the relevant data into a json-compatible hash' do
      response = double('response')
      allow(response).to receive(:success?).and_return(true)
      allow(response).to receive(:body).and_return(raw_forecast_body)

      forecast = forecast_processor.build_forecast(raw_forecast_response: response)
      expect(forecast).to eq(processed_hash)
    end
  end

  describe "#get_zipcode_from_address" do
    it 'should extract a 5 digit zipcode from a full address' do
      address = "324 Madison St., San Francisco CA 94134"
      result = forecast_processor.send(:get_zipcode_from_address, address)

      expect(result).to eq("94134")
    end

    it 'should extract a 9 digit zipcode from a full address' do
      address = "324 Madison St., San Francisco CA 94134-4132"
      result = forecast_processor.send(:get_zipcode_from_address, address)

      expect(result).to eq("94134-4132")
    end

    it 'should extract a 5 digit zipcode from an invalid 9 digit zipcode' do
      address = "324 Madison St., San Francisco CA 94134-41324"
      result = forecast_processor.send(:get_zipcode_from_address, address)

      expect(result).to eq("94134")
    end
  end
end