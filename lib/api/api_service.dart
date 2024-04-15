import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:agrotech_app/model/prediction.dart';

class ApiService {
  // late Future<bool> _isRealDevice;
  final String _baseUrl = 'http://192.168.10.40:8000';

  Future<Map<String, dynamic>> predictImage(File pickedFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/predict'),
      );

      var fileStream = http.ByteStream(pickedFile.openRead());
      var length = await pickedFile.length();

      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: pickedFile.path.split('/').last,
      );

      request.files.add(multipartFile);

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedJson = jsonDecode(response.body);
        String predictionJsonString = decodedJson['prediction'];
        Prediction prediction =
            Prediction.fromJson(jsonDecode(predictionJsonString));
        return {'prediction': prediction, 'image': pickedFile};
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return {'error': 'Failed to predict image'};
      }
    } catch (e) {
      print('An error occurred: $e');
      return {'error': 'An error occurred during prediction'};
    }
  }

  Future<Map<String, dynamic>> fetchExplanationImage() async {
    try {
      final response = await http.post(Uri.parse('$_baseUrl/getExplaination'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('explanation_image')) {
          final String imageBase64 = responseData['explanation_image'];
          return {'imageBytes': base64Decode(imageBase64)};
        } else if (responseData.containsKey('message')) {
          return {'error': responseData['message']};
        } else {
          return {'error': 'Unknown error occurred'};
        }
      } else {
        return {
          'error':
              'Failed to fetch explanation image. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }
}
