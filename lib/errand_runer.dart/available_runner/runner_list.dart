import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/profile/data/model/runnerdetails_model.dart';
import 'package:pikquick/features/profile/domain/entities/runner_details_model.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:pikquick/app_variable.dart' as av;

class ErrandRunnerScreen extends StatefulWidget {
  const ErrandRunnerScreen({super.key});

  @override
  State<ErrandRunnerScreen> createState() => _ErrandRunnerScreenState();
}

class _ErrandRunnerScreenState extends State<ErrandRunnerScreen> {
  String selectedTransport = "All";
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchRunners();

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        setState(() => isSearching = true);
        context.read<ProfileBloc>().add(
              SearchRunnerEvent(query: query, page: "1", limit: "20"),
            );
      } else {
        setState(() => isSearching = false);
        _fetchRunners();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchRunners() {
    context.read<ProfileBloc>().add(
          RunnerDetailsEvent(
            latitude: 6.5244,
            longitude: 3.3792,
            radius: 10,
            transportMode: "",
            page: 1,
            limit: 20,
            runnerDetails: const RunnersAllDetailsModel(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is RunnerDetailsErrorState ||
                  state is SearchRunnerErrorState) {
                final errorMessage = state is RunnerDetailsErrorState
                    ? state.errorMessage
                    : (state as SearchRunnerErrorState).errorMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            },
            builder: (context, state) {
              List<RunnersAllDetailsEntity> runners = [];

              if (state is RunnerDetailsSuccessState) {
                runners = state.runners;
              } else if (state is SearchRunnerSuccessState) {
                runners =
                    state.runners.hasMore as List<RunnersAllDetailsEntity>;
              }

              final filteredRunners = selectedTransport == "All"
                  ? runners
                  : runners.where((runner) {
                      final mode = runner.transportMode?.toLowerCase() ?? "";
                      return mode == selectedTransport.toLowerCase();
                    }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back arrow
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            size: 22, color: Colors.black),
                        onPressed: () =>
                            context.go(MyAppRouteConstant.dashboard),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title
                  const Text(
                    "Available Runners for you!",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search task type",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Outfit',
                            ),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Optional: Blue on focus
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Transport filter row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        transportFilter("All", icon: Icons.person_outline),
                        const SizedBox(width: 8),
                        transportFilter("Bike", icon: Icons.motorcycle),
                        const SizedBox(width: 8),
                        transportFilter("Foot", icon: Icons.directions_walk),
                        const SizedBox(width: 8),
                        transportFilter("Bicycle", icon: Icons.pedal_bike),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "${filteredRunners.length} runners available",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Runner cards
                  Expanded(
                    child: state is RunnerDetailsLoadingState ||
                            state is SearchRunnerLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : filteredRunners.isEmpty
                            ? const Center(
                                child: Text("No runners available"),
                              )
                            : ListView.builder(
                                itemCount: filteredRunners.length,
                                itemBuilder: (context, index) {
                                  final runner = filteredRunners[index];
                                  IconData modeIcon;
                                  switch ((runner.transportMode ?? '')
                                      .toLowerCase()) {
                                    case 'bike':
                                      modeIcon = Icons.motorcycle;
                                      break;
                                    case 'walk':
                                      modeIcon = Icons.directions_walk;
                                      break;
                                    case 'car':
                                      modeIcon = Icons.directions_car;
                                      break;
                                    case 'bicycle':
                                      modeIcon = Icons.pedal_bike;
                                      break;
                                    default:
                                      modeIcon = Icons.directions_walk;
                                  }

                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Online and distance info
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Online",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                    fontFamily: 'Outfit',
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                "10 min away",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Outfit',
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // Runner info row
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: (runner
                                                            .profilePictureUrl !=
                                                        null)
                                                    ? NetworkImage(runner
                                                        .profilePictureUrl!)
                                                    : const AssetImage(
                                                            "assets/images/circle.png")
                                                        as ImageProvider,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          runner.userName ??
                                                              "N/A",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Outfit',
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Icon(
                                                          Icons.verified,
                                                          color: Colors.green,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      "Experienced errand runner with a focus on reliability and speed.",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Color(0XFF434953),
                                                          fontFamily: 'Outfit',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.orange,
                                                            size: 16),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          runner.averageRating !=
                                                                  null
                                                              ? runner
                                                                  .averageRating!
                                                                  .toStringAsFixed(
                                                                      1)
                                                              : 'N/A',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0XFF98A2B3),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          "${runner.totalTasksCompleted ?? "0"} errands completed",
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0XFF98A2B3),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          modeIcon,
                                                          size: 16,
                                                          color:
                                                              Color(0XFF98A2B3),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          "By ${runner.transportMode ?? "Foot"}",
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0XFF98A2B3),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),

                                          // View Profile button
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                final userId =
                                                    runner.userId ?? '';
                                                context.goNamed(
                                                  MyAppRouteConstant
                                                      .runnerProfile,
                                                  extra: {'userId': userId},
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: Colors.blue),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                              ),
                                              child: const Text(
                                                "View Profile",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontFamily: 'Outfit',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget transportFilter(String label, {IconData? icon}) {
    final isSelected = selectedTransport == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransport = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon,
                  size: 18, color: isSelected ? Colors.white : Colors.black),
            if (icon != null) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.black : Colors.black,
                fontFamily: 'Outfit',
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
