import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/data/model/accept_task_model.dart';
import 'package:pikquick/features/task/data/model/bid_offer_model.dart';
import 'package:pikquick/features/task/data/model/rejecttask_model.dart';
import 'package:pikquick/features/task/domain/entitties/new_task_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;
  final String? amount;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
    required this.amount,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  NewTaskEntity task = NewTaskEntity();
  @override
  void initState() {
    super.initState();
    context
        .read<TaskBloc>()
        .add(GetTaskOverViewDetailsEvent(taskId: widget.taskId));
  }

  void _acceptTask(BuildContext context) {
    context.read<TaskBloc>().add(AcceptTaskbyrunnerEvent(
          model: AcceptTaskByRunnerModel(taskId: widget.taskId),
        ));
  }

  void _rejectTask(BuildContext context) {
    context.read<TaskBloc>().add(RejectTaskbyrunnerEvent(
          model: RunnerRejectTaskModel(taskId: widget.taskId),
        ));
  }

  void _showBidBottomSheet(BuildContext context) {
    int proposedAmount = 6000;
    final amountController =
        TextEditingController(text: proposedAmount.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is BidOfferSuccessState) {
              Navigator.pop(context); // Close the bid sheet
              _showBidSubmittedModal(context); // Show success modal
            } else if (state is BidOfferErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Text('Offer your bid',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '₦400',
                          suffixIcon: Image.asset('assets/icons/li.png',
                              height: 20, width: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            proposedAmount =
                                int.tryParse(value) ?? proposedAmount;
                          });
                        },
                      ),
                      const SizedBox(height: 7),
                      Text('Proposed amount: ₦$proposedAmount',
                          style: const TextStyle(fontSize: 10)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (proposedAmount > 0) {
                                setState(() {
                                  proposedAmount -= 100;
                                  amountController.text =
                                      proposedAmount.toString();
                                });
                              }
                            },
                            icon: const Icon(Icons.remove_circle),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                proposedAmount += 100;
                                amountController.text =
                                    proposedAmount.toString();
                              });
                            },
                            icon: const Icon(Icons.add_circle),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(
                                BidOfferEvent(
                                  model: InitialBidOfferModel(
                                    taskId: widget.taskId,
                                    amount: amountController.text,
                                  ),
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: BlocBuilder<TaskBloc, TaskState>(
                          builder: (context, state) {
                            if (state is BidofferLoadingState) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return const Text('Submit Bid');
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTaskAcceptedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          true, // set false if you don’t want to close by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // shrink to fit content
                children: [
                  Image.asset('assets/images/con2.png', height: 60, width: 100),
                  const SizedBox(height: 16),
                  const Text(
                    'Task Accepted',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You have accepted this task. Wait for the client\'s confirmation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTaskRejectedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          true, // false if you don't want it to close on outside tap
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // shrink to fit content
                children: [
                  Image.asset('assets/images/con2.png', height: 60, width: 100),
                  const SizedBox(height: 16),
                  const Text(
                    'Task Rejected',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You have rejected this task. The client will be notified.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is GetNewTaskDetailsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }

            if (state is AcceptTaskbyrunnerSuccessState) {
              _showTaskAcceptedDialog(context);
            }

            if (state is AcceptTaskbyrunnerErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is RejectTaskbyrunnerSuccessState) {
              _showTaskRejectedDialog(context);
            }

            if (state is RejectTaskbyrunnerErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is GetNewTaskDetailsSuccessState) {
              task = state.taskOverViewDetails;
            }
          },
          builder: (context, state) {
            if (state is GetNewTaskDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(MyAppRouteConstant
                                .availabeTask); // or any default/fallback route
                          }
                        },
                        child: const Icon(Icons.arrow_back_ios, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text('',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const Divider(height: 0, thickness: 0.5),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(task.description ?? 'No title provided',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Created at: ${task.createdAt ?? 'Unknown'}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Text('₦${task.budget ?? '0'}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () => _showBidBottomSheet(context),
                            child: const Text(
                              'Offer your Bid',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _taskActionButton(
                            onTap: () => _acceptTask(context),
                            color: const Color(0xFF4A85E4),
                            text: 'Accept Task',
                          ),
                          _taskActionButton(
                            onTap: () => _rejectTask(context),
                            color: Colors.red,
                            text: 'Reject Task',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text('Pickup Location',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('23 Allen Avenue, Ikeja',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      const Text('Dropoff Location',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('12 Admiralty Way, Lekki Phase 1',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      const Text('Task Description',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(
                          task.additionalNotes ??
                              'No additional notes provided.',
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 20),
                      const Text('Special Request',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(task.specialInstructions ?? 'None',
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: (userModelG?.imageUrl != null)
                                ? NetworkImage(userModelG!.imageUrl!)
                                : AssetImage('assets/images/circle.png'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.clientName ?? 'Client Name',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const Icon(Icons.verified,
                              color: Colors.green, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _taskActionButton({
    required VoidCallback onTap,
    required Color color,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FancyContainer(
        width: 167,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

void _showBidSubmittedModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset('assets/images/con2.png', height: 60, width: 60),
            const SizedBox(height: 16),
            const Text(
              'Bid Submitted',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your bid has been submitted. You will be notified once it\'s reviewed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    },
  );
}
