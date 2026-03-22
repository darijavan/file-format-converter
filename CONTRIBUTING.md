# Contributing to File Format Converter

Thank you for your interest in contributing to the File Format Converter project! This document provides guidelines and instructions for contributing.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
3. [Development Setup](#development-setup)
4. [Adding New Converters](#adding-new-converters)
5. [Testing Guidelines](#testing-guidelines)
6. [Pull Request Process](#pull-request-process)
7. [Style Guidelines](#style-guidelines)

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow. Please be respectful and constructive in all interactions.

## How Can I Contribute?

### Reporting Bugs

- Check if the bug has already been reported in Issues
- Use a clear, descriptive title
- Provide detailed steps to reproduce
- Include device/platform information
- Include screenshots if applicable

### Suggesting Enhancements

- Check if the enhancement has already been suggested
- Provide a clear description of the feature
- Explain why this enhancement would be useful
- Include mockups or examples if possible

### Contributing Code

We welcome contributions! Here are areas where you can help:

1. **Add New Converters**: Audio, Image, Document converters
2. **Improve Existing Converters**: Better progress tracking, more formats
3. **UI Enhancements**: Better user experience, themes, animations
4. **Performance**: Optimization, caching, background processing
5. **Testing**: Add more unit tests, integration tests, widget tests
6. **Documentation**: Improve README, add examples, create tutorials

## Development Setup

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK (included with Flutter)
- Android Studio (for Android development)
- Xcode (for iOS development, Mac only)
- Git

### Setup Steps

1. **Fork the repository**
   ```bash
   # Click the Fork button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/file-format-converter.git
   cd file-format-converter
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/darijavan/file-format-converter.git
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Verify setup**
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

## Adding New Converters

The architecture makes it easy to add new converter types. Here's how:

### Step 1: Create the Converter Class

Create a new file in `lib/converters/`, for example `audio_converter.dart`:

```dart
import 'dart:async';
import '../models/conversion_task.dart';
import 'file_converter.dart';

class AudioConverter extends FileConverter {
  @override
  String get converterName => 'Audio Converter';

  @override
  List<String> get supportedInputFormats => ['mp3', 'wav', 'flac'];

  @override
  List<String> get supportedOutputFormats => ['mp3', 'aac', 'ogg'];

  @override
  bool supportsConversion(String inputFormat, String outputFormat) {
    return supportedInputFormats.contains(inputFormat.toLowerCase()) &&
        supportedOutputFormats.contains(outputFormat.toLowerCase());
  }

  @override
  Stream<ConversionTask> convert(ConversionTask task) {
    // Implement conversion logic
    // Return a stream that emits progress updates
  }

  @override
  Future<void> cancelConversion(String taskId) async {
    // Implement cancellation logic
  }
}
```

### Step 2: Register the Converter

Edit `lib/services/converter_service.dart`:

```dart
ConverterService() {
  _registerConverter(VideoConverter());
  _registerConverter(AudioConverter()); // Add your converter
}
```

### Step 3: Add Tests

Create tests in `test/` folder:

```dart
group('AudioConverter Tests', () {
  test('should support audio formats', () {
    final converter = AudioConverter();
    expect(converter.supportsConversion('mp3', 'wav'), isTrue);
  });
});
```

### Step 4: Update Documentation

- Update README.md with new supported formats
- Add examples to ARCHITECTURE.md
- Update this CONTRIBUTING.md if needed

## Testing Guidelines

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/converter_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

- Write unit tests for all new converters
- Test both success and failure cases
- Test edge cases (unsupported formats, missing files, etc.)
- Aim for high code coverage (>80%)

### Test Structure

```dart
group('Feature Tests', () {
  setUp(() {
    // Setup before each test
  });

  test('should do something', () {
    // Arrange
    final input = ...;
    
    // Act
    final result = ...;
    
    // Assert
    expect(result, expectedValue);
  });

  tearDown(() {
    // Cleanup after each test
  });
});
```

## Pull Request Process

### Before Submitting

1. **Create a new branch**
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**
   - Follow the style guidelines
   - Write tests
   - Update documentation

3. **Test your changes**
   ```bash
   flutter analyze
   flutter test
   flutter run  # Manual testing
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add audio converter support"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/my-new-feature
   ```

### Submitting the PR

1. Go to the original repository on GitHub
2. Click "New Pull Request"
3. Select your branch
4. Fill in the PR template:
   - **Title**: Clear, descriptive title
   - **Description**: What changes were made and why
   - **Testing**: How you tested the changes
   - **Screenshots**: If UI changes were made

### PR Review Process

- Maintainers will review your PR
- Address any requested changes
- Once approved, your PR will be merged
- Celebrate! 🎉

## Style Guidelines

### Dart Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

- Use `lowerCamelCase` for variables, methods, parameters
- Use `UpperCamelCase` for types
- Use `lowercase_with_underscores` for libraries, packages
- Prefer `const` constructors when possible
- Use trailing commas for better formatting
- Maximum line length: 80 characters

### Code Organization

```dart
// 1. Imports (sorted)
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/conversion_task.dart';

// 2. Class declaration
class MyConverter extends FileConverter {
  // 3. Static constants
  static const String version = '1.0.0';
  
  // 4. Instance variables
  final Map<String, dynamic> _cache = {};
  
  // 5. Constructor
  MyConverter();
  
  // 6. Getters/Setters
  @override
  String get converterName => 'My Converter';
  
  // 7. Public methods
  @override
  Stream<ConversionTask> convert(ConversionTask task) {
    // Implementation
  }
  
  // 8. Private methods
  void _internalMethod() {
    // Implementation
  }
}
```

### Comments

- Use `///` for documentation comments
- Use `//` for implementation comments
- Document public APIs
- Explain "why", not "what"

```dart
/// Converts audio files between different formats.
/// 
/// This converter uses FFmpeg to handle the conversion.
/// Supports common audio formats including MP3, WAV, and FLAC.
class AudioConverter extends FileConverter {
  // ...
}
```

### Commit Messages

Follow conventional commits format:

```
type(scope): subject

body

footer
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(converter): add audio converter support

Implements audio conversion using FFmpeg.
Supports MP3, WAV, FLAC, and AAC formats.

Closes #123
```

```
fix(ui): fix progress bar not updating

The progress bar wasn't updating because the stream
wasn't being properly listened to.
```

## Questions?

If you have questions:
- Open an issue with the `question` label
- Check existing issues and discussions
- Read the ARCHITECTURE.md document

Thank you for contributing! 🙏
