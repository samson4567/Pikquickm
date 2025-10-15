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
              Navigator.pop(context);
              _showBidSubmittedModal(context);
            } else if (state is BidOfferErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '₦400',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) {
                      proposedAmount = int.tryParse(value) ?? proposedAmount;
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Proposed amount: ₦$proposedAmount',
                      style: const TextStyle(fontSize: 12)),
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
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit Bid',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTaskAcceptedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset('assets/images/con2.png', height: 60, width: 100),
              const SizedBox(height: 16),
              const Text('Task Accepted',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'You have accepted this task. Wait for the client\'s confirmation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFDD524D),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              )
            ]),
          ),
        );
      },
    );
  }

  void _showTaskRejectedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset('assets/images/con2.png', height: 60, width: 100),
              const SizedBox(height: 16),
              const Text('Task Rejected',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'You have rejected this task. The client will be notified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              )
            ]),
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
            if (state is AcceptTaskbyrunnerSuccessState)
              _showTaskAcceptedDialog(context);
            if (state is RejectTaskbyrunnerSuccessState)
              _showTaskRejectedDialog(context);
            if (state is GetNewTaskDetailsSuccessState)
              task = state.taskOverViewDetails;
          },
          builder: (context, state) {
            if (state is GetNewTaskDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button & Title (vertical layout)
                  GestureDetector(
                    onTap: () => context.go(MyAppRouteConstant.availabeTask),
                    child: const Icon(Icons.arrow_back_ios, size: 26),
                  ),
                  const SizedBox(height: 16),
                  const Text('Task Details',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit')),
                  const SizedBox(height: 24),

                  // Task title & time
                  Text(
                      task.description ??
                          'Deliver a parcel from Lekki to Ikeja',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('Needed in 2 hours',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const Divider(height: 32),

                  // Price and Offer Bid
                  Row(
                    children: [
                      Text('₦${task.budget ?? '5,000'}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showBidBottomSheet(context),
                        child: const Text('Offer your Bid',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _rejectTask(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD15B5B),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Reject task',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _acceptTask(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A85E4),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Accept task',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Location
                  const Text('Location:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(task.pickupAddressLine1 ?? '',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(task.dropoffAddressLine1 ?? '',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),

                  const SizedBox(height: 24),

                  // Description
                  Text(task.description ?? '',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                      task.additionalNotes ??
                          'I need someone to pick up a package from Lekki Phase 1 and deliver it to Ikeja GRA. The package is small (fits in a backpack) and contains important documents. Handle with care.',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),

                  const SizedBox(height: 24),

                  // Special request
                  const Text('Special request',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                      task.specialInstructions ??
                          'Handle with care. Contains important documents.',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),

                  const SizedBox(height: 30),

                  // Client info
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
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                SizedBox(width: 4),
                                Text('4.8 (72 Reviews) | 85 errands requested',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chat_bubble_outline, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            );
          },
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
            const Text('Bid Submitted',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
