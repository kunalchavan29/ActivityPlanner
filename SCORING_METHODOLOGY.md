# Scoring Methodology

Activity Planner calculates a suitability score between 0 and 100 for each activity and forecast day.

The score is based on weather conditions using weighted components.

## Activity Weights

| Weather factor | Skiing | Surfing | Outdoor | Indoor |
|---|---:|---:|---:|---:|
| Snowfall | 50% | — | — | — |
| Temperature | 25% | 25% | 35% | 30% |
| Wind | 25% | 45% | 20% | 20% |
| Rain probability | — | 15% | 30% | 40% |
| Sunshine | — | 15% | 15% | 10% |

## Scoring Approach

Each weather factor receives a score from 0 to 100.

- **Skiing:** Favours snowfall, suitable temperatures and lower wind.
- **Surfing:** Considers wind, temperature, rain probability and sunshine.
- **Outdoor sightseeing:** Favours comfortable temperatures, low rain probability, lower wind and sunshine.
- **Indoor sightseeing:** Favours rainy, uncomfortable or windy conditions and less sunshine.

The weighted average of the available weather factors produces the final score.

If a weather value is unavailable, its component is excluded and the remaining weights are adjusted proportionally.

## Score Interpretation

| Score | Rating |
|---|---|
| 80–100 | Excellent |
| 60–79 | Good |
| 40–59 | Moderate |
| 20–39 | Poor |
| 0–19 | Unsuitable |

## Weather Data Used

The scoring engine uses:

- Snowfall
- Maximum temperature
- Maximum wind speed
- Maximum precipitation probability
- Sunshine duration

The values are taken from the Open-Meteo daily forecast response.

## Important Note

These scores are heuristic estimates, not professional activity recommendations.

For example, surfing suitability does not include wave height, swell period or tides. Skiing suitability does not include actual snow depth or resort conditions.
