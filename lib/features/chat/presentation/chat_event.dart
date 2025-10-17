// chat_event.dart
import 'package:equatable/equatable.dart';
import 'package:pikquick/features/chat/data/model/message_model.dart';
import 'package:pikquick/features/chat/domain/entities/chat_support_entities.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

// 1. Client --> Server Events (Outgoing)
class ConnectAndJoinChat extends ChatEvent {
  final String url;
  final String taskAssignmentId;
  final String userId;
  const ConnectAndJoinChat(this.url, this.taskAssignmentId, this.userId);
  @override
  List<Object> get props => [url, taskAssignmentId, userId];
}

class SendChatMessage extends ChatEvent {
  final String taskAssignmentId;
  final String content;
  const SendChatMessage(this.taskAssignmentId, this.content);
  @override
  List<Object> get props => [taskAssignmentId, content];
}

// 2. Server --> Client Events (Incoming)
class ChatHistoryReceived extends ChatEvent {
  final List<ChatMessage> history;
  const ChatHistoryReceived(this.history);
  @override
  List<Object> get props => [history];
}

class NewMessageReceived extends ChatEvent {
  final ChatMessage message;
  const NewMessageReceived(this.message);
  @override
  List<Object> get props => [message];
}

class WebSocketErrorOccurred extends ChatEvent {
  final String message;
  final String code;
  const WebSocketErrorOccurred(this.message, this.code);
  @override
  List<Object> get props => [message, code];
}
// ... other incoming events (user_online, message_read, etc.)
