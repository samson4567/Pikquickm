import 'package:equatable/equatable.dart';

class ChatSupportEntity extends Equatable {
  final String message;
  final String sessionId;

  const ChatSupportEntity({
    required this.message,
    required this.sessionId,
  });

  @override
  List<Object> get props => throw UnimplementedError();
}
