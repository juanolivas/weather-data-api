module Api
  class WeatherService < BaseService
    BASE_URL = 'https://api.openweathermap.org/data/2.5'
    API_KEY = ENV['OPENWEATHER_API_KEY']

    def get_current_weather(lat: nil, lon: nil)
      url = "#{BASE_URL}/weather"
      response = HTTParty.get(url, query: {
        lat: lat,
        lon: lon,
        appid: API_KEY,
        units: 'metric'
      })

      handle_response(response)
    end

    def get_weather(lat: nil, lon: nil)
      url = "#{BASE_URL}/forecast"
      
      response = HTTParty.get(url, query: {
        lat: lat,
        lon: lon,
        appid: API_KEY,
        units: 'metric'
      })

      handle_response(response)
    end
  end
end