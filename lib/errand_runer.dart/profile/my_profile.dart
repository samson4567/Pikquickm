import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as app_var;
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/router/router_config.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double rating = 4.5;

  void updateRating() {
    setState(() {
      rating = rating < 5.0 ? rating + 0.1 : 5.0;
    });
  }

  @override
  void initState() {
    super.initState();

    final userId = app_var.userModelG?.id;
    if (userId != null) {
      context.read<ProfileBloc>().add(GetrunnerProfileEvent(userID: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Runners Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: (userModelG?.imageUrl != null)
                              ? NetworkImage(userModelG!.imageUrl!)
                              : AssetImage('assets/images/circle.png'),
                        ),
                        Positioned(
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.add_a_photo)),
                          bottom: -10,
                          left: 50,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.green),
                          ),
                          height: 30,
                          width: 89,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.verified,
                                  color: Colors.green, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'verified',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Outfit',
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              app_var.userModelG?.fullName ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        runnerInfo(),
                        const SizedBox(height: 12),
                        FancyContainer(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),
                          height: 50,
                          width: 270,
                          child: TextButton(
                            onPressed: () {
                              context.pushNamed(MyAppRouteConstant.profilempty);
                            },
                            child: const Text(
                              'Edit Profile',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  trustScoreCard(),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 342,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[600],
                        tabs: const [
                          Tab(text: 'About'),
                          Tab(text: 'Verification Details'),
                          Tab(text: 'Review'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Fixed height for TabBarView to prevent overflow
                  SizedBox(
                    height: 600, // Adjust as needed
                    child: TabBarView(
                      children: [
                        profileDetails(),
                        verification(),
                        review(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // rest of your methods...
  // include runnerInfo(), trustScoreCard(), profileDetails(), etc.

  Widget runnerInfo() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is GetrunnerPerformanceLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetrunnerPerformanceeSuccessState) {
          final performance = state.getProfilePerformance;

          final rating = performance.averageRating;
          final reviews = performance.recentReviews;
          final errands = performance.totalTasksCompleted;
          final cancellationRate = performance.cancellationRate;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 18),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 8),
              Text(
                "| $reviews reviews | $errands errands completed",
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  const Icon(Icons.directions_car, size: 10),
                  const SizedBox(width: 3),
                  Text(
                    'transport',
                    style: const TextStyle(fontSize: 7),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Text(
                '| ${cancellationRate.toStringAsFixed(0)}% cancellation',
                style: const TextStyle(fontSize: 7),
              ),
            ],
          );
        } else if (state is GetrunnerPerformanceeErrorState) {
          return Text("Error: ${state.errorMessage}");
        } else {
          // Show default values if nothing loaded yet
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.star, color: Colors.orange, size: 18),
              SizedBox(width: 4),
              Text(
                "0.0",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8),
              Text(
                "| 0 reviews | 0 errands completed",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  Icon(Icons.directions_car, size: 12),
                  SizedBox(width: 3),
                  Text(
                    "No transport",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  '| 0% cancellation rate',
                  style:
                      TextStyle(fontSize: 10, letterSpacing: 0.3, height: 1.4),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget trustScoreCard() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is GetrunnerProfileLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetrunnerProfileSuccessState) {
          final profile = state.getProfile;

          if (profile.trustScore.isEmpty) {
            return const SizedBox.shrink();
          }

          final user = profile;
          final trustScore = double.tryParse(user.trustScore) ?? 0.0;
          final trustScorePercent = (trustScore / 100).clamp(0.0, 1.0);
          return FancyContainer(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(12),
            height: 100,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Text Content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trust Score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$trustScore (based on client\nreviews & reliability)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Outfit',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Circular Progress Indicator
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.orange[700],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: trustScorePercent,
                            strokeWidth: 6,
                            backgroundColor: const Color(0xFF4A85E4),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                        Text(
                          '${trustScore.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget profileDetails() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is GetrunnerProfileLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetrunnerProfileSuccessState) {
          final profile = state.getProfile; // Assuming only one profile

          return Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader("Bio / About Me"),
                  _sectionContent(profile.bio),
                  const SizedBox(height: 16),
                  _sectionHeader("Task History"),
                  _sectionContent(
                      "Tasks Completed: ${profile.totalTasksCompleted}"),
                  _sectionContent("Repeat Clients: ${profile.id}"),
                  const SizedBox(height: 16),
                  _sectionHeader("Availability"),
                  _sectionContent(
                      profile.isAvailable == 1 ? "Available" : "Not Available"),
                  const SizedBox(height: 16),
                  _sectionHeader("Transport Mode"),
                  _sectionContent(profile.transportMode),
                  const SizedBox(height: 16),
                  _sectionHeader("Languages Spoken"),
                  _sectionContent(profile.languages.join(',')),
                  const SizedBox(height: 16),
                  _sectionHeader("Specialized Tasks"),
                  _sectionContent(profile.specializedTasks.join(', ')),
                  const SizedBox(height: 16),
                  _sectionHeader("Service Areas"),
                  _sectionContent(profile.city ?? ''),
                ],
              ),
            ),
          );
        }
        if (state is GetrunnerProfileErrorState) {
          return Center(child: Text(state.errorMessage));
        }
        return const Center(child: Text("No profile data found."));
      },
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _sectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Outfit',
      ),
    );
  }

  Widget verification() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Contact Details:"),
            _contactDetail("Phone number", "+2349075345678"),
            _contactDetail("Email Address", "morufu@gmail.com"),
            _sectionTitle("Verified Credentials:"),
            _verifiedItem("Government ID Verified"),
            _verifiedItem("Vehicle Registration Verified"),
            _verifiedItem("International Passport Verified"),
            _verifiedItem("Background Check Verified"),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Outfit',
      ),
    );
  }

  Widget _contactDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontFamily: 'Outfit'),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontFamily: 'Outfit'),
          ),
        ],
      ),
    );
  }

  Widget _verifiedItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'Outfit')),
          const Image(
            image: AssetImage('assets/images/ci.png'),
            width: 15,
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget review() {
    final reviews = [
      {
        "name": "Serah A",
        "text":
            "James was quick and reliable - delivered my parcel within an hour.",
        "rating": 5,
      },
      {
        "name": "John D",
        "text": "Very professional and punctual. Highly recommended!",
        "rating": 4,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _reviewItem(
              name: review["name"] as String,
              comment: review["text"] as String,
              rating: review["rating"] as int,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _reviewItem({
    required String name,
    required String comment,
    required int rating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          comment,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              color: index < rating ? Colors.red : Colors.grey.shade300,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
