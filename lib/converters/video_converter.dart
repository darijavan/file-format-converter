import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';

import '../models/conversion_task.dart';
import 'file_converter.dart';

/// Video converter implementation using FFmpeg
/// Supports conversion between common video formats
class VideoConverter extends FileConverter {
  final Map<String, StreamController<ConversionTask>> _activeConversions = {};

  @override
  String get converterName => 'Video Converter';

  @override
  List<String> get supportedInputFormats => [
        'mp4',
        'avi',
        'mov',
        'mkv',
        'flv',
        'wmv',
        'webm',
        'm4v',
        'mpeg',
        'mpg',
      ];

  @override
  List<String> get supportedOutputFormats => [
        'mp4',
        'avi',
        'mov',
        'mkv',
        'webm',
        'flv',
      ];

  @override
  bool supportsConversion(String inputFormat, String outputFormat) {
    return supportedInputFormats.contains(inputFormat.toLowerCase()) &&
        supportedOutputFormats.contains(outputFormat.toLowerCase());
  }

  @override
  Stream<ConversionTask> convert(ConversionTask task) {
    final controller = StreamController<ConversionTask>();
    _activeConversions[task.id] = controller;

    _performConversion(task, controller);

    return controller.stream;
  }

  Future<void> _performConversion(
    ConversionTask task,
    StreamController<ConversionTask> controller,
  ) async {
    try {
      // Update status to processing
      var updatedTask = task.copyWith(
        status: ConversionStatus.processing,
        progress: 0.0,
      );
      controller.add(updatedTask);

      // Build FFmpeg command with format-specific codecs
      final command = _buildFFmpegCommand(task.inputPath, task.outputPath, task.outputFormat);

      // Get video duration first for accurate progress tracking
      int? duration;
      await FFmpegKit.execute('-i "${task.inputPath}"').then((session) async {
        final output = await session.getOutput();
        if (output != null) {
          final durationMatch = RegExp(r'Duration: (\d{2}):(\d{2}):(\d{2})').firstMatch(output);
          if (durationMatch != null) {
            final hours = int.parse(durationMatch.group(1)!);
            final minutes = int.parse(durationMatch.group(2)!);
            final seconds = int.parse(durationMatch.group(3)!);
            duration = hours * 3600 + minutes * 60 + seconds;
          }
        }
      });

      // Execute conversion with progress tracking
      await FFmpegKit.executeAsync(
        command,
        (session) async {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            // Conversion successful
            updatedTask = updatedTask.copyWith(
              status: ConversionStatus.completed,
              progress: 1.0,
            );
            controller.add(updatedTask);
          } else {
            // Conversion failed
            final output = await session.getOutput();
            updatedTask = updatedTask.copyWith(
              status: ConversionStatus.failed,
              errorMessage: output ?? 'Conversion failed',
            );
            controller.add(updatedTask);
          }

          _activeConversions.remove(task.id);
          await controller.close();
        },
        null, // log callback
        (statistics) {
          // Update progress based on time processed
          if (duration != null && duration > 0) {
            final time = statistics.getTime();
            final progress = (time / 1000) / duration;
            updatedTask = updatedTask.copyWith(
              progress: progress.clamp(0.0, 0.99),
            );
            controller.add(updatedTask);
          }
        },
      );
    } catch (e) {
      final updatedTask = task.copyWith(
        status: ConversionStatus.failed,
        errorMessage: e.toString(),
      );
      controller.add(updatedTask);
      _activeConversions.remove(task.id);
      await controller.close();
    }
  }

  /// Build FFmpeg command with format-specific codecs for optimal quality
  String _buildFFmpegCommand(String inputPath, String outputPath, String outputFormat) {
    // Base command
    String command = '-i "$inputPath"';
    
    // Format-specific codec settings
    switch (outputFormat.toLowerCase()) {
      case 'mp4':
        command += ' -c:v libx264 -c:a aac -strict experimental';
        break;
      case 'webm':
        command += ' -c:v libvpx-vp9 -c:a libopus';
        break;
      case 'mkv':
        command += ' -c:v libx264 -c:a aac';
        break;
      case 'avi':
        command += ' -c:v mpeg4 -c:a libmp3lame';
        break;
      case 'mov':
        command += ' -c:v libx264 -c:a aac';
        break;
      case 'flv':
        command += ' -c:v libx264 -c:a aac';
        break;
      default:
        // Default codecs
        command += ' -c:v libx264 -c:a aac';
    }
    
    command += ' "$outputPath"';
    return command;
  }

  @override
  Future<void> cancelConversion(String taskId) async {
    final controller = _activeConversions[taskId];
    if (controller != null) {
      await FFmpegKit.cancel();
      _activeConversions.remove(taskId);
      await controller.close();
    }
  }

  /// Clean up resources
  void dispose() {
    for (final controller in _activeConversions.values) {
      controller.close();
    }
    _activeConversions.clear();
  }
}
