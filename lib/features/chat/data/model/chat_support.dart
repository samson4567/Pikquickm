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
      response: json['data']?['response'] ?? json['response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sessionId': sessionId,
    };
  }
}
