import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/message_chat.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientTaskOverviewProgress extends StatefulWidget {
  final String taskId;

  const ClientTaskOverviewProgress({
    super.key,
    required this.taskId,
  });

  @override
  State<ClientTaskOverviewProgress> createState() =>
      _ClientTaskOverviewProgressState();
}

class _ClientTaskOverviewProgressState
    extends State<ClientTaskOverviewProgress> {
  final List<String> stepTitles = [
    'Task Assigned',
    'Pickup Complete',
    'En Route',
    'Task Completed',
  ];

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTaskOverviewEvent(taskId: widget.taskId));
  }

  void _showPhoneNumberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "+1 234 567 8901",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      final Uri phoneUri =
                          Uri(scheme: 'tel', path: '+12345678901');
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not launch phone app')),
                        );
                      }
                    },
                    child: const Text("Call",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit')),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      context.pushNamed(MyAppRouteConstant.task);
                    },
                    child: const Text("Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMessagePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const MessagePage()));
  }

  /// 🔹 Handle bottom button tap logic
  void _handleBottomAction(GetTaskOverviewEntity task) {
    // final status = taskStatus?.toLowerCase() ?? "";

    if (task.status?.toLowerCase() == "task_completed") {
      context.go(MyAppRouteConstant.reviews, extra: task); // Ratings page
    } else {
      context
          .push(MyAppRouteConstant.mapBoxFullMapWidget); // Default to location
    }
  }

  /// 🔹 Text shown in the bottom button
  String _getBottomText(String? taskStatus) {
    final status = taskStatus?.toLowerCase() ?? "";

    if (status == "task_completed") {
      return "Add Ratings";
    }
    return "View Current Location"; // default
  }

  int _getCompletedSteps(String? taskStatus) {
    final status = taskStatus?.toLowerCase() ?? "";
    if (status == "start") return 1;
    if (status == "start delivery") return 2;
    if (status == "en route") return 3;
    if (status == "task_completed") return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is GetTaskOverviiewErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is GetTaskOverviiewLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetTaskOverviiewSuccessState) {
          final GetTaskOverviewEntity task = state.taskOverView;
          final completedSteps = _getCompletedSteps(task.status);

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                          onPressed: () {
                            context.pop();
                          }),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text('Task Details',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundImage: (userModelG?.imageUrl != null)
                              ? NetworkImage(userModelG!.imageUrl!)
                              : AssetImage('assets/images/circle.png')),
                      const SizedBox(width: 10),
                      Text(task.runnerName ?? '',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Outfit')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text("ETA: Jan 15, 2025 - 30:16 PM | ",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w200)),
                      Text("by car",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w200)),
                      SizedBox(width: 10),
                      Icon(Icons.car_crash_outlined,
                          color: Colors.black, size: 16),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: _showPhoneNumberDialog,
                        child: Row(
                          children: [
                            Image.asset('assets/images/call.png'),
                            const SizedBox(width: 10),
                            const Text("Call",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Outfit',
                                    color: Colors.blue)),
                          ],
                        ),
                      ),
                      const Text("|",
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Outfit',
                              color: Colors.grey)),
                      Row(
                        children: [
                          Image.asset('assets/images/message.png'),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _navigateToMessagePage,
                            child: const Text("Message",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Text(
                    task.status ?? '',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                        fontFamily: 'Outfit'),
                  ),
                  const SizedBox(height: 10),
                  Text(task.description ?? '',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  Text("₦${task.budget ?? '0'}",
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 4),
                  Text("${task.status ?? ''} | ${task.updatedAt ?? ''}",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 20),

                  // Address and Notes
                  const Text("Task Details",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  const Text("Pick Up Address",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit')),
                  const Text("Shoprite, Lekki Lagos",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  const Text("Drop-off Location",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit')),
                  const Text("12 Banana Island, Ikorodu",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  const Text("Additional Note",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Outfit')),
                  Text(task.additionalNotes ?? 'N/A',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 10),
                  const Text("Task ID",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Outfit')),
                  Text("#${task.id ?? 'N/A'}",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Outfit')),

                  const SizedBox(height: 20),
                  const Text("Status Updates",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 20),

                  // Status Stepper
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(stepTitles.length, (index) {
                      final isCompleted = index < completedSteps;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 15,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted
                                        ? Colors.red
                                        : Colors.grey[300],
                                  ),
                                  child: isCompleted
                                      ? const Icon(Icons.check,
                                          size: 14, color: Colors.white)
                                      : const SizedBox.shrink(),
                                ),
                                if (index < stepTitles.length - 1)
                                  Container(
                                      width: 1, height: 20, color: Colors.blue),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(stepTitles[index],
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Outfit')),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),

                  // Bottom Button
                  FancyContainer(
                    onTap: () => _handleBottomAction(task),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        _getBottomText(task.status),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Outfit',
                            color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text("No task data available"));
        }
      },
    );
  }
}
