# Jobber - Flutter Job Portal App

A comprehensive job portal application built with Flutter and Firebase, connecting job seekers with employers.

## Features

### For Job Seekers (Candidates)
- User registration and authentication
- Profile creation and management
- Job search and filtering
- Job application tracking
- Resume management

### For Employers
- Company registration and verification
- Job posting and management
- Applicant tracking and management
- Company profile management
- Analytics dashboard

### Admin Features
- User and employer management
- Job approval system
- Analytics and reporting
- System configuration

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **State Management**: Provider
- **Authentication**: Firebase Auth with Google Sign-In
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **Analytics**: Firebase Analytics
- **Monetization**: AdMob integration

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase account
- Android/iOS development environment

### Installation

1. Clone the repository
```bash
git clone https://github.com/technos52/jobber.git
cd jobber
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Add your `google-services.json` for Android
- Add your `GoogleService-Info.plist` for iOS
- Update Firebase configuration in `lib/firebase_options.dart`

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
├── services/                 # Business logic and API calls
├── models/                   # Data models
├── utils/                    # Utility functions
└── data/                     # Static data and constants
```

## Build for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.