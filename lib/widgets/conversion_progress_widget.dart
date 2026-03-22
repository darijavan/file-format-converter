import 'package:flutter/material.dart';
import '../models/conversion_task.dart';

class ConversionProgressWidget extends StatelessWidget {
  final ConversionTask task;

  const ConversionProgressWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conversion Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Status indicator
            Row(
              children: [
                _buildStatusIcon(),
                const SizedBox(width: 12),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 16,
                    color: _getStatusColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress bar
            if (task.status == ConversionStatus.processing)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: task.progress,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(task.progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

            // File information
            const SizedBox(height: 16),
            Text(
              'Input: ${task.inputPath.split('/').last}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Output: ${task.outputPath.split('/').last}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Format: ${task.inputFormat.toUpperCase()} → ${task.outputFormat.toUpperCase()}',
              style: const TextStyle(fontSize: 14),
            ),

            // Error message
            if (task.status == ConversionStatus.failed && task.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Error: ${task.errorMessage}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),

            // Success message
            if (task.status == ConversionStatus.completed)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'File saved to: ${task.outputPath}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (task.status) {
      case ConversionStatus.pending:
        return const Icon(Icons.schedule, color: Colors.orange);
      case ConversionStatus.processing:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case ConversionStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case ConversionStatus.failed:
        return const Icon(Icons.error, color: Colors.red);
      case ConversionStatus.cancelled:
        return const Icon(Icons.cancel, color: Colors.grey);
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case ConversionStatus.pending:
        return 'Pending';
      case ConversionStatus.processing:
        return 'Converting...';
      case ConversionStatus.completed:
        return 'Completed';
      case ConversionStatus.failed:
        return 'Failed';
      case ConversionStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (task.status) {
      case ConversionStatus.pending:
        return Colors.orange;
      case ConversionStatus.processing:
        return Theme.of(context).primaryColor;
      case ConversionStatus.completed:
        return Colors.green;
      case ConversionStatus.failed:
        return Colors.red;
      case ConversionStatus.cancelled:
        return Colors.grey;
    }
  }
}
