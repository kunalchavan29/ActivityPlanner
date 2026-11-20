# Architecture

Activity Planner uses a layered architecture with MVVM for the presentation layer.

The aim is to keep UI, business logic, and data handling separate and maintainable.

## Main Layers

### Presentation
- SwiftUI views
- ViewModels using `@Observable`
- Handles UI state and user interactions

### Domain
- Models such as `City` and `DailyForecast`
- Service and repository protocols
- Activity suitability scoring logic

### Data
- Open-Meteo API integration
- DTOs and domain model mapping
- Repository implementations
- Recent search persistence

## Data Flow

1. The user searches for a city.
2. The search service fetches matching cities.
3. The user selects a city.
4. The forecast service fetches its weather forecast.
5. API responses are mapped to domain models.
6. The scoring engine calculates activity suitability.
7. The UI displays the results.

## Key Decisions

- **Protocol-based dependencies:** Makes services easier to test and replace.
- **Dependency injection:** Dependencies are provided through `AppContainer`.
- **Swift Concurrency:** Uses `async/await` for asynchronous operations.
- **Debouncing and cancellation:** Prevents unnecessary city search requests.
- **Forecast caching:** Keeps forecast results in memory for 30 minutes.
- **Recent searches:** Stores up to 10 cities using UserDefaults and an in-memory copy.

## Testing

XCTest is used to verify business logic, data handling, and ViewModel behaviour.
