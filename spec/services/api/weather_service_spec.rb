require 'rails_helper'

RSpec.describe Api::WeatherService do
  describe '#get_current_weather' do
    let(:service) { described_class.new }
    it 'returns current weather' do
      # TODO: Use VCR for a real call

      response = {
        "coord": { "lon": -106.0691, "lat": 28.633 },
        "weather": [ { "id": 804, "main": "Clouds", "description": "overcast clouds", "icon": "04d" } ],
        "base": "stations",
        "main": { "temp": 22.16, "feels_like": 20.77, "temp_min": 22.16, "temp_max": 22.16, "pressure": 1015, "humidity": 13, "sea_level": 1015, "grnd_level": 838 },
        "visibility": 10000,
        "wind": { "speed": 2.52, "deg": 154, "gust": 3.3 },
        "clouds": { "all": 100 },
        "dt": 1740851992,
        "sys": { "country": "MX", "sunrise": 1740835750, "sunset": 1740877456 },
        "timezone": -21600,
        "id": 4014338,
        "name": "Chihuahua City",
        "cod": 200 }

      mock_response_object = instance_double(
        HTTParty::Response,
        code: 200,
        body: response.to_json
      )

      expect(HTTParty).to receive(:get)
                         .with("https://api.openweathermap.org/data/2.5/weather", anything)
                         .and_return(mock_response_object)

      weather = service.get_current_weather(lat: 28.633, lon: -106.0691)

      expect(weather).to be_an(Hash)
      expect(weather['coord']['lat']).to eq(28.633)
      expect(weather['main']['temp']).to eq(22.16)
    end

    it 'handles API errors' do
      mock_error_response = instance_double(
        HTTParty::Response,
        code: 500,
        body: '{"error": "Server error"}'
      )

      expect(HTTParty).to receive(:get)
                          .with("https://api.openweathermap.org/data/2.5/weather", anything)
                          .and_return(mock_error_response)

      expect { service.get_current_weather(lat: 28.633, lon: -106.0691) }.to raise_error(/Server error:/)
    end
  end
end
