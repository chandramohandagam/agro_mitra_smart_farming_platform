import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../models/disease_model.dart';

class DiseaseService {
  final ApiClient _apiClient = ApiClient();

  Future<DiseaseDetectionResult> detectDisease(String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await _apiClient.post('/api/v1/disease/detect', data: formData);
    return DiseaseDetectionResult.fromJson(response.data);
  }
}
