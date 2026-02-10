import '../models/conversion_task.dart';

/// Abstract base class for all file converters
/// This allows easy extension for different file types in the future
abstract class FileConverter {
  /// Convert a file from one format to another
  /// Returns a stream of conversion progress updates
  Stream<ConversionTask> convert(ConversionTask task);

  /// Check if this converter supports the given input and output formats
  bool supportsConversion(String inputFormat, String outputFormat);

  /// Get the list of supported input formats
  List<String> get supportedInputFormats;

  /// Get the list of supported output formats
  List<String> get supportedOutputFormats;

  /// Get the converter name/type
  String get converterName;

  /// Cancel an ongoing conversion
  Future<void> cancelConversion(String taskId);
}
