# Run locally

### Clone the repository

### Install dependencies
```shell
bundle install
```

### Set environment variables

create .env and set OPENWEATHER_API_KEY

## Run redis

```shell
redis-server
```

## Run serve

```shell
rails s
```

## Run tests

```shell
bundle exec rspec
```

# API endpoints

## GET /api/v1/popular_cities_data

**Response**

```
{
    "data": [
        {
            "coord": {
                "lon": -99.1332,
                "lat": 19.4326
            },
            "weather": [
                {
                    "id": 800,
                    "main": "Clear",
                    "description": "cielo claro",
                    "icon": "01n"
                }
            ],
            "base": "stations",
            "main": {
                "temp": 18.84,
                "feels_like": 18.09,
                "temp_min": 18.83,
                "temp_max": 18.94,
                "pressure": 1015,
                "humidity": 50,
                "sea_level": 1015,
                "grnd_level": 765
            },
            "visibility": 10000,
            "wind": {
                "speed": 3.09,
                "deg": 170
            },
            "clouds": {
                "all": 0
            },
            "dt": 1740982659,
            "sys": {
                "type": 2,
                "id": 47729,
                "country": "MX",
                "sunrise": 1741006466,
                "sunset": 1741048961
            },
            "timezone": -21600,
            "id": 22,
            "name": "Mexico City",
            "cod": 200,
            "slug": "ciudad-de-mexico",
            "city_slug": "ciudad-de-mexico",
            "display": "Ciudad de México",
            "ascii_display": "ciudad de mexico",
            "city_name": "Ciudad de México",
            "city_ascii_name": "ciudad de mexico",
            "state": "Distrito Federal",
            "country": "México",
            "lat": "19.4326077",
            "long": "-99.133208",
            "result_type": "city",
            "popularity": "1.0"
        },]...}
```

## GET /api/v1/forecast

**Parameters**

| Name | Required | Type | Description                                                                                                                                                         |
| -------------:|:--------:|:-------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|     `lat` | required | string  | Latitud.                                                                   |
| `lon` | required | string | Longitiud |

**Response**

```
{
    "data": [
        {
            "date": "2025-03-03",
            "temp_min": 16.24,
            "temp_max": 25.95,
            "condition": "Clouds",
            "icon": "03d"
        },
        {
            "date": "2025-03-04",
            "temp_min": 9.36,
            "temp_max": 22.01,
            "condition": "Clouds",
            "icon": "02n"
        },
        {
            "date": "2025-03-05",
            "temp_min": 8.1,
            "temp_max": 23.94,
            "condition": "Clear",
            "icon": "01n"
        },
        {
            "date": "2025-03-06",
            "temp_min": 14.32,
            "temp_max": 26.01,
            "condition": "Clouds",
            "icon": "04n"
        },
        {
            "date": "2025-03-07",
            "temp_min": 13.57,
            "temp_max": 24.63,
            "condition": "Clouds",
            "icon": "04n"
        },
        {
            "date": "2025-03-08",
            "temp_min": 7.86,
            "temp_max": 10.97,
            "condition": "Clear",
            "icon": "01n"
        }
    ]
}
```