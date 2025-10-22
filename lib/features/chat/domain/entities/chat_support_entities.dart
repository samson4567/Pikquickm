import 'package:equatable/equatable.dart';

class ChatSupportEntity extends Equatable {
  final String message;
  final String sessionId;
  final String? response; // ✅ Add this

  const ChatSupportEntity({
    required this.message,
    required this.sessionId,
    this.response,
  });

  @override
  List<Object?> get props => [message, sessionId, response];
}
