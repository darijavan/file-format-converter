import 'package:flutter/material.dart';

class FormatSelectorWidget extends StatelessWidget {
  final String inputFormat;
  final String selectedOutputFormat;
  final ValueChanged<String> onOutputFormatChanged;

  const FormatSelectorWidget({
    super.key,
    required this.inputFormat,
    required this.selectedOutputFormat,
    required this.onOutputFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Available output formats for video conversion
    final outputFormats = ['mp4', 'avi', 'mov', 'mkv', 'webm', 'flv'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Output Format',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From:', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(inputFormat.toUpperCase()),
                        backgroundColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('To:', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      DropdownButton<String>(
                        value: selectedOutputFormat,
                        isExpanded: true,
                        items: outputFormats.map((format) {
                          return DropdownMenuItem(
                            value: format,
                            child: Text(format.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            onOutputFormatChanged(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
