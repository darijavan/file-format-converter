# File Format Converter

A cross-platform Flutter app for converting file formats, currently focused on video conversion using FFmpeg.

## Features

- 🎥 **Video Conversion**: Convert between popular video formats (MP4, AVI, MOV, MKV, WebM, FLV)
- 📱 **Cross-Platform**: Works on both iOS and Android
- 🔄 **Real-time Progress**: Track conversion progress with live updates
- 🏗️ **Extensible Architecture**: Easily add support for other file types (audio, images, documents)
- 🎨 **Modern UI**: Clean, intuitive Material Design interface

## Architecture

The app is built with an extensible architecture that makes it easy to add new converter types:

### Core Components

1. **FileConverter** (Abstract Class)
   - Base interface for all converters
   - Defines common conversion operations
   - Located in `lib/converters/file_converter.dart`

2. **VideoConverter** (Implementation)
   - Implements video conversion using FFmpeg
   - Supports multiple video formats
   - Located in `lib/converters/video_converter.dart`

3. **ConverterService** (Service Layer)
   - Manages all available converters
   - Routes conversion tasks to appropriate converter
   - Located in `lib/services/converter_service.dart`

4. **ConversionProvider** (State Management)
   - Manages app state using Provider pattern
   - Handles conversion tasks and progress
   - Located in `lib/services/conversion_provider.dart`

### Adding New Converter Types

To add support for a new file type (e.g., audio, image, document):

1. Create a new converter class extending `FileConverter`
2. Implement the required methods:
   - `convert()`: Perform the conversion
   - `supportsConversion()`: Check format support
   - `supportedInputFormats`: List input formats
   - `supportedOutputFormats`: List output formats
3. Register the converter in `ConverterService` constructor

Example:
```dart
class AudioConverter extends FileConverter {
  @override
  String get converterName => 'Audio Converter';
  
  @override
  List<String> get supportedInputFormats => ['mp3', 'wav', 'flac'];
  
  @override
  List<String> get supportedOutputFormats => ['mp3', 'aac', 'ogg'];
  
  // Implement other required methods...
}
```

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- For Android: Android Studio and Android SDK
- For iOS: Xcode (Mac only)

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/darijavan/file-format-converter.git
   cd file-format-converter
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS (Mac only):
   ```bash
   flutter run
   ```

## Dependencies

- **ffmpeg_kit_flutter**: FFmpeg integration for video processing
- **file_picker**: File selection from device storage
- **path_provider**: Access to device file system
- **permission_handler**: Request and manage permissions
- **provider**: State management

## Permissions

### Android
The app requires the following permissions (already configured in `AndroidManifest.xml`):
- `READ_EXTERNAL_STORAGE`
- `WRITE_EXTERNAL_STORAGE`
- `MANAGE_EXTERNAL_STORAGE`

### iOS
The app requires the following permissions (already configured in `Info.plist`):
- Photo Library access for video selection

## Usage

1. **Select a video file**: Tap "Pick Video File" to choose a video from your device
2. **Choose output format**: Select the desired output format from the dropdown
3. **Convert**: Tap "Convert Video" to start the conversion
4. **Monitor progress**: Watch real-time conversion progress
5. **Access converted file**: Once complete, the file location is displayed

## Project Structure

```
lib/
├── converters/          # Converter implementations
│   ├── file_converter.dart       # Abstract base class
│   └── video_converter.dart      # Video converter implementation
├── models/              # Data models
│   └── conversion_task.dart      # Conversion task model
├── screens/             # UI screens
│   └── home_screen.dart          # Main app screen
├── services/            # Business logic
│   ├── converter_service.dart    # Converter management
│   └── conversion_provider.dart  # State management
├── widgets/             # Reusable UI components
│   ├── conversion_progress_widget.dart
│   └── format_selector_widget.dart
└── main.dart            # App entry point
```

## Future Enhancements

The extensible architecture allows for easy addition of:
- 🎵 Audio conversion (MP3, WAV, FLAC, AAC)
- 🖼️ Image conversion (JPG, PNG, WebP, HEIC)
- 📄 Document conversion (PDF, DOCX, TXT)
- ☁️ Cloud storage integration
- 📊 Batch conversion support
- ⚙️ Advanced conversion settings (bitrate, resolution, codec)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
