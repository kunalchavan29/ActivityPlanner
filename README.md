# Activity Planner

Activity Planner is an iOS app that helps users identify suitable activities based on the weather forecast for the next 7 days.

Users can search for a city and view suitability scores for:

- Skiing
- Surfing
- Outdoor sightseeing
- Indoor sightseeing

## Tech Stack

- Swift and SwiftUI
- MVVM and layered architecture
- Swift Concurrency (`async/await`)
- Observation (`@Observable`)
- URLSession
- UserDefaults
- XCTest

## Weather Data

Weather and city information are provided by [Open-Meteo](https://open-meteo.com/).

No API key or backend is required.

## Run the App

1. Clone the repository.
2. Open the `.xcodeproj` file in Xcode.
3. Select an iOS simulator.
4. Build and run using `Cmd + R`.

## Run Tests

Open the project in Xcode and run the test suite using `Cmd + U`.

## Documentation

- [Architecture](ARCHITECTURE.md)
- [Scoring Methodology](SCORING_METHODOLOGY.md)
- [Assumptions](ASSUMPTIONS.md)
- [AI Usage](AI_USAGE.md)

## Limitations

Activity scores are estimates based on available weather data. They do not replace actual ski resort, surf, or local activity conditions.
