import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/dash_boardered_container.dart';
import 'package:pikquick/features/task/data/model/active_task_model.dart';
import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';

class RunnerTaskHistory extends StatefulWidget {
  const RunnerTaskHistory({super.key});

  @override
  State<RunnerTaskHistory> createState() => _RunnerTaskHistoryState();
}

class _RunnerTaskHistoryState extends State<RunnerTaskHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ActiveTaskPendingEntity> _allTasks = [];
  List<ActiveTaskPendingEntity> _filteredTasks = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);

    context.read<TaskBloc>().add(
          ActivetaskEvent(getTaskRunner: ActiveTaskPendingModel()),
        );
  }

  void _handleTabChange() => _filterTasks();

  void _filterTasks() {
    final status = _getTabStatus();
    setState(() {
      // filter by status
      List<ActiveTaskPendingEntity> tasks = (status == "all")
          ? _allTasks
          : _allTasks
              .where((task) => task.status?.toLowerCase() == status)
              .toList();

      // filter by search text
      if (_searchQuery.isNotEmpty) {
        tasks = tasks
            .where((task) =>
                (task.taskDescription ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                (task.clientName ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();
      }

      _filteredTasks = tasks;
    });
  }

  String _getTabStatus() {
    switch (_tabController.index) {
      case 1:
        return "active";
      case 2:
        return "completed";
      case 3:
        return "cancel";
      default:
        return "all";
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Task Card
  Widget _buildTaskCard(ActiveTaskPendingEntity runner) {
    Color themeColor = ((runner.status?.toLowerCase() == "completed") ||
                runner.status?.toLowerCase() == "active")
            ? Colors.green
            // .withOpacity(0.15)
            : (runner.status?.toLowerCase() == "in progress")
                ? Colors.orange
                // .withOpacity(0.15)
                : Colors.red
        // .withOpacity(0.15);
        ;
    //

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA), // Changed to FAFAFA color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final taskId = runner.taskId ?? '';
            context.pushNamed(
              MyAppRouteConstant.taskHOverview,
              extra: {'taskId': taskId},
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
              Align(
                alignment: Alignment.topLeft,
                child: DashBorderedContainer(
                  backgroundColor: themeColor.withAlpha(20),
                  borderColor: themeColor,
                  cornerRadius: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      // color: themeColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      runner.status ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        // (runner.status?.toLowerCase() == "completed")
                        //     ? Colors.green[800]
                        //     : (runner.status?.toLowerCase() == "in progress")
                        //         ? Colors.orange[800]
                        //         : Colors.red[700],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                runner.createdAt?.toString() ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),

              Text(
                runner.taskDescription ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 0,
              ),
              Text(
                '₦${runner.taskBudget ?? ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),

              Text(
                runner.clientName ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Outfit',
                  color: Colors.black87,
                ),
              ),

              const SizedBox(width: 6),
              Row(
                children: [
                  Text('Pickup :'),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    runner.pickupAddress ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 6),
              Row(
                children: [
                  Text('Drop-off :'),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    runner.dropOffAddress ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              Text(
                "Task ID:\n${runner.taskId}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Outfit',
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    final taskId = runner.taskId ?? '';
                    context.pushNamed(
                      MyAppRouteConstant.taskHOverview,
                      extra: {'taskId': taskId},
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightBlue,
                    side: BorderSide(
                        color: Colors.lightBlue.shade200, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Search UI styled like Available Task
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE4E7EC),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterTasks();
              },
              style: const TextStyle(fontSize: 15, fontFamily: 'Outfit'),
              decoration: const InputDecoration(
                hintText: "Search by description or client...",
                hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is ActivetaskSuccessState) {
            _allTasks = state.runnertask;
            _filterTasks();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back + Centered Title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                        onPressed: () {
                          context.goNamed(MyAppRouteConstant.dashBoardScreen);
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Task History",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search bar
                  _buildSearchBar(),

                  const SizedBox(height: 20),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color:
                            Colors.white, // White background for selected tab
                        borderRadius: BorderRadius.circular(12),
                      ),
                      indicatorSize: TabBarIndicatorSize
                          .tab, // Makes indicator cover entire tab
                      labelColor:
                          Colors.lightBlue, // Color for selected tab text
                      unselectedLabelColor: Colors.black54,
                      tabs: const [
                        Tab(text: "All"),
                        Tab(text: "active"),
                        Tab(text: "Completed"),
                        Tab(text: "Cancel"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Task list
                  Expanded(
                    child: state is ActivetaskLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredTasks.isEmpty
                            ? const Center(child: Text("No tasks found"))
                            : ListView.builder(
                                itemCount: _filteredTasks.length,
                                itemBuilder: (context, index) {
                                  return _buildTaskCard(_filteredTasks[index]);
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
