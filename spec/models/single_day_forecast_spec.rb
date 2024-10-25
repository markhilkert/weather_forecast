require 'rails_helper'

RSpec.describe SingleDayForecast do
  let(:forecast_json) {
    { "date"=>"2024-10-25", "minTemp"=>53.3, "maxTemp"=>66.1, "conditionsIcon"=>"clear-day" }
  }
  let(:single_day_forecast) { SingleDayForecast.new(single_day_forecast: forecast_json) }

  describe "#day_of_the_week" do
    it 'should return the three-letter day of the week' do
      expect(single_day_forecast.day_of_the_week).to eq("Fri")
    end
  end

  describe "#conditions_icon_classes" do
    it 'should return the font-awesome classes for the expected conditions' do
      expect(single_day_forecast.conditions_icon_classes).to eq("fa-solid fa-sun")
    end
  end
end
