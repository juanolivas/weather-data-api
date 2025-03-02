class LocationWeatherService
  # Cambiar si es necesario
  CACHE_EXPIRY = 1800
  FORECAST_CACHE_EXPIRY = 3600

  def initialize
    @places_service = Api::PlacesService.new
    @weather_service = Api::WeatherService.new
    @redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/0')
  end
  
  def top_places_weather
    begin
      cached_result = @redis.get('top_places_weather')
      if cached_result
        data = JSON.parse(cached_result)
        return { success: true, data: data }
      end

      top_places = @places_service.popular_places
      top_places.each do |place|
        place.reverse_merge!(get_city_weather(place))
      end

      @redis.setex('top_places_weather', CACHE_EXPIRY, top_places.to_json)

      { success: true, data: top_places }
    rescue => e
      { success: false, data: [], error: e.message }
    end
  end

  def city_forecast(lat: nil, lon: nil)
    begin
      return { success: false, data: {}, error: "Latitud y longitud son requeridas" } if lat.nil? || lon.nil?

      cache_key = "forecast:#{lat}:#{lon}"

      cached_forecast = @redis.get(cache_key)
      if cached_forecast
        data = JSON.parse(cached_forecast)
        return { success: true, data: data }
      end

      data = @weather_service.get_weather(lat: lat, lon: lon)

      if data && !data[:error]

        five_days_data = process_forecast_data(data)
        @redis.setex(cache_key, FORECAST_CACHE_EXPIRY, five_days_data.to_json)
        return { success: true, data: five_days_data }
      else
        return { success: false, data: {}, error: forecast[:error] || "Error al obtener pronóstico" }
      end
    rescue => e
      { success: false, data: {}, error: e.message }
    end
  end

  private

  def get_city_weather(city)
    cache_key = "weather:#{city['lat']}:#{city['long']}"
    cached_weather = @redis.get(cache_key)
    return JSON.parse(cached_weather) if cached_weather

    city_weather = @weather_service.get_current_weather(
      lat: city['lat'],
      lon: city['long']
    )

    @redis.setex(cache_key, CACHE_EXPIRY, city_weather.to_json)

    city_weather
  end

  def process_forecast_data(data)
    daily_forecasts = {}
    data['list'].each do |forecast|
      date = Time.at(forecast['dt']).to_date
      day = date.strftime('%Y-%m-%d')
      if !daily_forecasts[day]
        daily_forecasts[day] = {
          date: date,
          temp_min: forecast['main']['temp_min'],
          temp_max: forecast['main']['temp_max'],
          condition: forecast['weather'][0]['main'],
          icon: forecast['weather'][0]['icon']
        }
      else
        daily_forecasts[day][:temp_min] = [daily_forecasts[day][:temp_min], forecast['main']['temp_min']].min
        daily_forecasts[day][:temp_max] = [daily_forecasts[day][:temp_max], forecast['main']['temp_max']].max
      end
    end

    result = daily_forecasts.values.sort_by { |f| f[:date] }
    return result
  end
end