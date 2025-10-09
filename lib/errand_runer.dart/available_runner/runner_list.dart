import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:pikquick/app_variable.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  Row(
                    children: [
                      av.buildBackArrow(context,
                          replaceWidget: IconButton(
                              onPressed: () {
                                context.go(MyAppRouteConstant.dashboard);
                              },
                              icon: Icon(Icons.home))),
                      // IconButton(
                      //   icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Check out the runners for you!',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 370,
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          transportFilter("All"),
                          transportFilter("Bike", icon: Icons.directions_bike),
                          transportFilter("Walk", icon: Icons.directions_walk),
                          transportFilter("Bicycle", icon: Icons.pedal_bike),
                          transportFilter("Car", icon: Icons.directions_car),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: state is RunnerDetailsLoadingState ||
                            state is SearchRunnerLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : filteredRunners.isEmpty
                            ? const Center(child: Text("No runners available"))
                            : ListView.builder(
                                itemCount: filteredRunners.length,
                                itemBuilder: (context, index) {
                                  final runner = filteredRunners[index];

                                  IconData modeIcon;
                                  switch ((runner.transportMode ?? '')
                                      .toLowerCase()) {
                                    case 'bike':
                                      modeIcon = Icons.directions_bike;
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
                                    margin: const EdgeInsets.only(bottom: 16),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Online",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Outfit',
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              "10 minutes away",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Outfit',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage: (runner
                                                          .profilePictureUrl !=
                                                      null)
                                                  ? NetworkImage(
                                                      runner.profilePictureUrl!)
                                                  : AssetImage(
                                                      "assets/images/circle.png"),
                                            ),
                                            const SizedBox(width: 16),
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
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Outfit',
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Icon(
                                                        Icons.verified,
                                                        color: Colors.green,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  const Text(
                                                    "Experienced & Reliable",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star,
                                                          color: Colors.orange,
                                                          size: 18),
                                                      const SizedBox(width: 4),
                                                      const Text(
                                                        "reviews (72)",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                      ),
                                                      Text(
                                                        " | ${runner.distance ?? "0"} km away",
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          " | ${runner.totalTasksCompleted ?? "0"} task completed",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 10),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Icon(modeIcon, size: 20),
                                                      const SizedBox(width: 5),
                                                      Text(runner
                                                              .transportMode ??
                                                          "Walk"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: FancyContainer(
                                            onTap: () {
                                              final userId =
                                                  runner.userId ?? '';
                                              context.goNamed(
                                                MyAppRouteConstant
                                                    .runnerProfile,
                                                extra: {'userId': userId},
                                              );
                                            },
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(),
                                            height: 50,
                                            width: 342,
                                            child: const Center(
                                              child: Text(
                                                'View Profile',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Outfit',
                                                  color: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 20),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
