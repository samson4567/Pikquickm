// chat_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/chat/data/model/message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  String? _currentUserId; // To mark messages as 'isMe'

  ChatBloc() : super(ChatInitial()) {
    on<ConnectAndJoinChat>(_onConnectAndJoinChat);
    on<SendChatMessage>(_onSendChatMessage);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<ChatHistoryReceived>(_onChatHistoryReceived);
    on<WebSocketErrorOccurred>(_onWebSocketErrorOccurred);
  }

  void _onConnectAndJoinChat(
      ConnectAndJoinChat event, Emitter<ChatState> emit) {
    emit(ChatConnecting());
    _currentUserId = event.userId;

    try {
      Uri.parse(event.url);
      print("dasjdnjkandkajsndakjnda>>${Uri.parse(event.url)}");
      _channel = WebSocketChannel.connect(Uri.parse(event.url));

      _socketSubscription = _channel!.stream.listen(
        (data) => _handleIncomingData(data.toString()), // Process incoming data
        onError: (error) {
          add(const WebSocketErrorOccurred(
              'Connection Error', 'NETWORK_ISSUE'));
        },
        onDone: () {
          // If the chat was active, transition to disconnected state
          if (state is ChatLoaded) {
            emit((state as ChatLoaded).copyWith(isConnected: false));
          }
        },
      );

      // 1. Wait for connection (implicit) then send 'join_chat'
      final joinPayload = jsonEncode({
        'event': 'join_chat',
        'data': {'taskAssignmentId': event.taskAssignmentId},
      });
      _channel!.sink.add(joinPayload);
    } catch (e) {
      emit(const ChatError(
          'Failed to establish WebSocket connection', 'CONNECTION_FAILED'));
    }
  }

  void _handleIncomingData(String rawData) {
    try {
      final json = jsonDecode(rawData);
      final String event = json['event'];
      final dynamic data = json['data'];

      switch (event) {
        case 'chat_history':
          final List<ChatMessage> history = (data as List)
              .map((msgJson) => ChatMessage.fromJson(msgJson)
                  .copyWith(isMe: msgJson['senderId'] == _currentUserId))
              .toList();
          add(ChatHistoryReceived(history));
          break;
        case 'new_message':
          final ChatMessage message =
              ChatMessage.fromJson(data as Map<String, dynamic>)
                  .copyWith(isMe: data['senderId'] == _currentUserId);
          add(NewMessageReceived(message));
          break;
        case 'error':
          add(WebSocketErrorOccurred(
              data['message'] ?? 'Unknown Error', data['code'] ?? 'UNKNOWN'));
          break;
        // Handle other events like 'user_online', 'message_edited', etc.
        default:
          print('Unhandled event: $event');
      }
    } catch (e) {
      print('Error processing incoming WebSocket data: $e');
    }
  }

  void _onSendChatMessage(SendChatMessage event, Emitter<ChatState> emit) {
    if (_channel != null && state is ChatLoaded) {
      // 1. Create and send the 'send_message' payload
      final payload = jsonEncode({
        'event': 'send_message',
        'data': {
          'taskAssignmentId': event.taskAssignmentId,
          'message': event.content,
        },
      });
      _channel!.sink.add(payload);

      // 2. Optimistically update local state with the sent message (isMe: true)
      final tempMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
        taskAssignmentId: event.taskAssignmentId,
        senderId: _currentUserId!, // Assumes user ID is set
        content: event.content,
        timestamp: DateTime.now(),
        isMe: true,
      );

      final currentState = state as ChatLoaded;
      final updatedMessages = [tempMessage, ...currentState.messages];
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  void _onChatHistoryReceived(
      ChatHistoryReceived event, Emitter<ChatState> emit) {
    // History usually comes in reverse order, but we should verify and normalize if needed.
    // Assuming history is ordered oldest-to-newest for now.
    emit(ChatLoaded(messages: event.history.reversed.toList()));
  }

  void _onNewMessageReceived(
      NewMessageReceived event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      // OPTIONAL: If using optimistic updates, replace the temporary local message
      // with the server-confirmed message (requires matching content or temporary ID).

      // For simplicity, just prepend the new message
      final updatedMessages = [event.message, ...currentState.messages];
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  void _onWebSocketErrorOccurred(
      WebSocketErrorOccurred event, Emitter<ChatState> emit) {
    // Display error, maybe stop listening or attempt reconnection
    emit(ChatError(event.message, event.code));
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
