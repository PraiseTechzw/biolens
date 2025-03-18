# Afro-Dip: AI-Powered Fly Identification App

Afro-Dip is a mobile application designed to help scientists, researchers, and students identify and learn about different species of flies, particularly focusing on disease-carrying species in Africa. The app uses artificial intelligence to analyze images of flies and provide accurate species identification.

## Features

- 📸 Real-time fly image capture and analysis
- 📚 Comprehensive library of fly species information
- 🔍 Detailed species profiles with scientific data
- 📊 View past identification results
- 🌙 Dark mode support
- 🌍 Multiple language support
- 📱 User-friendly interface

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code with Flutter extensions
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/afro-dip.git
```

2. Navigate to the project directory:
```bash
cd afro-dip
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── providers/            # State management
│   └── app_provider.dart
├── screens/             # App screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── scan_screen.dart
│   ├── library_screen.dart
│   └── profile_screen.dart
└── models/              # Data models
    └── fly_species.dart

assets/
├── images/             # Image assets
├── animations/         # Lottie animations
├── icons/             # App icons
├── fonts/             # Custom fonts
└── model/             # TFLite model files
```

## Dependencies

- camera: For image capture
- tflite_flutter: For AI model inference
- provider: For state management
- shared_preferences: For local storage
- lottie: For animations
- image_picker: For gallery image selection

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- TensorFlow team for the TFLite framework
- Contributors and maintainers of all dependencies
