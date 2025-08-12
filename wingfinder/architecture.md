# WingFinder Flight Search App - Architecture

## Overview
WingFinder is a Flutter app designed to find the cheapest flights from Japan to Europe, including budget options, premium deals, and advanced booking strategies.

## Core Features
- **Budget Flight Search**: Economy flights under $399 one-way, $650 round-trip
- **Premium Flight Search**: Business ($1400), First Class, and Private Jet deals  
- **Advanced Strategies**: Hidden city routing, mistake fares, multi-segment bookings
- **Smart Filters**: Visa-free destinations, direct flights, specific airlines
- **Real-time Alerts**: Price drops, mistake fares, premium deals under thresholds

## Architecture

### Data Layer
- `models/flight.dart`: Flight data model with pricing, routing, and booking details
- `data/airports.dart`: Japanese and European airport definitions
- `data/mock_flights.dart`: Sample flight data with realistic pricing and routes

### UI Layer
- `screens/home_page.dart`: Main app with tab navigation
- `screens/budget_flights_tab.dart`: Economy flight search interface
- `screens/premium_flights_tab.dart`: Business/First/Private jet deals
- `widgets/flight_card.dart`: Reusable flight display component
- `widgets/search_filters.dart`: Advanced search and filtering options

### Theme & Design
- Aviation-inspired blue/green/orange color palette
- Material Design 3 with modern card-based layouts
- Responsive design with clear visual hierarchy
- Alert highlighting for special deals and mistake fares

## Implementation Strategy
1. Mock data simulation for realistic flight scenarios
2. Local storage ready for user preferences and saved searches
3. URL launcher integration for direct booking links
4. Extensible architecture for real flight API integration
5. Filter system supporting complex search criteria

## Key Features Implemented
- ✅ Japan to Europe route coverage (5 Japanese + 20 European airports)
- ✅ Budget airline tracking (Scoot, AirAsia X, Ryanair, etc.)
- ✅ Premium airline coverage (LOT, Turkish, Qatar, Lufthansa, etc.)
- ✅ Hidden city and multi-segment routing strategies
- ✅ Mistake fare and deal alerts
- ✅ Visa-free destination filtering
- ✅ Direct booking link integration

## Future Enhancements
- Real-time flight API integration
- Push notifications for price alerts
- Historical price tracking and predictions
- Social sharing of great deals
- Advanced routing algorithms