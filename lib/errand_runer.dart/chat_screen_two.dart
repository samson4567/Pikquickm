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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E7EB), width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(
                    fontFamily: 'Outfit', fontSize: 15, color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: "Start typing...",
                  hintStyle: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: _handleSubmitted,
              ),
            ),
            InkWell(
              onTap: () => _handleSubmitted(_textController.text),
              borderRadius: BorderRadius.circular(24),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.send, color: Color(0xFFB8BCCD), size: 24),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              child: const Icon(Icons.mic_none_rounded,
                  color: Color(0xFFB8BCCD), size: 24),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine)
            Padding(
              padding: const EdgeInsets.only(right: 6, top: 4),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFDADDE8),
                child: const Icon(Icons.person,
                    size: 16, color: Color(0xFF444655)),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMine)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      userModelG?.id ?? '',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10.0),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: isMine
                        ? const Color(0xFF3D73EB)
                        : const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMine ? 16 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.message ?? '',
                    style: TextStyle(
                      color: isMine ? Colors.white : Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Outfit',
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      "11:35 AM",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Outfit',
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all,
                          size: 16, color: Color(0xFF8DC8A4)),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black87, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chat with Michael O.",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
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
