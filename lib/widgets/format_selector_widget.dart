import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/conversion_provider.dart';

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
    // Get available output formats from the converter service
    final provider = context.watch<ConversionProvider>();
    final outputFormats = provider.converterService.getAllSupportedOutputFormats();

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
