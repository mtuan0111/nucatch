# NuCatch

**A fast-paced number matching game built with Flutter and BLoC architecture.**

NuCatch is an engaging mobile game where players match numbers under time pressure to achieve high scores. The game features difficulty settings, online leaderboards, sound effects, and a clean Material Design interface with bilingual support (English/Vietnamese).

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Build & Release](#build--release)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [Release History](#release-history)

---

## Features

### Core Gameplay
- **Number Matching Game**: Fast-paced gameplay with timer and lives system
- **Difficulty Levels**: Adjustable difficulty settings for personalized challenge
- **QR Code Scanning**: Scan QR codes for special interactions
- **Sound & Haptic Feedback**: Immersive audio and vibration effects
- **Animation Effects**: Smooth life counter animations and UI transitions

### Leaderboard System
- **Time-Based Rankings**: Filter leaderboards by Daily, Weekly, and All-Time periods
- **Online Score Storage**: Top scores stored in Firebase Firestore
- **Smart Caching**: 1-hour cache system for optimal performance
- **Local Fallback**: SQLite database backup when offline

### User Experience
- **Bilingual Support**: Full localization in English and Vietnamese
- **Responsive Design**: Optimized for phones and tablets
- **Material Design**: Clean gradient themes with custom UI components
- **Exit Confirmation**: Prevents accidental game exits
- **Settings Persistence**: Saves user preferences locally

### Technical Features
- **BLoC Architecture**: Strict separation of concerns with event-driven state management
- **Dual Storage**: Firebase (primary) + SQLite (offline backup)
- **Firebase Integration**: Cloud Firestore for online features
- **Cross-Platform**: Supports Android and iOS

---

## Screenshots

*(Add screenshots here when available)*

---

## Architecture

NuCatch follows **Flutter BLoC architecture** with strict separation of concerns:

```
lib/
├── blocs/              # Business Logic Components (State Management)
│   └── objects/
│       └── turnRecordedList/  # Leaderboard state management
├── models/             # Data models (Turn, Score, Settings, etc.)
├── services/           # Data access layer (Firebase + SQLite)
│   └── turn_services.dart     # Ranking data with caching
├── screens/            # UI screens
│   ├── menu_screens/   # Menu navigation screens
│   └── play_screen.dart       # Main gameplay screen
├── helpers/            # UI components and utilities
│   └── template.dart   # Reusable widgets (AnimatedButton, etc.)
├── localization/       # i18n support (ARB files)
├── navs/              # Navigation logic
└── main.dart          # App entry point
```

### Key Design Patterns
- **BLoC Pattern**: All business logic isolated in BLoCs, communication via events/states
- **Repository Pattern**: Services layer abstracts data sources (Firebase/SQLite)
- **Caching Strategy**: 1-hour cache with automatic invalidation on mutations
- **Enum-Based Type Safety**: `RankingPeriod`, `PreferencesKey` for consistency

---

## Installation

### Prerequisites
- **Flutter SDK**: 3.x or later
- **Dart SDK**: 3.x or later
- **Firebase Account**: For cloud features
- **Android Studio** / **Xcode**: For platform-specific builds

### Setup Steps

1. **Clone the repository**:
   ```bash
   git clone https://gitlab.com/mtuan0111/nucatch-with-bloc.git
   cd nucatch-with-bloc
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update `lib/firebase_options.dart` with your Firebase config

4. **Generate launcher icons**:
   ```bash
   dart run flutter_launcher_icons
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

---

## Usage

### Playing the Game
1. Launch the app and select difficulty level
2. Match numbers as they appear on screen
3. Complete rounds before time runs out
4. Track lives remaining with animated counter
5. Submit scores to online leaderboard

### Viewing Leaderboards
1. Navigate to **Top Score** screen from menu
2. Filter by **Daily**, **Weekly**, or **All-Time** tabs
3. Pull-to-refresh to clear cache and reload
4. View detailed score breakdowns

### Settings
- Adjust **difficulty level** (Easy/Medium/Hard)
- Toggle **sound effects** and **vibration**
- Change **language** (English/Vietnamese)

---

## Build & Release

### Android Build
```bash
flutter build appbundle --build-name=<VERSION> --build-number=<BUILD_NUM> --release
```

Example:
```bash
flutter build appbundle --build-name=2.3.2 --build-number=50 --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS Build
```bash
flutter build ios --build-name=<VERSION> --build-number=<BUILD_NUM> --release
```

Example:
```bash
flutter build ios --build-name=2.3.2 --build-number=54 --release
```

Then archive in Xcode for App Store submission.

### Icon Generation
```bash
dart run flutter_launcher_icons
```

---

## Project Structure

### Key Files
- **`lib/main.dart`**: App entry point, disables debug banner
- **`lib/firebase_options.dart`**: Firebase configuration
- **`pubspec.yaml`**: Dependencies and assets
- **`l10n.yaml`**: Localization configuration
- **`android/app/build.gradle`**: Android build settings
- **`ios/Runner.xcworkspace`**: iOS build workspace

### BLoC Components
- **`TurnRecordedListBloc`**: Manages ranking data with period-based filtering
- **`LoadDataByPeriod`**: Event for fetching daily/weekly/all-time scores
- **`RankingPeriod` enum**: Type-safe period selection (daily, weekly, all)

### Services
- **`TurnRecordedServices`**: Dual storage (Firebase + SQLite) with caching
- **`PreferencesKey`**: Constants for consistent field naming
- **Firebase caching**: 1-hour expiration, cleared on insert/update

### UI Components
- **`AnimatedButton`**: Custom tab buttons with gradient backgrounds
- **`RankingSortingWidget`**: Leaderboard display component
- **Localization**: `app_en.arb`, `app_vi.arb` for i18n

---

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: Follow commit message template in release notes
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open a merge request**

### Commit Message Template
```
[Builded] Version <VERSION> - <BUILD_NUMS> _ <FEATURE_DESCRIPTION>

**Store notices / What's new / Summary:**

- **English:**  
    - <English description>

- **Tiếng Việt:**  
    - <Vietnamese description>

Flutter build for Android
```flutter build appbundle --build-name=<VERSION> --build-number=<BUILD_NUM> --release```

Flutter build for iOS
```flutter build ios --build-name=<VERSION> --build-number=<BUILD_NUM> --release```
```

### Code Standards
- Follow **Flutter/Dart style guide**
- Use **BLoC architecture** for state management
- Add **localization** for new UI strings (English + Vietnamese)
- Write **unit tests** for business logic
- Update **README** for new features

---

## Release History

See full release history with detailed notes in [RELEASES.md](./RELEASES.md)

### Latest Releases

**Version 2.3.2** (Nov 23, 2025) - Android: 50, iOS: 54
- Implemented cache management for Firebase data
- Added refresh functionality for leaderboards

**Version 2.3.1** (Nov 23, 2025) - Android: 49, iOS: 53
- Leaderboard filtering by daily, weekly, and all-time periods
- Enhanced localization support

**Version 2.2.4** (Oct 23, 2025) - Android: 48, iOS: 52
- Application performance optimizations
- Improved stability

**Version 2.1.0** (Aug 12, 2025) - Android: 41, iOS: 45
- Added difficulty level settings

**Version 2.0.0** (Mar 11, 2025) - Android: 2.0.0-35, iOS: 2.0.0-36
- Major version release with core gameplay

---

## License

*(Add license information here)*

---

## Authors and Acknowledgment

**Development Team**: NuCatch Contributors  
**Firebase**: Backend infrastructure  
**Flutter Community**: Framework and packages

---

## Support

For issues, questions, or feature requests:
- **GitLab Issues**: [Report a bug or request feature](https://gitlab.com/mtuan0111/nucatch-with-bloc/-/issues)
- **Email**: *(Add support email)*

---

## Project Status

**Active Development** - Currently on version 2.3.2  
Latest features: Leaderboard period filtering, Firebase caching, improved responsiveness

---

## Roadmap

- [ ] Add multiplayer mode
- [ ] Implement achievements system
- [ ] Add more difficulty levels
- [ ] Enhance analytics and tracking
- [ ] Add social sharing features
- [ ] Implement push notifications

---
