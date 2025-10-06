// Basic model for a chat message
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String taskAssignmentId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isMe; // Helper field for UI

  const ChatMessage({
    required this.id,
    required this.taskAssignmentId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isMe = false,
  });

  // Factory method to deserialize from the JSON data received from 'new_message' or 'chat_history'
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      taskAssignmentId: json['taskAssignmentId'] as String,
      senderId: json['senderId'] as String,
      content: json['message']
          as String, // Assuming server uses 'message' for content
      timestamp: DateTime.parse(
          json['timestamp'] as String), // Adjust key if necessary
    );
  }

  // Method to create a local message before server confirmation
  ChatMessage copyWith({bool? isMe}) {
    return ChatMessage(
      id: id,
      taskAssignmentId: taskAssignmentId,
      senderId: senderId,
      content: content,
      timestamp: timestamp,
      isMe: isMe ?? this.isMe,
    );
  }

  @override
  List<Object> get props =>
      [id, taskAssignmentId, senderId, content, timestamp, isMe];
}
