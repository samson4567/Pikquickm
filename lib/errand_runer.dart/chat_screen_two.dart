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
  // A list to hold the messages
  final List<String> _messages = [];
  // Controller for the text input field
  final TextEditingController _textController = TextEditingController();

  // Function to handle sending a message
  void _handleSubmitted(String text) {
    loadingMessage = TaskMessageEntity(
        id: Uuid().v4(),
        message: text,
        senderId:
            //  "sbdbsd"
            userModelG?.id);
    setState(() {});
    context.read<TaskBloc>().add(SendtaskAssignmentMessageEvent(
        taskAssignmentID: widget.taskAssignmentID,
        content: text,
        messageType: "text"));
    // Clear the text field
    _textController.clear();
    // Add the new message to the list and rebuild the UI
    setState(() {
      _messages.insert(0,
          text); // Insert at the beginning to show newest at bottom (reverse: true)
    });
  }

  @override
  initState() {
    context.read<TaskBloc>().add(GettaskAssignmentMessagesEvent(
          taskAssignmentID: widget.taskAssignmentID,
        ));
    super.initState();
  }

  List<TaskMessageEntity> displyedMessage = [];

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          // Text input field
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          // Send button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display an individual message
  Widget _buildMessage(TaskMessageEntity message) {
    bool isMine = message.senderId == userModelG?.id;
    // A simple container to represent a chat bubble
    return isMine
        ? Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .end, // Align all messages to the right for simplicity
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.8), // A nice background color
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: (loadingMessage?.id == message.id)
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          message.message ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (loadingMessage?.id == message.id)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Space for a simple avatar (optional)
                // const SizedBox(width: 8.0),
                // const CircleAvatar(child: Text('Me')),
              ],
            ),
          )
        : Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Align all messages to the right for simplicity
              children: <Widget>[
                // const CircleAvatar(child: Text('Me')),
                // const SizedBox(width: 8.0),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white, // A nice background color
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.8))),
                    child: Column(
                      crossAxisAlignment: (loadingMessage?.id == message.id)
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          message.message ?? '',
                          style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                          ),
                        ),
                        if (loadingMessage?.id == message.id)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                      ],
                    ),
                    // Text(
                    //   message.message??'',
                    //   style: const TextStyle(color: Colors.white),
                    // ),
                  ),
                ),
                // Space for a simple avatar (optional)
              ],
            ),
          );
  }

  TaskMessageEntity? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS
            ? 0.0
            : 4.0, // A subtle shadow effect
      ),
      body: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
        print("jsjkddhgsdjhsdjh-generally>>${state.runtimeType}");
        if (state is GettaskAssignmentMessagesEventErrorState) {
          print("jsjkddhgsdjhsdjh-generally>>${state.errorMessage}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );

          // if(displyedMessage.isEmpty)
          // {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.errorMessage)),
          // );}
        }
        if (state is GettaskAssignmentMessagesEventSuccessState) {
          displyedMessage = state.taskMessageEntity;
          displyedMessage.sort((a, b) => DateTime.parse(b.createdAt!)
              .compareTo(DateTime.parse(a.createdAt!)));

          // if(displyedMessage.isEmpty)
          // {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.errorMessage)),
          // );}
          Future.delayed(
            Duration(
              seconds: 10,
            ),
            () {
              try {
                context.read<TaskBloc>().add(GettaskAssignmentMessagesEvent(
                      taskAssignmentID: widget.taskAssignmentID,
                    ));
              } catch (e) {}
            },
          );
        }
        if (state is SendtaskAssignmentMessageEventSuccessState) {
          print("jsjkddhgsdjhsdjh-sdjbsjhdsad-sucess");
          loadingMessage = null;
          displyedMessage.add(state.taskMessageEntity);
          displyedMessage.sort((a, b) => DateTime.parse(b.createdAt!)
              .compareTo(DateTime.parse(a.createdAt!)));
        }
        if (state is SendtaskAssignmentMessageEventErrorState) {
          print("jsjkddhgsdjhsdjh-sdjbsjhdsad-error-${state.errorMessage}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Message Sending Failed")),
          );
        }
      }, builder: (context, state) {
        return Column(
          children: <Widget>[
            // Message list area
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                // Reverse the list so the newest message is at the bottom
                reverse: true,
                itemBuilder: (_, int index) =>
                    _buildMessage(displyedMessage[index]),
                itemCount: displyedMessage.length,
              ),
            ),
            if (loadingMessage != null) _buildMessage(loadingMessage!),
            // Divider between list and input
            const Divider(height: 1.0),
            // Input area
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        );
      }),
    );
  }
}
