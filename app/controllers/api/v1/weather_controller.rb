module Api
  module V1
    class WeatherController < ApplicationController
      def popular_places_weather
        service = LocationWeatherService.new
        popular_cities = service.top_places_weather

        if popular_cities[:success]
          render json: { data: popular_cities[:data] }, status: :ok
        else
          render json: { error: popular_cities[:error] }, status: :unprocessable_entity
        end
      end

      def forecast
        service = LocationWeatherService.new
        result = service.city_forecast(lat: params[:lat], lon: params[:lon])

        if result[:success]
          render json: { data: result[:data] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end
    end
  end
end
