import '../api/api_client.dart';
import '../models/ai_model.dart';

class AIService {
  final ApiClient _apiClient = ApiClient();

  Future<ChatMessage> sendMessage(String text) async {
    final response = await _apiClient.post('/api/v1/ai/chat', data: {'message': text});
    return ChatMessage.fromJson(response.data);
  }
}
