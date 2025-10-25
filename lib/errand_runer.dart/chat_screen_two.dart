import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/features/task/domain/entitties/task_message_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:uuid/uuid.dart';

class ChatScreenTwo extends StatefulWidget {
  final String taskAssignmentID;
  const ChatScreenTwo({super.key, required this.taskAssignmentID});

  @override
  State<ChatScreenTwo> createState() => _ChatScreenTwoState();
}

class _ChatScreenTwoState extends State<ChatScreenTwo> {
  final TextEditingController _textController = TextEditingController();
  List<TaskMessageEntity> displyedMessage = [];
  TaskMessageEntity? loadingMessage;

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    loadingMessage = TaskMessageEntity(
      id: const Uuid().v4(),
      message: text,
      senderId: userModelG?.id,
    );

    setState(() {});
    context.read<TaskBloc>().add(SendtaskAssignmentMessageEvent(
        taskAssignmentID: widget.taskAssignmentID,
        content: text,
        messageType: "text"));
    _textController.clear();
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GettaskAssignmentMessagesEvent(
          taskAssignmentID: widget.taskAssignmentID,
        ));
  }

  Widget _buildTextComposer() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 3)
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                      hintText: "Type a message...", border: InputBorder.none),
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _handleSubmitted(_textController.text),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF8E9CF3), // bluish-purple send button
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(TaskMessageEntity message) {
    bool isMine = message.senderId == userModelG?.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isMine
                  ? const Color(0xFFDCE3FF)
                  : Colors.white, // Blue-tint for user, white for other
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMine ? 18 : 4),
                bottomRight: Radius.circular(isMine ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 3)
              ],
            ),
            child: Text(
              message.message ?? '',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding:
                EdgeInsets.only(left: isMine ? 0 : 8, right: isMine ? 8 : 0),
            child: Text(
              '',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E9CF3),
        elevation: 0,
        title: const Text('Chat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is GettaskAssignmentMessagesEventErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
          if (state is GettaskAssignmentMessagesEventSuccessState) {
            displyedMessage = state.taskMessageEntity;
            displyedMessage.sort((a, b) => DateTime.parse(a.createdAt!)
                .compareTo(DateTime.parse(b.createdAt!)));
            Future.delayed(const Duration(seconds: 10), () {
              try {
                context.read<TaskBloc>().add(GettaskAssignmentMessagesEvent(
                      taskAssignmentID: widget.taskAssignmentID,
                    ));
              } catch (_) {}
            });
          }
          if (state is SendtaskAssignmentMessageEventSuccessState) {
            loadingMessage = null;
            displyedMessage.add(state.taskMessageEntity);
            displyedMessage.sort((a, b) => DateTime.parse(a.createdAt!)
                .compareTo(DateTime.parse(b.createdAt!)));
          }
          if (state is SendtaskAssignmentMessageEventErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Message Sending Failed")),
            );
            loadingMessage = null;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: displyedMessage.length,
                  itemBuilder: (_, index) {
                    return _buildMessage(displyedMessage[index]);
                  },
                ),
              ),
              if (loadingMessage != null) _buildMessage(loadingMessage!),
              _buildTextComposer(),
            ],
          );
        },
      ),
    );
  }
}
