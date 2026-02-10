import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/conversion_task.dart';
import '../services/converter_service.dart';

/// Provider for managing conversion state
class ConversionProvider extends ChangeNotifier {
  final ConverterService _converterService = ConverterService();
  final List<ConversionTask> _tasks = [];
  ConversionTask? _currentTask;

  List<ConversionTask> get tasks => List.unmodifiable(_tasks);
  ConversionTask? get currentTask => _currentTask;
  ConverterService get converterService => _converterService;

  /// Start a new conversion
  Future<void> startConversion({
    required String inputPath,
    required String inputFormat,
    required String outputFormat,
  }) async {
    try {
      // Generate output path
      final outputDir = await _getOutputDirectory();
      final fileName = inputPath.split('/').last.split('.').first;
      final outputPath = '${outputDir.path}/$fileName.$outputFormat';

      // Create conversion task
      final task = ConversionTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        inputPath: inputPath,
        outputPath: outputPath,
        inputFormat: inputFormat,
        outputFormat: outputFormat,
      );

      _tasks.add(task);
      _currentTask = task;
      notifyListeners();

      // Start conversion
      final stream = _converterService.convert(task);
      if (stream != null) {
        await for (final updatedTask in stream) {
          _updateTask(updatedTask);
        }
      }
    } catch (e) {
      if (_currentTask != null) {
        _updateTask(_currentTask!.copyWith(
          status: ConversionStatus.failed,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void _updateTask(ConversionTask updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      if (_currentTask?.id == updatedTask.id) {
        _currentTask = updatedTask;
      }
      notifyListeners();
    }
  }

  /// Cancel the current conversion
  Future<void> cancelCurrentConversion() async {
    if (_currentTask != null) {
      await _converterService.cancelConversion(
        _currentTask!.id,
        _currentTask!.inputFormat,
        _currentTask!.outputFormat,
      );
      _updateTask(_currentTask!.copyWith(status: ConversionStatus.cancelled));
    }
  }

  /// Clear completed tasks
  void clearCompletedTasks() {
    _tasks.removeWhere((task) => 
      task.status == ConversionStatus.completed ||
      task.status == ConversionStatus.failed ||
      task.status == ConversionStatus.cancelled
    );
    notifyListeners();
  }

  Future<Directory> _getOutputDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final outputDir = Directory('${appDir.path}/converted_videos');
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }
    return outputDir;
  }
}
