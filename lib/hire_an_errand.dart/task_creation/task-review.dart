// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';

class TaskReview extends StatelessWidget {
  const TaskReview({super.key, required this.data});

  final Map<String, dynamic> data;

  // TaskModel buildTaskModelFromData(Map<String, dynamic> data) {
  //   return TaskModel(
  //     clientId: ['clientId'] ?? '',
  //     taskType: ['taskType'] ?? '',
  //     pickupAddress: AddressModel.fromJson(['pickupLocation'] ?? ''),
  //     dropoffAddress: ['drop-off'] ?? '',
  //     additionalNotes: ['additionalNote'] ?? '',
  //     budget: int.tryParse(['Setbudget']?.toString() ?? ''),
  //     paymentMethod: 'wallet',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // print("jskdksadkadsjadhasd>>${av.taskModelbeingCreated?.pickupAddress}");
    print("jskdksadkadsjadhasd>>${av.taskModelbeingCreated?.pickupAddress
        // AddressModel.fromEntity(av.taskModelbeingCreated?.pickupAddress)?.fullAddress
        }");

    // AddressModel.fromEntity(av.taskModelbeingCreated?.dropoffAddress)?.fullAddress
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskCreationLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (state is TaskCreationSuccessState) {
          av.taskModelbeingCreated =
              TaskModel.fromTaskEntity(state.resultantTaskModel);
          context.go(MyAppRouteConstant.runner);
          // context.pushNamed(MyAppRouteConstant.dashboard);
        } else if (state is TaskCreationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        // av.taskModelbeingCreated?.categoryId =
        //     "455a8eed-729e-11f0-8703-00163cbf7aa3";
        // av.taskModelbeingCreated?.taskType = av.taskModelbeingCreated?.name;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Review Your Task",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 20),

                  buildLabelValue("Task Title",
                      '${av.taskModelbeingCreated?.taskType ?? ''}'),
                  const Divider(),
                  buildLabelValue("Task Description",
                      '${av.taskModelbeingCreated?.additionalNotes ?? ''}'),
                  const Divider(),
                  buildLabelValue("Pick-up Location",
                      '${AddressModel.fromEntity(av.taskModelbeingCreated?.pickupAddress)?.fullAddress ?? ''}'),
                  const Divider(),
                  buildLabelValue("Drop-off Location",
                      '${AddressModel.fromEntity(av.taskModelbeingCreated?.dropoffAddress)?.fullAddress ?? ''}'),
                  const Divider(),
                  buildLabelValue(
                      "Budget", '${av.taskModelbeingCreated?.budget ?? ''}'),
                  const Divider(),
                  buildLabelValue("Payment Method", 'Wallet'),

                  const SizedBox(height: 20),

                  // Confirm Button
                  Center(
                    child: FancyContainer(
                      onTap: () {
                        final taskModel = av.taskModelbeingCreated!;
                        //  buildTaskModelFromData(data);
                        context
                            .read<TaskBloc>()
                            .add(TaskCreationEvent(taskModel: taskModel));
                      },
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF4378CD),
                      height: 50,
                      width: 342,
                      child: const Center(
                        child: Text(
                          'View All Runners',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Outfit',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Edit Button
                  Center(
                    child: FancyContainer(
                      onTap: () =>
                          context.pushNamed(MyAppRouteConstant.hirerunnerPage),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue),
                      height: 50,
                      width: 342,
                      child: const Center(
                        child: Text(
                          'Edit Task Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Outfit',
                            color: Colors.blue,
                          ),
                        ),
                      ),
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

  Widget buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 15,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }
}
