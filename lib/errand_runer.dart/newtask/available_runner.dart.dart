import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:pikquick/features/task/data/model/new_task_model.dart';

class AvailableTask extends StatefulWidget {
  const AvailableTask({super.key});

  @override
  State<AvailableTask> createState() => _AvailableTaskState();
}

class _AvailableTaskState extends State<AvailableTask>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String searchQuery = '';
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // ✅ Load once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TaskBloc>()
          .add(const GetNewTaskEvent(newtask: NewTaskModel()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch(String query) {
    if (query != searchQuery) {
      setState(() {
        searchQuery = query.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(MyAppRouteConstant.dashBoardScreen);
            }
          },
        ),
        centerTitle: true,
        title: const Text(
          "Available Task",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 10),
              _buildFilterTabs(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        buildWhen: (previous, current) =>
            current is GetNewTaskLoadingState ||
            current is GetNewTaskSuccessState ||
            current is GetNewTaskErrorState,
        builder: (context, state) {
          if (state is GetNewTaskLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetNewTaskErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (state is GetNewTaskSuccessState) {
            final tasks = _filterTasks(state.getNewTask);

            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No matching tasks found.',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                    fontFamily: 'Outfit',
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _controller..forward(),
                    curve: Interval((index / tasks.length), 1.0,
                        curve: Curves.easeIn),
                  ),
                  child: _buildTaskCard(context, task),
                );
              },
            );
          }

          return const Center(
            child: Text(
              "No tasks loaded.",
              style: TextStyle(fontFamily: 'Outfit'),
            ),
          );
        },
      ),
    );
  }

  /// 🧠 Filter tasks based on search and category
  List<dynamic> _filterTasks(List<dynamic> allTasks) {
    final query = searchQuery.toLowerCase();
    return allTasks.where((task) {
      final title = task.description?.toLowerCase() ?? '';
      final type = task.taskType?.toLowerCase() ?? '';

      if (query.isNotEmpty && !title.contains(query)) return false;
      if (selectedFilter == 'All') return true;
      if (selectedFilter == 'Pickup & Delivery') return type == 'pickup';
      return type == selectedFilter.toLowerCase();
    }).toList();
  }

  /// 🔍 Search Bar
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9D9D9), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _triggerSearch,
              style: const TextStyle(fontSize: 15, fontFamily: 'Outfit'),
              decoration: const InputDecoration(
                hintText: "Search task type",
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontFamily: 'Outfit',
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, color: Colors.black54, size: 20),
          ),
        ],
      ),
    );
  }

  /// 🧩 Filter Tabs (all inside one rounded container)
  Widget _buildFilterTabs() {
    final filters = [
      "All",
      "Custom Task",
      "Pickup & Delivery",
      "Shopping",
      "Queue Standing",
      "Errand Running",
      "House Cleaning",
      "Document Dispatch",
      "Gift & Parcel Delivery",
      "Transport Errands",
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((label) {
            final isSelected = label == selectedFilter;
            return GestureDetector(
              onTap: () {
                if (!isSelected) {
                  setState(() {
                    selectedFilter = label;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit',
                    color: isSelected ? Colors.black : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 🧾 Task Card Widget
  Widget _buildTaskCard(BuildContext context, dynamic task) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.description ?? 'Deliver a parcel from Lekki to Ikeja',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Needed in 2 hours",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE0E0E0), thickness: 1),
          const SizedBox(height: 8),

          // 💰 Price Row
          Row(
            children: [
              Text(
                "₦${task.budget ?? '0'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Offer your Bid",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text(
            "Location Address",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 6),
          _buildLocationRow(
              "Pickup: ", userAddress?.pickupAddressLine1 ?? 'Lekki Phase 1'),
          const SizedBox(height: 4),
          _buildLocationRow(
              "Drop-off: ", userAddress?.dropoffAddressLine1 ?? 'Ikeja'),

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.go(
                  MyAppRouteConstant.taskdetailsPage,
                  extra: {"taskId": task.id},
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blueAccent, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: const Text(
                "View Details",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Outfit',
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
