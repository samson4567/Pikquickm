import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/chat/data/model/chat_support.dart';

import 'package:pikquick/features/wallet/presentation/wallet_bloc.dart';
import 'package:pikquick/features/wallet/presentation/wallet_event.dart';
import 'package:pikquick/features/wallet/presentation/wallet_state.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage(BuildContext context, String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"text": text, "isSender": true});
      });

      // Dispatch BLoC event
      final chat = ChatSupportModel(
        message: text,
        sessionId:
            "user-123-session-456", // Replace with your dynamic session ID
      );

      context.read<WalletBloc>().add(SendChatMessageEvent(chat));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/james.jpg'),
              radius: 18,
            ),
            const SizedBox(width: 10),
            const Text(
              "Chat Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is ChatSupportSuccess) {
            setState(() {
              _messages.add({
                "text": state.chat ?? "Response received",
                "isSender": false,
              });
            });
          } else if (state is ChatSupportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message["isSender"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: message["isSender"]
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: message["isSender"]
                                ? const Radius.circular(16)
                                : const Radius.circular(4),
                            bottomRight: message["isSender"]
                                ? const Radius.circular(4)
                                : const Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          message["text"],
                          style: TextStyle(
                            color: message["isSender"]
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state is ChatSupportLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () =>
                          _sendMessage(context, _controller.text.trim()),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
