import 'package:flutter_test/flutter_test.dart';
import 'package:file_format_converter/converters/video_converter.dart';
import 'package:file_format_converter/services/converter_service.dart';
import 'package:file_format_converter/models/conversion_task.dart';

void main() {
  group('ConverterService Tests', () {
    late ConverterService converterService;

    setUp(() {
      converterService = ConverterService();
    });

    test('should have video converter registered', () {
      final converters = converterService.converters;
      expect(converters.length, greaterThan(0));
      expect(converters.first.converterName, 'Video Converter');
    });

    test('should find converter for supported formats', () {
      final converter = converterService.findConverter('mp4', 'avi');
      expect(converter, isNotNull);
      expect(converter, isA<VideoConverter>());
    });

    test('should return null for unsupported formats', () {
      final converter = converterService.findConverter('unknown', 'invalid');
      expect(converter, isNull);
    });

    test('should check if conversion is supported', () {
      expect(converterService.isConversionSupported('mp4', 'avi'), isTrue);
      expect(converterService.isConversionSupported('mp4', 'mov'), isTrue);
      expect(converterService.isConversionSupported('unknown', 'invalid'), isFalse);
    });

    test('should get all supported input formats', () {
      final formats = converterService.getAllSupportedInputFormats();
      expect(formats, isNotEmpty);
      expect(formats, contains('mp4'));
      expect(formats, contains('avi'));
      expect(formats, contains('mov'));
    });

    test('should get all supported output formats', () {
      final formats = converterService.getAllSupportedOutputFormats();
      expect(formats, isNotEmpty);
      expect(formats, contains('mp4'));
      expect(formats, contains('avi'));
      expect(formats, contains('webm'));
    });
  });

  group('VideoConverter Tests', () {
    late VideoConverter videoConverter;

    setUp(() {
      videoConverter = VideoConverter();
    });

    test('should have correct converter name', () {
      expect(videoConverter.converterName, 'Video Converter');
    });

    test('should support common video formats', () {
      expect(videoConverter.supportedInputFormats, contains('mp4'));
      expect(videoConverter.supportedInputFormats, contains('avi'));
      expect(videoConverter.supportedInputFormats, contains('mov'));
      expect(videoConverter.supportedInputFormats, contains('mkv'));
    });

    test('should support conversion between common formats', () {
      expect(videoConverter.supportsConversion('mp4', 'avi'), isTrue);
      expect(videoConverter.supportsConversion('mov', 'mp4'), isTrue);
      expect(videoConverter.supportsConversion('mkv', 'webm'), isTrue);
    });

    test('should not support conversion with unsupported formats', () {
      expect(videoConverter.supportsConversion('unknown', 'mp4'), isFalse);
      expect(videoConverter.supportsConversion('mp4', 'unknown'), isFalse);
    });
  });

  group('ConversionTask Tests', () {
    test('should create conversion task with required fields', () {
      final task = ConversionTask(
        id: '1',
        inputPath: '/path/to/input.mp4',
        outputPath: '/path/to/output.avi',
        inputFormat: 'mp4',
        outputFormat: 'avi',
      );

      expect(task.id, '1');
      expect(task.inputPath, '/path/to/input.mp4');
      expect(task.outputPath, '/path/to/output.avi');
      expect(task.inputFormat, 'mp4');
      expect(task.outputFormat, 'avi');
      expect(task.status, ConversionStatus.pending);
      expect(task.progress, 0.0);
    });

    test('should copy task with updated fields', () {
      final task = ConversionTask(
        id: '1',
        inputPath: '/path/to/input.mp4',
        outputPath: '/path/to/output.avi',
        inputFormat: 'mp4',
        outputFormat: 'avi',
      );

      final updatedTask = task.copyWith(
        status: ConversionStatus.processing,
        progress: 0.5,
      );

      expect(updatedTask.id, task.id);
      expect(updatedTask.status, ConversionStatus.processing);
      expect(updatedTask.progress, 0.5);
    });
  });
}
