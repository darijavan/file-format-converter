# Architecture Documentation

## Overview

The File Format Converter app is built with a modular, extensible architecture that makes it easy to add support for new file types. This document explains the architecture and how to extend it.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI Layer (Flutter)                       │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  HomeScreen  │  │   Widgets    │  │  ConversionProvider  │  │
│  │              │  │              │  │   (State Manager)    │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
└─────────┼──────────────────┼───────────────────────┼─────────────┘
          │                  │                       │
          └──────────────────┴───────────────────────┘
                             │
                             ▼
          ┌──────────────────────────────────────────┐
          │      Service Layer                       │
          │                                          │
          │  ┌────────────────────────────────────┐ │
          │  │    ConverterService                │ │
          │  │  (Manages all converters)          │ │
          │  └──────────────┬─────────────────────┘ │
          └─────────────────┼───────────────────────┘
                            │
                            │ Delegates to
                            ▼
          ┌──────────────────────────────────────────┐
          │      Converter Layer                     │
          │                                          │
          │  ┌────────────────────────────────────┐ │
          │  │    FileConverter (Abstract)        │ │
          │  │  • convert()                       │ │
          │  │  • supportsConversion()            │ │
          │  │  • supportedInputFormats           │ │
          │  │  • supportedOutputFormats          │ │
          │  └──────────────┬─────────────────────┘ │
          │                 │                        │
          │    ┌────────────┼────────────┐          │
          │    │            │            │          │
          │    ▼            ▼            ▼          │
          │ ┌──────┐  ┌──────────┐  ┌────────┐    │
          │ │Video │  │  Audio   │  │ Image  │    │
          │ │Conv. │  │  Conv.   │  │ Conv.  │    │
          │ │      │  │ (future) │  │(future)│    │
          │ └──────┘  └──────────┘  └────────┘    │
          └──────────────────────────────────────────┘
                            │
                            ▼
          ┌──────────────────────────────────────────┐
          │      External Libraries                  │
          │                                          │
          │  • ffmpeg_kit_flutter                   │
          │  • file_picker                          │
          │  • path_provider                        │
          └──────────────────────────────────────────┘
```

## Key Design Patterns

### 1. Strategy Pattern (FileConverter)
The `FileConverter` abstract class defines the interface for all converters. Each specific converter (VideoConverter, AudioConverter, etc.) implements this interface with its own conversion strategy.

**Benefits:**
- Easy to add new converter types
- Converters are interchangeable
- Each converter is independent and testable

### 2. Service Layer Pattern (ConverterService)
The `ConverterService` acts as a facade, managing all converters and routing conversion requests to the appropriate converter.

**Benefits:**
- Single point of entry for all conversions
- Automatic converter selection
- Centralized converter registration

### 3. Provider Pattern (ConversionProvider)
Uses Flutter's Provider for state management, making it easy to update the UI when conversion state changes.

**Benefits:**
- Reactive UI updates
- Clean separation of business logic and UI
- Easy testing

## Component Responsibilities

### UI Layer

**HomeScreen**
- User interface for file selection
- Format selection
- Trigger conversions
- Display conversion results

**Widgets**
- `ConversionProgressWidget`: Shows conversion progress
- `FormatSelectorWidget`: Allows format selection

**ConversionProvider**
- Manages application state
- Coordinates with ConverterService
- Updates UI through Provider

### Service Layer

**ConverterService**
- Registers available converters
- Finds appropriate converter for given formats
- Provides list of supported formats
- Routes conversion requests

### Converter Layer

**FileConverter (Abstract)**
- Defines converter interface
- Enforces common contract for all converters

**VideoConverter**
- Implements video conversion using FFmpeg
- Supports: MP4, AVI, MOV, MKV, WebM, FLV
- Provides progress updates via streams

## Data Flow

1. User selects file in **HomeScreen**
2. User chooses output format
3. User taps "Convert"
4. **HomeScreen** calls **ConversionProvider**.startConversion()
5. **ConversionProvider** creates ConversionTask
6. **ConversionProvider** calls **ConverterService**.convert()
7. **ConverterService** finds appropriate **FileConverter**
8. **FileConverter** performs conversion and emits progress updates
9. **ConversionProvider** receives updates and notifies listeners
10. **HomeScreen** widgets rebuild with new state

## Adding New Converter Types

### Example: Adding Audio Converter

1. **Create the converter class**

```dart
// lib/converters/audio_converter.dart
import 'dart:async';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import '../models/conversion_task.dart';
import 'file_converter.dart';

class AudioConverter extends FileConverter {
  @override
  String get converterName => 'Audio Converter';

  @override
  List<String> get supportedInputFormats => ['mp3', 'wav', 'flac', 'm4a', 'aac', 'ogg'];

  @override
  List<String> get supportedOutputFormats => ['mp3', 'aac', 'wav', 'ogg', 'flac'];

  @override
  bool supportsConversion(String inputFormat, String outputFormat) {
    return supportedInputFormats.contains(inputFormat.toLowerCase()) &&
        supportedOutputFormats.contains(outputFormat.toLowerCase());
  }

  @override
  Stream<ConversionTask> convert(ConversionTask task) {
    // Implementation similar to VideoConverter
    // Use FFmpeg for audio conversion
  }

  @override
  Future<void> cancelConversion(String taskId) async {
    // Implementation
  }
}
```

2. **Register the converter**

```dart
// lib/services/converter_service.dart
class ConverterService {
  final List<FileConverter> _converters = [];

  ConverterService() {
    _registerConverter(VideoConverter());
    _registerConverter(AudioConverter()); // Add this line
  }
  // ...rest of the code
}
```

3. **Update UI (Optional)**

If you want a dedicated screen or different UI for audio files, you can:
- Add format-specific file extensions in file picker
- Customize the FormatSelectorWidget to show appropriate formats
- Add audio-specific options (bitrate, sample rate, etc.)

That's it! The new converter is now integrated into the app.

## Testing Strategy

### Unit Tests
- Test each converter independently
- Test ConverterService routing logic
- Test ConversionTask model

### Integration Tests
- Test complete conversion flow
- Test state management with ConversionProvider
- Test error handling

### Widget Tests
- Test UI components
- Test user interactions
- Test state changes

## Future Enhancements

### Additional Converters
- **AudioConverter**: MP3, WAV, FLAC, AAC
- **ImageConverter**: JPG, PNG, WebP, HEIC, GIF
- **DocumentConverter**: PDF, DOCX, TXT, EPUB

### Features
- Batch conversion (multiple files)
- Custom conversion settings
- Cloud storage integration
- Conversion history
- Preset configurations
- Advanced FFmpeg options

### Performance
- Background processing
- Queue management
- Resource optimization
- Caching strategies

## Conclusion

This architecture provides:
- ✅ Clear separation of concerns
- ✅ Easy extensibility
- ✅ Testability
- ✅ Maintainability
- ✅ Scalability

Adding new converter types requires minimal changes to existing code, following the Open/Closed Principle from SOLID design principles.
