module Api
  class PlacesService < BaseService
    BASE_URL = 'https://search.reservamos.mx/api/v2/places'

    def get_place(city)
      url = "#{BASE_URL}"
      response = HTTParty.get(url, query: {
        q: city
      })

      places = handle_response(response)
      places.select { |place| place["result_type"] == "city" }
    end

    def popular_places
      url = "#{BASE_URL}"
      response = HTTParty.get(url)

      places = handle_response(response)
      cities = places.select { |place| place["result_type"] == "city" }
      cities.sort_by { |city| -city["popularity"].to_f }.first(10)
    end
  end
end