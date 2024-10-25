require 'rails_helper'

RSpec.describe ForecastApiClient do
  let(:api_client) { ForecastApiClient.new }
  let(:zipcode) { "44333" }

  let(:forecast_endpoint_base_url) { "#{ForecastApiClient::BASE_URL}/#{ForecastApiClient::EXTENDED_FORECAST_ENDPOINT}" }
  let(:json_success_body) {
    File.read(Rails.root.join("spec", "data", "forecast_api_client", "extended_forecast_success_body.json"))
  }
  let(:failure_body) {
    File.read(Rails.root.join("spec", "data", "forecast_api_client", "extended_forecast_bad_request_body.html"))
  }

  context "When a valid zipcode is given" do
    before :each do
      stub_request(:get, Regexp.new(forecast_endpoint_base_url))
        .to_return(status: 200, body: json_success_body)
    end

    it 'should return a Faraday::Response with the full json response body' do
      response = api_client.get_extended_forecast(zipcode)

      expect(response.body).to eq(json_success_body)
      expect(response.success?).to eq(true)
    end
  end

  context "When the request fails" do
    before :each do
      stub_request(:get, Regexp.new(forecast_endpoint_base_url))
        .to_return(status: 400, body: failure_body)
    end

    it 'should return a failed Faraday::Response' do
      response = api_client.get_extended_forecast(zipcode)

      expect(response.body).to eq(failure_body)
      expect(response.success?).to eq(false)
    end
  end

  context "#build_query_param_string" do
    before :each do
      api_client.instance_variable_set(:@api_key, 'fake-api-key')
    end
    context "when no additional parameters are added" do
      it 'should include api key, content type, and unit group in the uri' do
        actual_parameters = api_client.send(:build_query_param_string)
        expected_parameters = "unitGroup=us&key=fake-api-key&contentType=json"

        expect(actual_parameters).to eq(expected_parameters)
      end
    end

    context "when additional parameters are added" do
      it 'should include api key, content type, and unit group in the uri, and the new parameters' do
        key = "some-key"
        value = "some-value"

        actual_parameters = api_client.send(:build_query_param_string, additional_params: { key => value })
        expected_parameters = "unitGroup=us&key=fake-api-key&contentType=json&some-key=some-value"

        expect(actual_parameters).to eq(expected_parameters)
      end
    end
  end
end
