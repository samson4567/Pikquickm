import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/dash_boardered_container.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/features/task/data/model/get_task_currentusermodel.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_entities.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';

class ClientTaskHistory extends StatefulWidget {
  const ClientTaskHistory({super.key});

  @override
  State<ClientTaskHistory> createState() => _ClientTaskHistoryState();
}

class _ClientTaskHistoryState extends State<ClientTaskHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<GetTaskForCurrenusersEntity> allTasks = [];
  final List<String> tabLabels = [
    "All",
    "Bidding",
    "Pending",
    "task_started",
    "task_Completed",
    "bid_rejected",
    'bid_accepted'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLabels.length, vsync: this);

    context.read<TaskBloc>().add(GetTaskForCurrenusersEvent(
        // gettaskModel: const GetTaskForClientModel(),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<GetTaskForCurrenusersEntity> _filterTasks(String status) {
    if (status == "All") return allTasks;

    // Map tab labels to actual status values in the data
    final statusMap = {
      "Bidding": "bidding",
      "Pending": "pending",
      "Started": "inprogress",
      "Completed": "completed",
      "Cancelled": "cancel"
    };

    final actualStatus = statusMap[status] ?? status.toLowerCase();
    return allTasks
        .where((task) => task.status?.toLowerCase() == actualStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
        if (state is GetTaskForCurrenusersErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        if (state is GetTaskForCurrenusersSucessState) {
          setState(() {
            allTasks = state.gettask;
          });
        }
      }, builder: (context, state) {
        if (state is GetTaskForCurrenusersLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return allTasks.isNotEmpty
            ? _buildTaskHistoryUI()
            : Center(child: Image.asset('assets/images/taskun.png'));
      }),
    );
  }

  Widget _buildTaskHistoryUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button row
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              const Text(
                "Task History",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search task type",
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.white, // Fill color white
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFAFAFA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFAFAFA)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tabs
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              unselectedLabelColor: Colors.black54,
              labelColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              tabs: tabLabels.map((label) => Tab(text: label)).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Task list per tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  tabLabels.map((label) => _buildTaskList(label)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(String status) {
    final filtered = _filterTasks(status);

    if (filtered.isEmpty) {
      return Center(child: Image.asset('assets/images/taskun.png'));
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          filtered.length,
          (index) {
            final task = filtered[index];

            void navigateToOverview() {
              if (task.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task not assigned")),
                );
                return;
              }
              print(task.id);

              context.push(
                MyAppRouteConstant.clientTaskOverviewProgress,
                extra: {'taskId': task.id},
              );
            }

            Color themeColor = (task.status?.toLowerCase() == "completed")
                ? Colors.green
                : (task.status?.toLowerCase() == "inprogress")
                    ? Colors.orange
                    : (task.status?.toLowerCase() == "pending")
                        ? Colors.blue
                        : (task.status?.toLowerCase() == "cancel")
                            ? Colors.red
                            : (task.status?.toLowerCase() == "bidding")
                                ? Colors.purple
                                : Colors.grey;

            return InkWell(
              onTap: navigateToOverview,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    Align(
                      alignment: Alignment.topLeft,
                      child: DashBorderedContainer(
                        backgroundColor: themeColor.withAlpha(20),
                        borderColor: themeColor,
                        child: FancyContainer2(
                          // child: Icon(
                          //   task.status?.toLowerCase() == "completed"
                          //       ? Icons.check_circle
                          //       : task.status?.toLowerCase() == "inprogress"
                          //           ? Icons.timelapse
                          //           : task.status?.toLowerCase() == "pending"
                          //               ? Icons.pending_actions
                          //               : task.status?.toLowerCase() == "cancel"
                          //                   ? Icons.cancel
                          //                   : task.status?.toLowerCase() ==
                          //                           "bidding"
                          //                       ? Icons.gavel
                          //                       : Icons.info,
                          //   size: 16,
                          //   color: Colors.white,
                          // ),
                          nulledAlign: true,

                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              task.status ?? "Unknown",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: themeColor
                                  //  Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Task title
                    Text(
                      task.taskType ?? "No Task Type",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),

                    // Description
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              task.description!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Outfit',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    Text(
                      '₦${task.budget ?? '0'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Outfit',
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Created date
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          'Created: ${task.createdAt?.toLocal().toString().split('.')[0] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Outfit',
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Runner info
                    Row(
                      children: [
                        RunnerImageWidget(task: task),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.runnerName ?? "Anonymous",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.update,
                                    size: 14, color: Colors.black45),
                                const SizedBox(width: 4),
                                Text(
                                  'Updated: ${task.updatedAt?.toLocal().toString().split('.')[0] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Outfit',
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // View Task Button
                    FancyContainer(
                      onTap: navigateToOverview,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue),
                      height: 45,
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          'View Task',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RunnerImageWidget extends StatefulWidget {
  final GetTaskForCurrenusersEntity task;

  const RunnerImageWidget({super.key, required this.task});

  @override
  State<RunnerImageWidget> createState() => _RunnerImageWidgetState();
}

class _RunnerImageWidgetState extends State<RunnerImageWidget> {
  String? imagePath;
  @override
  void initState() {
    super.initState();
    context
        .read<ProfileBloc>()
        .add(GetrunnerProfileEvent(userID: widget.task.runnerId!));
  }

  bool getrunnerProfileEventHasError = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is GetrunnerProfileErrorState) {
        getrunnerProfileEventHasError = true;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(state.errorMessage)),
        // );
        setState(() {});
      }
      if (state is GetrunnerProfileSuccessState) {
        if (widget.task.runnerId == state.runnerID) {
          getrunnerProfileEventHasError = false;
          print(
              "dnasldalskdandlnasjkasdkj-state.getProfile.profilePictureUrl>>${state.getProfile.profilePictureUrl}");
          imagePath = state.getProfile.profilePictureUrl;
          setState(() {});
        }
      }
    }, builder: (context, state) {
      if (imagePath == null) {
        if (getrunnerProfileEventHasError) {
          return CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage("assets/images/circle.png"),
            child: widget.task.runnerName == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          );
        }
        return CircularProgressIndicator.adaptive();
      }
      return CircleAvatar(
        radius: 22,
        backgroundImage: (imagePath != null)
            ? NetworkImage(imagePath!)
            : const AssetImage("assets/images/circle.png"),
        child: widget.task.runnerName == null
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      );
    });

    // ListView.builder(
    //     itemCount: filtered.length,
    //     padding: const EdgeInsets.only(top: 12),
    //     itemBuilder: (context, index) {
    //       final task = filtered[index];

    //       void navigateToOverview() {
    //         if (task.id == null) {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(content: Text("Task not assigned")),
    //           );
    //           return;
    //         }
    //         print(task.id);

    //         context.push(
    //           MyAppRouteConstant.clientTaskOverviewProgress,
    //           extra: {'taskId': task.id},
    //         );
    //       }

    //       return InkWell(
    //         onTap: navigateToOverview,
    //         borderRadius: BorderRadius.circular(16),
    //         child: Container(
    //           margin: const EdgeInsets.only(bottom: 16),
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             color: Color(0xFFFAFAFA),
    //             borderRadius: BorderRadius.circular(16),
    //           ),
    //           padding: const EdgeInsets.all(16),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               // Status badge
    //               Align(
    //                 alignment: Alignment.topRight,
    //                 child: Chip(
    //                   avatar: Icon(
    //                     task.status?.toLowerCase() == "completed"
    //                         ? Icons.check_circle
    //                         : task.status?.toLowerCase() == "inprogress"
    //                             ? Icons.timelapse
    //                             : task.status?.toLowerCase() == "pending"
    //                                 ? Icons.pending_actions
    //                                 : task.status?.toLowerCase() == "cancel"
    //                                     ? Icons.cancel
    //                                     : task.status?.toLowerCase() == "bidding"
    //                                         ? Icons.gavel
    //                                         : Icons.info,
    //                     size: 16,
    //                     color: Colors.white,
    //                   ),
    //                   label: Text(
    //                     task.status ?? "Unknown",
    //                     style: const TextStyle(
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.w600,
    //                         color: Colors.white),
    //                   ),
    //                   backgroundColor: (task.status?.toLowerCase() == "completed")
    //                       ? Colors.green
    //                       : (task.status?.toLowerCase() == "inprogress")
    //                           ? Colors.orange
    //                           : (task.status?.toLowerCase() == "pending")
    //                               ? Colors.blue
    //                               : (task.status?.toLowerCase() == "cancel")
    //                                   ? Colors.red
    //                                   : (task.status?.toLowerCase() == "bidding")
    //                                       ? Colors.purple
    //                                       : Colors.grey,
    //                 ),
    //               ),

    //               const SizedBox(height: 6),

    //               // Task title
    //               Text(
    //                 task.taskType ?? "No Task Type",
    //                 style: const TextStyle(
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.bold,
    //                   fontFamily: 'Outfit',
    //                 ),
    //               ),

    //               // Description
    //               if (task.description != null &&
    //                   task.description!.isNotEmpty) ...[
    //                 const SizedBox(height: 6),
    //                 Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     const SizedBox(width: 4),
    //                     Expanded(
    //                       child: Text(
    //                         task.description!,
    //                         style: const TextStyle(
    //                           fontSize: 20,
    //                           fontFamily: 'Outfit',
    //                           color: Colors.black,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //               Text(
    //                 '₦${task.budget ?? '0'}',
    //                 style: const TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.w600,
    //                   fontFamily: 'Outfit',
    //                   color: Colors.blue,
    //                 ),
    //               ),

    //               const SizedBox(height: 8),

    //               // Created date
    //               Row(
    //                 children: [
    //                   const Icon(Icons.access_time,
    //                       size: 16, color: Colors.black54),
    //                   const SizedBox(width: 4),
    //                   Text(
    //                     'Created: ${task.createdAt?.toLocal().toString().split('.')[0] ?? 'N/A'}',
    //                     style: const TextStyle(
    //                       fontSize: 12,
    //                       fontFamily: 'Outfit',
    //                       color: Colors.black54,
    //                     ),
    //                   ),
    //                 ],
    //               ),

    //               const SizedBox(height: 12),

    //               // Runner info
    //               Row(
    //                 children: [
    //                   RunnerImageWidget(task: task),
    //                   const SizedBox(width: 10),
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         task.runnerName ?? "Anonymous",
    //                         style: const TextStyle(
    //                           fontSize: 15,
    //                           fontWeight: FontWeight.w600,
    //                           fontFamily: 'Outfit',
    //                         ),
    //                       ),
    //                       Row(
    //                         children: [
    //                           const Icon(Icons.update,
    //                               size: 14, color: Colors.black45),
    //                           const SizedBox(width: 4),
    //                           Text(
    //                             'Updated: ${task.updatedAt?.toLocal().toString().split('.')[0] ?? 'N/A'}',
    //                             style: const TextStyle(
    //                               fontSize: 11,
    //                               fontFamily: 'Outfit',
    //                               color: Colors.black54,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),

    //               const SizedBox(height: 14),

    //               // View Task Button
    //               FancyContainer(
    //                 onTap: navigateToOverview,
    //                 borderRadius: BorderRadius.circular(10),
    //                 border: Border.all(color: Colors.blue),
    //                 height: 45,
    //                 width: double.infinity,
    //                 child: const Center(
    //                   child: Text(
    //                     'View Task',
    //                     style: TextStyle(
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.bold,
    //                       fontFamily: 'Outfit',
    //                       color: Colors.blue,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // FutureBuilder<Object>(
    //     future: () async {
    // context
    //     .read<ProfileBloc>()
    //     .add(GetrunnerProfileEvent(userID: widget.task.runnerId!));
    //       return "";
    //     }.call(),
    //     builder: (context, snapshot) {
    //       print("daknsaslndnasdajkn${snapshot.hasData}");
    //       return (!snapshot.hasData)
    //           ? CircularProgressIndicator.adaptive()
    //           :
    //     });
  }
}
