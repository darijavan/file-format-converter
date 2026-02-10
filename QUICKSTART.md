# Quick Start Guide

Get the File Format Converter app up and running in minutes!

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ Flutter SDK 3.0.0+ installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
- ✅ Android Studio (for Android) or Xcode (for iOS/Mac)
- ✅ A physical device or emulator set up
- ✅ Git installed

## 🚀 Quick Setup (5 minutes)

### 1. Clone the Repository

```bash
git clone https://github.com/darijavan/file-format-converter.git
cd file-format-converter
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

**For Android:**
```bash
flutter run
```

**For iOS (Mac only):**
```bash
flutter run
```

That's it! The app should now be running on your device/emulator.

## 🎯 First Conversion

1. **Tap "Pick Video File"** - Select any video file from your device
2. **Choose Output Format** - Select from MP4, AVI, MOV, MKV, WebM, or FLV
3. **Tap "Convert Video"** - Watch the progress in real-time
4. **Done!** - Your converted file will be saved to the app's documents directory

## 📱 Testing the App

### Using Android Emulator

```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator_id>

# Run the app
flutter run
```

### Using Physical Device

1. **Enable Developer Mode** on your device
2. **Enable USB Debugging** (Android) or trust your computer (iOS)
3. Connect device via USB
4. Run `flutter devices` to verify connection
5. Run `flutter run`

## 🧪 Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/converter_test.dart
```

## 🔍 Code Quality Checks

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check for outdated dependencies
flutter pub outdated
```

## 📊 Project Structure Overview

```
file-format-converter/
├── lib/
│   ├── converters/          # Converter implementations
│   │   ├── file_converter.dart
│   │   ├── video_converter.dart
│   │   └── audio_converter_example.dart
│   ├── models/              # Data models
│   │   └── conversion_task.dart
│   ├── screens/             # UI screens
│   │   └── home_screen.dart
│   ├── services/            # Business logic
│   │   ├── converter_service.dart
│   │   └── conversion_provider.dart
│   ├── widgets/             # Reusable widgets
│   │   ├── conversion_progress_widget.dart
│   │   └── format_selector_widget.dart
│   └── main.dart
├── test/                    # Unit tests
├── android/                 # Android specific files
├── ios/                     # iOS specific files
└── docs/                    # Documentation
```

## 💡 Common Issues

### Issue: "No devices found"

**Solution:**
- Check if device is connected: `flutter devices`
- For Android: Ensure USB debugging is enabled
- For iOS: Ensure device is trusted
- Try: `flutter doctor` to diagnose issues

### Issue: "Gradle build failed"

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "CocoaPods not installed" (iOS)

**Solution:**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Issue: "Permission denied" when selecting files

**Solution:**
- Ensure app has storage permissions
- On Android 11+, enable "All files access" in app settings
- Restart the app after granting permissions

## 🎨 Customization

### Change App Name

Edit the following files:
- `android/app/src/main/AndroidManifest.xml` - Update `android:label`
- `ios/Runner/Info.plist` - Update `CFBundleDisplayName`
- `pubspec.yaml` - Update `name`

### Change App Icon

1. Add your icon image to `assets/icon.png`
2. Add the `flutter_launcher_icons` package
3. Run `flutter pub run flutter_launcher_icons`

### Change Theme

Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Change color
  useMaterial3: true,
),
```

## 📚 Next Steps

- Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the app structure
- Read [CONTRIBUTING.md](CONTRIBUTING.md) to learn how to contribute
- Add new converters (Audio, Image, Document)
- Enhance the UI with your own designs
- Add more conversion options

## 🆘 Need Help?

- 📖 Check the [README.md](README.md) for detailed information
- 🏗️ Review [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
- 🤝 Read [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
- 🐛 Open an issue on GitHub for bugs
- 💬 Start a discussion for questions

## 🎉 You're Ready!

Congratulations! You now have a working file format converter app. Start exploring, converting files, and contributing to the project!

---

**Happy Converting! 🚀**
