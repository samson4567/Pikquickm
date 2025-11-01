import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/data/model/complete_task_model.dart';
import 'package:pikquick/features/task/data/model/start_task_model.dart';
import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/runner_task_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/global_objects.dart';
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

  RunnerTaskOverviewEntity? _task;

  bool _isStarting = false;
  bool _isStarted = false;
  bool _isStartDialogOpen = false;

  bool _isCompleting = false;
  bool _isCompleted = false;
  bool _isCompleteDialogOpen = false;

  final List<Map<String, String>> _taskSteps = [
    {'status': 'Task Assigned', 'action': 'Start Task'},
    {'status': 'In Progress', 'action': 'Mark Completed'},
    {'status': 'Task Completed', 'action': 'Submit for Approval'},
  ];

  @override
  void initState() {
    super.initState();
    context
        .read<TaskBloc>()
        .add(RunnerTaskOverviewgEvent(taskId: widget.taskId));
    context.read<TaskBloc>().add(ActivetaskEvent());

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showPhoneNumberDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Client's Phone Number"),
        content: Text("Call ${_task!.clientPhone}"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              makePhoneCall(_task!.clientPhone!);
            },
            child: const Text("Call",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _navigateToMessagePage(RunnerTaskOverviewEntity task) {
    context.push(MyAppRouteConstant.chatScreenTwo,
        extra: taskAssignmentEntity?.id ?? "");
  }

  void _showLoadingDialog(String message, {bool isStart = true}) {
    if (isStart ? _isStartDialogOpen : _isCompleteDialogOpen) return;
    if (isStart) {
      _isStartDialogOpen = true;
    } else {
      _isCompleteDialogOpen = true;
    }

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
              Text(title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit')),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK",
                    style: TextStyle(color: Color(0xFF4378CD))),
              ),
            ],
          ),
        );
      },
    );
  }

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

  ActiveTaskPendingEntity? taskAssignmentEntity;
  bool canCommunicate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is ActivetaskErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }

              if (state is ActivetaskSuccessState) {
                taskAssignmentEntity = state.runnertask
                    .where((element) => element.taskId == widget.taskId)
                    .firstOrNull;
                canCommunicate = taskAssignmentEntity != null;
                setState(() {});
              }

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

              if (state is StartTaskSuccessState) {
                if (_isStartDialogOpen) Navigator.of(context).pop();
                setState(() {
                  _isStarting = false;
                  _isStarted = true;
                  _currentStatusIndex = 1;
                });
                _showSuccessModal(
                    "Task Started", "You have successfully started your task.");
              }

              if (state is StartTaskErrorState) {
                if (_isStartDialogOpen) Navigator.of(context).pop();
                setState(() => _isStarting = false);
                _showErrorDialog("Error", state.message);
              }

              if (state is MarkAsCompletedSuccessState) {
                if (_isCompleteDialogOpen) Navigator.of(context).pop();
                setState(() {
                  _isCompleting = false;
                  _isCompleted = true;
                  _currentStatusIndex = 2;
                });
                _showSuccessModal("Task Completed",
                    "You have successfully completed your task.");
              }

              if (state is MarkAsCompletedErrorState) {
                if (_isCompleteDialogOpen) Navigator.of(context).pop();
                setState(() => _isCompleting = false);
                _showErrorDialog("Error", state.message);
              }
            },
          ),
        ],
        child: _task == null
            ? const Center(child: CircularProgressIndicator())
            : _buildTaskContent(_task!),
      ),
    );
  }

  Widget _buildTaskContent(RunnerTaskOverviewEntity task) {
    bool isInProgress = _currentStatusIndex == 1;
    bool isCompleted = _currentStatusIndex == 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          const Text('Task Overview',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit')),
          const SizedBox(height: 12),
          Text(task.taskType ?? '',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit')),
          const SizedBox(height: 6),
          Text("₦${task.budget ?? '0'}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit')),
          const Divider(height: 28, thickness: 1.2),
          const SizedBox(height: 8),
          Row(
            children: [
              const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/circle.png')),
              const SizedBox(width: 10),
              Text(task.clientName ?? "No Name",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit')),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/stars.svg', // <-- SVG file path
                width: 32.w,
                height: 20.w,
                fit: BoxFit.cover,
              ),
              Text("4.8 (72 Reviews) | 85 errands requested",
                  style: TextStyle(fontSize: 15, color: Color(0XFF434953))),
            ],
          ),
          const SizedBox(height: 20),
          if (canCommunicate) _contactOptions(),
          const Divider(height: 30, thickness: 1.2),
          const Text("Location:",
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Pickup: ", style: TextStyle(fontSize: 14)),
              Text('' ?? 'N/A', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text("Drop-off: ", style: TextStyle(fontSize: 14)),
              Text('' ?? 'N/A', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Text("Task ID: ${task.id ?? 'N/A'}",
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 20),
          const Text('Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(task.description ?? 'No Description',
              style: const TextStyle(fontSize: 15, color: Color(0XFF434953))),
          const SizedBox(height: 15),
          const Text('Special Request',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(task.specialInstructions ?? 'None',
              style: const TextStyle(fontSize: 15, color: Color(0XFF434953))),
          const SizedBox(height: 25),
          const Text('Task Status Progression',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const Text('Update your progress as you proceed\nwith task ',
              style: TextStyle(fontSize: 15, color: Color(0XFF434953))),
          const SizedBox(height: 12),
          _buildStatusSteps(),
          if (isInProgress)
            Center(
              child: FancyContainer(
                onTap: () {
                  context.go(MyAppRouteConstant.preMapPageForTesting);
                },
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
                height: 50,
                width: double.infinity,
                child: const Center(
                  child: Text('View current location',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
              ),
            ),
          if (isCompleted) _buildCompletionSection(task),
        ],
      ),
    );
  }

  Widget _buildStatusSteps() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          const Padding(
            padding: EdgeInsets.only(bottom: 12, left: 36, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Action Button',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Timeline rows
          Column(
            children: List.generate(_taskSteps.length, (index) {
              final isCompletedStep = index < _currentStatusIndex;
              final isCurrent = index == _currentStatusIndex;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline indicator and line
                  Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompletedStep
                              ? const Color(0xFF34C759)
                              : Colors.white,
                          border: Border.all(
                            color: isCompletedStep
                                ? const Color(0xFF34C759)
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      if (index != _taskSteps.length - 1)
                        Container(
                          width: 2,
                          height: 45,
                          color: Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Status text and action button
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _taskSteps[index]['status']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              color: isCompletedStep
                                  ? Colors.black87
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isCurrent)
                            _buildActionButton(index)
                          else
                            const SizedBox(width: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(int index) {
    if (index == 0) {
      return _isStarted
          ? _statusTag('Started', Colors.green)
          : _actionButton("Start Task", Colors.white, () {
              setState(() => _isStarting = true);
              _showLoadingDialog("Starting task...");
              final model = StartTaskModel(taskId: _task!.id ?? '');
              context.read<TaskBloc>().add(StartTaskEvent(startTask: model));
            });
    } else if (index == 1) {
      return _isCompleted
          ? _statusTag('Completed', Colors.green)
          : _actionButton("Mark Completed", Colors.white, () {
              setState(() => _isCompleting = true);
              _showLoadingDialog("Completing task...", isStart: false);
              final model = MarkAsCompletedModel(taskId: _task?.id ?? '');
              context
                  .read<TaskBloc>()
                  .add(MarkAsCompletedEvent(markAsCompleted: model));
            });
    } else {
      return _actionButton("Submit for Approval", Colors.green, () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Submitted for Approval successfully!")));
      });
    }
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white, // ✅ white background like in screenshot
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.blue, // ✅ blue borderline
            width: 1.5,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black, // ✅ blue text
          fontSize: 14,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statusTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color)),
      child: Row(children: [
        Icon(Icons.check, color: color, size: 16),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit')),
      ]),
    );
  }

  Widget _buildCompletionSection(RunnerTaskOverviewEntity task) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Upload proof of your completion',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        FancyContainer(
          onTap: () => context.go(MyAppRouteConstant.google),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
          height: 150,
          width: double.infinity,
          child: const Center(
            child: Text('Click here to upload image',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 15)),
          ),
        ),
        const SizedBox(height: 15),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text('Add note',
                style: TextStyle(fontSize: 15, fontFamily: 'Outfit'))),
        const SizedBox(height: 8),
        _buildReviewInput(),
        const SizedBox(height: 25),
        FancyContainer(
          onTap: () {
            context.go(
              MyAppRouteConstant.runnerviews,
              extra: task, // ✅ pass the instance
            );
          },
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
          height: 50,
          width: double.infinity,
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
        const SizedBox(height: 25),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Submitted for Approval successfully!")),
              );
            },
            child: const Text(
              'Submit for Approval',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildReviewInput() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
      ),
      child: const TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Share your thoughts about this task (optional)",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontFamily: 'Outfit',
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Row _contactOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            if (_task?.clientPhone != null) {
              _showPhoneNumberDialog();
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar("No phone number provided"));
            }
          },
          child: Row(
            children: [
              Image.asset('assets/images/call.png',
                  width: 20, height: 20, fit: BoxFit.cover),
              const SizedBox(width: 8),
              const Text(
                "Call",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ),
        const Text("|", style: TextStyle(fontSize: 18, color: Colors.grey)),
        GestureDetector(
          onTap: () {
            if (_task == null) return;
            _navigateToMessagePage(_task!);
          },
          child: Row(
            children: [
              Image.asset('assets/images/message.png',
                  width: 20, height: 20, fit: BoxFit.cover),
              const SizedBox(width: 8),
              const Text(
                "Message",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
