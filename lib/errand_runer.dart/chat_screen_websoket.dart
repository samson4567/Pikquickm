// chat_screen.dart (Simplified view)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/core/constants/app_constants.dart';
import 'package:pikquick/features/chat/presentation/chat_bloc.dart';
import 'package:pikquick/features/chat/presentation/chat_event.dart';
import 'package:pikquick/features/chat/presentation/chat_state.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  final String taskId;
  //  = '12345'; // Example Task ID
  final String userId;
  //  = 'user_abc'; // Example User ID
  final String wsUrl;
  //  =
  // 'ws://your-websocket-server/chat'; // Replace with actual URL

  ChatScreen({
    super.key,
    required this.taskId,
    required this.userId,
    required this.wsUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Must dispatch the event to connect and join the room
    context.read<ChatBloc>().add(ConnectAndJoinChat(wsUrl, taskId, userId));

    return Scaffold(
      // ... app bar ...
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatConnecting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatError) {
                  return Center(
                      child: Text('Error ${state.code}: ${state.message}',
                          style: const TextStyle(color: Colors.red)));
                }
                if (state is ChatLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      // Display message bubble using message.isMe
                      return ListTile(
                        title: Text(message.content),
                        trailing: message.isMe ? const Icon(Icons.check) : null,
                      );
                    },
                  );
                }
                return const Center(child: Text('Initializing Chat...'));
              },
            ),
          ),
          // Input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(labelText: 'Message')),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      context
                          .read<ChatBloc>()
                          .add(SendChatMessage(taskId, text));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
