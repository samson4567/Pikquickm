import 'package:pikquick/features/chat/domain/entities/chat_support_entities.dart';

class ChatSupportModel extends ChatSupportEntity {
  final String? response;

  const ChatSupportModel({
    required super.message,
    required super.sessionId,
    this.response,
  });

  factory ChatSupportModel.fromJson(Map<String, dynamic> json) {
    return ChatSupportModel(
      message: json['message'] ?? '',
      sessionId: json['sessionId'] ?? '',
      // Handles both {data: {response: "..."} } and {response: "..."}
      response: (json['data'] != null && json['data'] is Map)
          ? json['data']['response'] ?? ''
          : json['response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sessionId': sessionId,
    };
  }
}
