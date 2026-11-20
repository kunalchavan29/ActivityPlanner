# Assumptions

The following assumptions were made while building Activity Planner.

1. The app displays the next 7 days of weather forecast for the selected city.
2. City search uses the Open-Meteo Geocoding API.
3. Forecast data uses the selected location's timezone, as provided by the API.
4. Weather suitability is calculated using predefined thresholds and weights.
5. The same scoring rules are applied to all locations.
6. Missing weather values are excluded from the weighted calculation.
7. Recent searches are limited to 10 cities.
8. Forecast responses are cached in memory for 30 minutes.
9. An internet connection is required to fetch city and forecast data.

## Scope and Limitations

- Scores are estimates based on general weather conditions.
- No user-specific preferences are considered.
- Surfing scores do not include wave or tide information.
- Skiing scores do not include resort-specific conditions.
- Weather forecasts may change and should not be treated as guaranteed conditions.
