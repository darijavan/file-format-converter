import '../converters/file_converter.dart';
import '../converters/video_converter.dart';
import '../models/conversion_task.dart';

/// Service that manages all file converters
/// This design allows easy addition of new converter types
class ConverterService {
  final List<FileConverter> _converters = [];

  ConverterService() {
    // Register available converters
    // Future converters (audio, image, document) can be added here
    _registerConverter(VideoConverter());
  }

  void _registerConverter(FileConverter converter) {
    _converters.add(converter);
  }

  /// Find a suitable converter for the given formats
  FileConverter? findConverter(String inputFormat, String outputFormat) {
    for (final converter in _converters) {
      if (converter.supportsConversion(inputFormat, outputFormat)) {
        return converter;
      }
    }
    return null;
  }

  /// Get all available converters
  List<FileConverter> get converters => List.unmodifiable(_converters);

  /// Check if conversion is supported
  bool isConversionSupported(String inputFormat, String outputFormat) {
    return findConverter(inputFormat, outputFormat) != null;
  }

  /// Get all supported input formats across all converters
  List<String> getAllSupportedInputFormats() {
    final formats = <String>{};
    for (final converter in _converters) {
      formats.addAll(converter.supportedInputFormats);
    }
    return formats.toList()..sort();
  }

  /// Get all supported output formats across all converters
  List<String> getAllSupportedOutputFormats() {
    final formats = <String>{};
    for (final converter in _converters) {
      formats.addAll(converter.supportedOutputFormats);
    }
    return formats.toList()..sort();
  }

  /// Convert a file using the appropriate converter
  Stream<ConversionTask>? convert(ConversionTask task) {
    final converter = findConverter(task.inputFormat, task.outputFormat);
    if (converter == null) {
      throw UnsupportedError(
        'No converter available for ${task.inputFormat} to ${task.outputFormat}',
      );
    }
    return converter.convert(task);
  }

  /// Cancel a conversion
  Future<void> cancelConversion(String taskId, String inputFormat, String outputFormat) async {
    final converter = findConverter(inputFormat, outputFormat);
    if (converter != null) {
      await converter.cancelConversion(taskId);
    }
  }
}
