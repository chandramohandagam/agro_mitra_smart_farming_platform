enum MessageSender { ai, user }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final AIInsightCard? insight;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.insight,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.ai,
      timestamp: DateTime.parse(json['timestamp']),
      insight: json['insight'] != null ? AIInsightCard.fromJson(json['insight']) : null,
    );
  }
}

class AIInsightCard {
  final String title;
  final String content;
  final double progress;
  final String statusLabel;
  final String actionLabel;

  AIInsightCard({
    required this.title,
    required this.content,
    required this.progress,
    required this.statusLabel,
    required this.actionLabel,
  });

  factory AIInsightCard.fromJson(Map<String, dynamic> json) {
    return AIInsightCard(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      statusLabel: json['status_label'] ?? '',
      actionLabel: json['action_label'] ?? 'Action',
    );
  }
}
