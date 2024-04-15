import 'dart:typed_data';
import 'package:agrotech_app/api/api_service.dart';
import 'package:agrotech_app/components/image_popup.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  static const route = '/analysis-screen';
  const AnalysisScreen({super.key});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Uint8List? _imageBytes;
  String? _errorMessage;
  late ApiService _apiService;

  @override
  void initState() {
    _apiService = ApiService();
    _fetchExplanationImage();
    super.initState();
  }

  Future<void> _fetchExplanationImage() async {
    Map<String, dynamic> result = await _apiService.fetchExplanationImage();
    if (result.containsKey('imageBytes')) {
      Uint8List imageBytes = result['imageBytes'] as Uint8List;
      setState(() {
        _imageBytes = imageBytes;
      });
    } else if (result.containsKey('error')) {
      String error = result['error'] as String;
      print('Error: $error');

      setState(() {
        _errorMessage = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explanation'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!),
      );
    } else if (_imageBytes != null) {
      return Center(
        child: ImagePopup(
          imageFile: MemoryImage(_imageBytes!),
          width: double.infinity,
          height: null,
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
