import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/conversion_provider.dart';
import '../models/conversion_task.dart';
import '../widgets/conversion_progress_widget.dart';
import '../widgets/format_selector_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedFilePath;
  String? _selectedInputFormat;
  String _selectedOutputFormat = 'mp4';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'flv', 'wmv', 'webm', 'm4v', 'mpeg', 'mpg'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _selectedInputFormat = result.files.single.extension;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _startConversion() async {
    if (_selectedFilePath == null || _selectedInputFormat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file first')),
      );
      return;
    }

    final provider = context.read<ConversionProvider>();
    
    try {
      await provider.startConversion(
        inputPath: _selectedFilePath!,
        inputFormat: _selectedInputFormat!,
        outputFormat: _selectedOutputFormat,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversion started')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Format Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // File selection section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Video File',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedFilePath != null) ...[
                        Text(
                          'Selected: ${_selectedFilePath!.split('/').last}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Pick Video File'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Format selection
              if (_selectedInputFormat != null)
                FormatSelectorWidget(
                  inputFormat: _selectedInputFormat!,
                  selectedOutputFormat: _selectedOutputFormat,
                  onOutputFormatChanged: (format) {
                    setState(() {
                      _selectedOutputFormat = format;
                    });
                  },
                ),
              const SizedBox(height: 16),

              // Convert button
              ElevatedButton(
                onPressed: _selectedFilePath != null ? _startConversion : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Convert Video',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 24),

              // Conversion progress
              Expanded(
                child: Consumer<ConversionProvider>(
                  builder: (context, provider, child) {
                    if (provider.currentTask == null) {
                      return const Center(
                        child: Text('No active conversion'),
                      );
                    }
                    return ConversionProgressWidget(task: provider.currentTask!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
