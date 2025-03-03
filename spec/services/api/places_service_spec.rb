require 'rails_helper'

RSpec.describe Api::PlacesService do
  describe '#get_place' do
    let(:service) { described_class.new }

    it 'returns only cities' do
      # TODO: Use VCR for a real call

      response = [
        {
            "id": 141,
            "slug": "chihuahua",
            "city_slug": "chihuahua",
            "display": "Chihuahua",
            "ascii_display": "chihuahua",
            "city_name": "Chihuahua",
            "city_ascii_name": "chihuahua",
            "state": "Chihuahua",
            "country": "México",
            "lat": "28.6329957",
            "long": "-106.0691004",
            "result_type": "city",
            "popularity": "0.0742471115600732",
            "sort_criteria": 0.6296988446240293
        },
        {
            "id": 8912,
            "slug": "cuu",
            "city_slug": "chihuahua",
            "display": "General R Fierro Villalobos Intl",
            "ascii_display": "General R Fierro Villalobos Intl",
            "city_name": "Chihuahua",
            "city_ascii_name": "chihuahua",
            "state": "Chihuahua",
            "country": "México",
            "lat": "28.702875",
            "long": "-105.964567",
            "result_type": "airport",
            "popularity": "0.011137066734010980",
            "sort_criteria": 0.6044548266936044
        },
        {
            "id": 10443,
            "slug": "t-chihuahua",
            "city_slug": "chihuahua",
            "display": "Allende",
            "ascii_display": "allende",
            "city_name": "Chihuahua",
            "city_ascii_name": "chihuahua",
            "state": "Chihuahua",
            "country": "México",
            "lat": "28.624901306925093",
            "long": "-106.08707624433595",
            "result_type": "terminal",
            "popularity": "0.011137066734010980",
            "sort_criteria": 0.6044548266936044
        },
        {
            "id": 11968,
            "slug": "chihuahua-oa",
            "city_slug": "chihuahua-oa",
            "display": "Chihuahua",
            "ascii_display": "chihuahua",
            "city_name": "Chihuahua",
            "city_ascii_name": "chihuahua",
            "state": "Oaxaca",
            "country": "México",
            "lat": "17.078161",
            "long": "-96.7369804",
            "result_type": "city",
            "popularity": "0",
            "sort_criteria": 0.6
        } ]

      mock_response_object = instance_double(
        HTTParty::Response,
        code: 200,
        body: response.to_json
      )

      expect(HTTParty).to receive(:get)
                         .with("https://search.reservamos.mx/api/v2/places", anything)
                         .and_return(mock_response_object)

      results = service.get_place("Chihuahua")

      expect(results).to be_an(Array)
      expect(results.length).to eq(2)
    end

    it 'handles API errors' do
      mock_error_response = instance_double(
        HTTParty::Response,
        code: 500,
        body: '{"error": "Server error"}'
      )

      expect(HTTParty).to receive(:get)
                          .with("https://search.reservamos.mx/api/v2/places", anything)
                          .and_return(mock_error_response)

      expect { service.get_place("Chihuahua") }.to raise_error(/Server error:/)
    end
  end
end
