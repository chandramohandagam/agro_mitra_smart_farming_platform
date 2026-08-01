import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/ai_model.dart';

class AIProvider extends ChangeNotifier {
  final AIService _service = AIService();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello there! I'm AgroMitra AI. How can I assist with your farm today?",
      sender: MessageSender.ai,
      timestamp: DateTime.now()
    ),
  ];

  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now()
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.sendMessage(text);
      _messages.add(response);
    } catch (e) {
      _messages.add(ChatMessage(
        text: "I'm having trouble connecting to my brain. Please try again.",
        sender: MessageSender.ai,
        timestamp: DateTime.now()
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
