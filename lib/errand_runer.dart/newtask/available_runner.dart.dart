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
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    context.read<TaskBloc>().add(
          const GetNewTaskEvent(newtask: NewTaskModel()),
        );
  }

  void _triggerSearch() {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Custom Header (No AppBar)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(MyAppRouteConstant.dashBoardScreen);
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Available Task",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        _buildFilterChip("All"),
                        _buildFilterChip("Custom Task"),
                        _buildFilterChip("Pickup & Delivery"),
                        _buildFilterChip("Shopping"),
                        _buildFilterChip("Errand Running"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Task List
            Expanded(
              child: BlocConsumer<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is GetNewTaskErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GetNewTaskLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is GetNewTaskSuccessState) {
                    final tasks = state.getNewTask.where((task) {
                      final query = searchQuery.toLowerCase();
                      final title = task.description?.toLowerCase() ?? '';
                      final type = task.taskType?.toLowerCase() ?? '';

                      if (!title.contains(query)) return false;
                      if (selectedFilter == 'All') return true;
                      if (selectedFilter == 'Pickup & Delivery') {
                        return type.contains('pickup');
                      }
                      return type == selectedFilter.toLowerCase();
                    }).toList();

                    if (tasks.isEmpty) {
                      return const Center(
                        child: Text(
                          'No matching tasks found.',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                              fontFamily: 'Outfit'),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _controller..forward(),
                            curve: Interval((index / tasks.length), 1.0,
                                curve: Curves.easeIn),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 18),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 18),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Task Title
                                Text(
                                  task.description ??
                                      'Deliver a parcel from Lekki to Ikeja',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Outfit',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Needed in 2 hours",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Divider
                                Divider(
                                  color: Colors.grey[300],
                                  height: 10,
                                  thickness: 1,
                                ),
                                const SizedBox(height: 8),

                                // Amount & Offer bid
                                Row(
                                  children: [
                                    Text(
                                      "₦${task.budget ?? '5,000'}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: implement bid modal
                                      },
                                      child: const Text(
                                        "Offer your Bid",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blue,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Location
                                const Text(
                                  "Location Address",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      "Pickup  ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    Text(
                                      task.pickupAddressLine1 ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Drop-off  ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    Text(
                                      task.dropoffAddressLine1 ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // View Details button
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.blue, width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 16),
                                      ),
                                      onPressed: () {
                                        context.go(
                                          MyAppRouteConstant.taskdetailsPage,
                                          extra: {"taskId": task.id},
                                        );
                                      },
                                      child: const Text(
                                        "View Details",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text("No tasks loaded."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _triggerSearch(),
              style: const TextStyle(fontSize: 15, fontFamily: 'Outfit'),
              decoration: const InputDecoration(
                hintText: "Search task type",
                hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.tune, color: Colors.black54, size: 22),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = label == selectedFilter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
        selectedColor: Colors.white,
        backgroundColor: const Color(0xFFF8F8F8),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.black54,
          fontFamily: 'Outfit',
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: isSelected ? 1.5 : 0,
          ),
        ),
      ),
    );
  }
}
