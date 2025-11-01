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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    context.read<TaskBloc>().add(ActivetaskEvent());
  }

  void _handleTabChange() => _filterTasks();

  void _filterTasks() {
    final status = _getTabStatus();
    setState(() {
      // filter by status
      List<ActiveTaskPendingEntity> tasks = (status == "in progress")
          ? _allTasks
              .where((task) =>
                  task.status?.toLowerCase() == "in progress" ||
                  task.status?.toLowerCase() == "active")
              .toList()
          : _allTasks
              .where((task) => task.status?.toLowerCase() == "completed")
              .toList();

      // filter by search
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
    return _tabController.index == 0 ? "in progress" : "completed";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Task Card — matches uploaded design
  Widget _buildTaskCard(ActiveTaskPendingEntity runner) {
    bool isCompleted = (runner.status?.toLowerCase() == "completed" ||
        runner.status == "done");

    Color tagColor =
        isCompleted ? const Color(0xFF34C759) : const Color(0xFFFF9500);

    String tagText = isCompleted ? "Completed" : "In Progress";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Align(
            alignment: Alignment.topLeft,
            child: DashBorderedContainer(
              backgroundColor: tagColor.withOpacity(0.1),
              borderColor: tagColor,
              cornerRadius: 20,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  tagText,
                  style: TextStyle(
                    color: tagColor,
                    fontSize: 12,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Task title
          Text(
            runner.taskDescription ?? 'Untitled Task',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Time info
          if (!isCompleted)
            Row(
              children: const [
                Text(
                  "Time Left  ",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "1h 30m remaining",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          else
            Row(
              children: const [
                Text(
                  "Time  ",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "3 hours",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  "Date  ",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Mon Feb 2017",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),

          // Price
          Text(
            "₦${runner.taskBudget ?? '0'}",
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Location info
          const Text(
            "Location Address",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Text(
                "Pickup   ",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                child: Text(
                  runner.pickupAddress ?? 'N/A',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                "Drop-off ",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                child: Text(
                  runner.dropOffAddress ?? 'N/A',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Task ID
          Text(
            "Task ID",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            "#${runner.taskId ?? ''}",
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // View Details button
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
                foregroundColor: const Color(0xFF3D73EB),
                side: const BorderSide(color: Color(0xFF3D73EB), width: 1.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "View Details",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Search bar (modern minimalist style)
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterTasks();
              },
              style: const TextStyle(
                  fontFamily: 'Outfit', fontSize: 15, color: Colors.black87),
              decoration: const InputDecoration(
                hintText: "Search task type",
                hintStyle: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  color: Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Tabs — “In Progress Tasks” & “Completed Tasks”
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: "In Progress Tasks"),
          Tab(text: "Completed Tasks"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () =>
                            context.goNamed(MyAppRouteConstant.dashBoardScreen),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Task History",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  _buildTabBar(),
                  const SizedBox(height: 20),

                  Expanded(
                    child: state is ActivetaskLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredTasks.isEmpty
                            ? const Center(
                                child: Text(
                                  "No tasks found",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _filteredTasks.length,
                                itemBuilder: (context, index) =>
                                    _buildTaskCard(_filteredTasks[index]),
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
