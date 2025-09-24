import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/data/model/complete_task_model.dart';
import 'package:pikquick/features/task/data/model/start_task_model.dart';
import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/runner_task_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/message_chat.dart';
import 'package:pikquick/router/router_config.dart';

class TaskOverview extends StatefulWidget {
  final String taskId;
  const TaskOverview({super.key, required this.taskId});

  @override
  State<TaskOverview> createState() => _TaskOverviewState();
}

class _TaskOverviewState extends State<TaskOverview>
    with SingleTickerProviderStateMixin {
  int _currentStatusIndex = 0;
  late AnimationController _controller;

  // local copy of the task so the UI doesn't depend on transient bloc states
  RunnerTaskOverviewEntity? _task;

  bool _isStarting = false; // true while StartTask API call is in progress
  bool _isStarted = false; // true once task is started (or API says started)
  bool _isStartDialogOpen = false; // track loading dialog presence

  bool _isCompleting = false;
  bool _isCompleted = false;
  bool _isCompleteDialogOpen = false;

  final List<Map<String, String>> _taskSteps = [
    {'status': 'Task Assigned', 'action': 'Start Task'},
    {'status': 'In Progress', 'action': 'Complete'},
    {'status': 'Task Completed', 'action': 'Submit for Approval'},
  ];

  @override
  void initState() {
    super.initState();

    // request task overview
    context
        .read<TaskBloc>()
        .add(RunnerTaskOverviewgEvent(taskId: widget.taskId));

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showPhoneNumberDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Client's Phone Number"),
        content: const Text("Call +234 901 234 5678"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  void _navigateToMessagePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MessagePage()));
  }

  void _showLoadingDialog(String message, {bool isStart = true}) {
    if (isStart ? _isStartDialogOpen : _isCompleteDialogOpen) return;

    if (isStart) {
      _isStartDialogOpen = true;
    } else {
      _isCompleteDialogOpen = true;
    }

    // show non-dismissible starting dialog immediately when Start tapped
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    ).then((_) {
      if (isStart) {
        _isStartDialogOpen = false;
      } else {
        _isCompleteDialogOpen = false;
      }
    });
  }

  // show success dialog (simple)
  void _showSuccessModal(String title, String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/con2.png', height: 60, width: 100),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xFF4378CD),
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is RunnerTaskOverViewSuccessState) {
                setState(() {
                  _task = state.taskOverView;
                  final status =
                      (state.taskOverView.status ?? '').toLowerCase();
                  if (status.contains('start')) {
                    _isStarted = true;
                    _currentStatusIndex = 1;
                  }
                  if (status.contains('completed')) {
                    _isCompleted = true;
                    _currentStatusIndex = 2;
                  }
                });
              }

              if (state is RunnerTaskOverViewErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }

              // Start task handling
              if (state is StartTaskLoadingState) {
              } else if (state is StartTaskSuccessState) {
                if (_isStartDialogOpen) Navigator.of(context).pop();
                setState(() {
                  _isStarting = false;
                  _isStarted = true;
                  _currentStatusIndex = 1;
                });
                _showSuccessModal(
                    "Task Started", "You have successfully started your task.");
              } else if (state is StartTaskErrorState) {
                if (_isStartDialogOpen) Navigator.of(context).pop();
                setState(() => _isStarting = false);
                _showErrorDialog("Error", state.message);
              }

              // Complete task handling
              if (state is MarkAsCompletedLoadingState) {
              } else if (state is MarkAsCompletedSuccessState) {
                if (_isCompleteDialogOpen) Navigator.of(context).pop();
                setState(() {
                  _isCompleting = false;
                  _isCompleted = true;
                  _currentStatusIndex = 2;
                });
                _showSuccessModal("Task Completed",
                    "You have successfully completed your task.");
              } else if (state is MarkAsCompletedErrorState) {
                if (_isCompleteDialogOpen) Navigator.of(context).pop();
                setState(() => _isCompleting = false);
                _showErrorDialog("Error", state.message);
              }
            },
          ),
        ],
        child: _task == null
            ? const Center(child: CircularProgressIndicator())
            : buildTaskOverviewContent(_task!),
      ),
    );
  }

  Widget buildTaskOverviewContent(RunnerTaskOverviewEntity task) {
    bool isInProgress = _currentStatusIndex == 1;
    bool isCompleted = _currentStatusIndex == 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Icon(Icons.arrow_back_ios)),
          const SizedBox(height: 20),
          const Text('Task Overview',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit')),
          const SizedBox(height: 10),
          Text(task.taskType ?? 'No Title',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit')),
          const SizedBox(height: 5),
          Text("₦${task.budget}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontFamily: 'Outfit')),
          const Divider(height: 20, thickness: 1.2),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/circle.png')),
              const SizedBox(width: 10),
              Text(task.clientName ?? "No Name",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Outfit')),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.star, color: Colors.orange, size: 18),
              Text("4.8(72 reviews) | ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
              Text(" 85 errands requested ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
            ],
          ),
          const SizedBox(height: 20),
          messageMethod(),
          const Divider(height: 30, thickness: 1),
          Text(
            "Location:",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('PickUp  : ', style: TextStyle(fontSize: 14)),
              Text('N/A', style: const TextStyle(fontSize: 14)),
            ],
          ),
          Row(
            children: [
              const Text('DropOff : ', style: TextStyle(fontSize: 14)),
              Text('' 'N/A', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 5),
          Text("TaskID : ${task.id ?? "N/A"}"),
          const SizedBox(height: 20),
          const Text('Description', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(task.description ?? "No Description",
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          const Text('Special Request', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(task.specialInstructions ?? "None",
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 20),
          const Text("Task Status Progression",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const Text("Update your progression as you proceed",
              style: TextStyle(fontSize: 12)),
          const SizedBox(height: 10),
          Column(
            children: List.generate(_taskSteps.length, (index) {
              final isCompletedStep = index < _currentStatusIndex;
              final isCurrent = index == _currentStatusIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isCurrent ? Colors.blue : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: isCompletedStep ? Colors.blue.shade50 : Colors.white,
                  boxShadow: [
                    if (isCurrent)
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          offset: const Offset(0, 3),
                          blurRadius: 6)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            isCompletedStep
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isCompletedStep ? Colors.blue : Colors.grey,
                            key: ValueKey<bool>(isCompletedStep),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _taskSteps[index]['status']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isCompletedStep ? Colors.blue : Colors.black,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                    if (isCurrent)
                      // special handling for the first action (Start Task)
                      index == 0
                          ? _isStarted
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.check, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text(
                                        'Started',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              : TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: _isStarting
                                      ? null
                                      : () {
                                          // immediate UX: show starting dialog first
                                          setState(() {
                                            _isStarting = true;
                                          });
                                          _showLoadingDialog(
                                              "Starting task..."); // dispatch StartTask event
                                          final startTaskModel = StartTaskModel(
                                            taskId: task.id ?? '',
                                          );
                                          context.read<TaskBloc>().add(
                                              StartTaskEvent(
                                                  startTask: startTaskModel));
                                        },
                                  child: Text(
                                    _isStarting ? 'Starting...' : 'Start Task',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Outfit'),
                                  ),
                                )
                          // special handling for the second action (Complete)
                          : index == 1
                              ? _isCompleted
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.check,
                                              color: Colors.green),
                                          SizedBox(width: 8),
                                          Text(
                                            'Completed',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                      ),
                                      onPressed: _isCompleting
                                          ? null
                                          : () {
                                              setState(
                                                  () => _isCompleting = true);
                                              _showLoadingDialog(
                                                  "Completing task...",
                                                  isStart: false);
                                              context.read<TaskBloc>().add(
                                                  MarkAsCompletedEvent(
                                                      markAsCompleted:
                                                          MarkAsCompletedModel(
                                                              taskId: task.id ??
                                                                  '')));
                                            },
                                      child: Text(
                                        _isCompleting
                                            ? "Completing..."
                                            : _taskSteps[index]['action']!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Outfit'),
                                      ),
                                    )
                              // For other steps (index 2)
                              : TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_currentStatusIndex <
                                          _taskSteps.length - 1) {
                                        _currentStatusIndex++;
                                        _controller.forward(from: 0);
                                      }
                                    });
                                  },
                                  child: Text(
                                    _taskSteps[index]['action']!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Outfit'),
                                  ),
                                ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          if (isInProgress)
            Center(
              child: FancyContainer(
                onTap: () {
                  context.go(MyAppRouteConstant.preMapPageForTesting);
                },
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
                height: 50,
                width: 342,
                child: const Center(
                  child: Text(
                    'View current location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          if (isCompleted) ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Upload proof of your completion',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Outfit'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: FancyContainer(
                onTap: () {
                  context.go(MyAppRouteConstant.google);
                },
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
                height: 150,
                width: 342,
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        'Click here to upload image',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Add note', style: TextStyle(fontSize: 15)),
            ),
            const SizedBox(height: 10),
            Center(child: _buildReviewInput()),
            const SizedBox(height: 20),
            Center(
              child: FancyContainer(
                onTap: () {
                  context.go(
                    MyAppRouteConstant.runnerviews,
                    extra: task, // ✅ pass the instance
                  );
                },
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
                height: 50,
                width: 342,
                child: const Center(
                  child: Text(
                    'Add reviews & ratings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Submitted for Approval!")));
                },
                child: const Text(
                  'Submit for Approval',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Row messageMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: _showPhoneNumberDialog,
          child: Row(
            children: [
              Image.asset('assets/images/call.png', fit: BoxFit.cover),
              const SizedBox(width: 10),
              const Text("Call",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: 'Outfit')),
            ],
          ),
        ),
        const Text("|", style: TextStyle(fontSize: 17, color: Colors.grey)),
        GestureDetector(
          // onTap: _navigateToMessagePage,
          child: Row(
            children: [
              Image.asset('assets/images/message.png', fit: BoxFit.cover),
              const SizedBox(width: 10),
              const Text("Message",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: 'Outfit')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewInput() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 350,
      height: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
              blurRadius: 5)
        ],
      ),
      child: const TextField(
        maxLines: 5,
        decoration: InputDecoration(
          hintText: "Share your thoughts about this task\n(optional)",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
