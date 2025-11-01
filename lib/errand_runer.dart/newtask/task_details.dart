import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              Navigator.pop(context);
              _showBidSubmittedModal(context);
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Text(
                        'Offer your bid',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
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
                      const SizedBox(height: 8),
                      Text('Proposed amount: ₦$proposedAmount',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
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
                            icon: const Icon(Icons.remove_circle_outline),
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
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
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
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
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
                              return const Text('Submit Bid',
                                  style: TextStyle(color: Colors.white));
                            },
                          ),
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
    _showCustomDialog(
      context,
      title: 'Task Accepted',
      message:
          'You have accepted this task. Wait for the client\'s confirmation.',
      color: Colors.deepPurple,
    );
  }

  void _showTaskRejectedDialog(BuildContext context) {
    _showCustomDialog(
      context,
      title: 'Task Rejected',
      message: 'You have rejected this task. The client will be notified.',
      color: Colors.redAccent,
    );
  }

  void _showCustomDialog(BuildContext context,
      {required String title, required String message, required Color color}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/con2.png', height: 60, width: 100),
                const SizedBox(height: 16),
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(message,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is GetNewTaskDetailsErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
            if (state is AcceptTaskbyrunnerSuccessState) {
              _showTaskAcceptedDialog(context);
            }
            if (state is AcceptTaskbyrunnerErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is RejectTaskbyrunnerSuccessState) {
              _showTaskRejectedDialog(context);
            }
            if (state is RejectTaskbyrunnerErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is GetNewTaskDetailsSuccessState) {
              task = state.taskOverViewDetails;
            }
          },
          builder: (context, state) {
            if (state is GetNewTaskDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(MyAppRouteConstant.availabeTask);
                            }
                          },
                          child: const Icon(Icons.arrow_back_ios, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text('Task Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Divider(height: 0, thickness: 0.5),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          task.description ??
                              'Deliver a parcel from Lekki to Ikeja',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Needed in 2 hours',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('₦${task.budget ?? '5,000'}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _showBidBottomSheet(context),
                              child: const Text(
                                'Offer your Bid',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Outfit'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _taskActionButton(
                                onTap: () => _rejectTask(context),
                                color: Color(0XFFDD524D),
                                text: 'Reject task'),
                            SizedBox(width: 10.w),
                            _taskActionButton(
                                onTap: () => _acceptTask(context),
                                color: Color(0XFF4A85E4),
                                text: 'Accept task'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text('Location:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text('Pickup: Lekki Phase 1',
                            style: TextStyle(fontSize: 14)),
                        const Text('Drop-off: Ikeja',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 16),
                        const Text('Description',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text(
                          'I need someone to pick up a package from Lekki Phase 1 and deliver it to Ikeja GRA. The package is small (fits in a backpack) and contains important documents. Handle with care.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        const Text('Special request',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text(
                          'I need someone to pick up a package from Lekki Phase 1 and deliver it to Ikeja GRA. The package is small (fits in a backpack) and contains important documents. Handle with care.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  AssetImage('assets/images/circle.png'),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.clientName ?? '',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text(
                                  task.clientPhoneNumber ??
                                      '⭐ 4.8 (72 Reviews) | 85 errands requested, t',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: FancyContainer(
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
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
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      );
    },
  );
}
