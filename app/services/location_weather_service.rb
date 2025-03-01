class LocationWeatherService
  def initialize
    @places_service = Api::PlacesService.new
    @weather_service = Api::WeatherService.new
  end
  
  def top_places_weather
    top_places = @places_service.popular_places
    top_places.each do |place|
      city_weather = @weather_service.get_current_weather(lat: place['lat'], lon: place['long'])
      place.reverse_merge!(city_weather)
    end
  end
end