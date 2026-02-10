/// Represents a file conversion task
class ConversionTask {
  final String id;
  final String inputPath;
  final String outputPath;
  final String inputFormat;
  final String outputFormat;
  final ConversionStatus status;
  final double progress;
  final String? errorMessage;

  ConversionTask({
    required this.id,
    required this.inputPath,
    required this.outputPath,
    required this.inputFormat,
    required this.outputFormat,
    this.status = ConversionStatus.pending,
    this.progress = 0.0,
    this.errorMessage,
  });

  ConversionTask copyWith({
    String? id,
    String? inputPath,
    String? outputPath,
    String? inputFormat,
    String? outputFormat,
    ConversionStatus? status,
    double? progress,
    String? errorMessage,
  }) {
    return ConversionTask(
      id: id ?? this.id,
      inputPath: inputPath ?? this.inputPath,
      outputPath: outputPath ?? this.outputPath,
      inputFormat: inputFormat ?? this.inputFormat,
      outputFormat: outputFormat ?? this.outputFormat,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum ConversionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}
