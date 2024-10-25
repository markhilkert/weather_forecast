class ForecastController < ApplicationController
  def show
    @forecast = Forecast.new(zipcode: forecast_params[:zipcode])
  end

  private
  def forecast_params
    params.require(:forecast).permit(:zipcode, :street_address)
  end
end
