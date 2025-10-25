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
      backgroundColor: Colors.white, // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(MyAppRouteConstant
                    .dashBoardScreen); // or any default/fallback route
              }
            }),
        centerTitle: true,
        title: const Text(
          "Available Tasks",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 10),
              // Filter chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildFilterChip("All"),
                    _buildFilterChip("Helping hand"),
                    _buildFilterChip("Pickup Delivery"),
                    _buildFilterChip("Shopping"),
                    _buildFilterChip("Queue Standing"),
                    _buildFilterChip("Errand Running"),
                    _buildFilterChip("House Cleaning"),
                    _buildFilterChip("Document Dispatch"),
                    _buildFilterChip("Gift & Parcel Delivery"),
                    _buildFilterChip("Transport Errands"),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
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
              if (selectedFilter == 'Pickup Delivery') return type == 'pickup';
              return type == selectedFilter.toLowerCase();
            }).toList();

            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No matching tasks found.',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.taskType ?? 'Task',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "📅 Created: ${task.createdAt ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(height: 20, thickness: 0.5),
                        Text(
                          task.description ?? 'No Description',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "₦${task.budget ?? '0'}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: const Text(
                                "💰 Offer your Bid",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          task.clientName ?? 'Task',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "📍 Location Address",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        // ignore: avoid_print

                        Text(
                          userAddress?.pickupAddressLine1 ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        Text(
                          userAddress?.dropoffAddressLine1 ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                        // const Text("Drop-off: Yaba"),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              context.go(
                                MyAppRouteConstant.taskdetailsPage,
                                extra: {
                                  "taskId": task.id,
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: Colors.blue,
                                    width: 1), // Changed to blue border
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 120,
                                vertical: 22,
                              ),
                            ),
                            child: const Text(
                              "View Details",
                              style: TextStyle(color: Colors.blue),
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
    );
  }

  /// 🔹 Extracted properly as a method
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _triggerSearch(),
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
        backgroundColor: const Color(0xFFFAFAFA),
        labelStyle: TextStyle(
          color: isSelected ? Colors.lightBlue : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Add shadow for selected chip
        side: BorderSide.none,
        elevation: isSelected ? 4 : 0,
        pressElevation: 0,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}
