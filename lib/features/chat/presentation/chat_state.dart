// chat_state.dart
import 'package:equatable/equatable.dart';
import 'package:pikquick/features/chat/data/model/message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatError extends ChatState {
  final String message;
  final String code;
  const ChatError(this.message, this.code);
  @override
  List<Object> get props => [message, code];
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isConnected;

  const ChatLoaded({required this.messages, this.isConnected = true});

  ChatLoaded copyWith({List<ChatMessage>? messages, bool? isConnected}) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [messages, isConnected];
}
