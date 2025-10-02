import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/errand_runer.dart/available_runner/verification_item_widget.dart';
import 'package:pikquick/features/profile/data/model/get_runner_profile_model.dart';
import 'package:pikquick/features/profile/data/model/invite_sent_model.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/router/router_config.dart';

class RunnerProfile extends StatefulWidget {
  final String userId;
  final String taskId; // ✅ Added to pass the required taskId

  const RunnerProfile({
    super.key,
    required this.userId,
    required this.taskId,
  });

  @override
  State<RunnerProfile> createState() => _RunnerProfileState();
}

class _RunnerProfileState extends State<RunnerProfile> {
  GetRunnerProfileModel? runnerData;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(RunnerDetailsInviteSentEvent(
          userId: widget.userId,
        ));
  }

  void _showInviteSentModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: 450,
          height: 220,
          child: Column(
            children: [
              Image.asset('assets/images/con2.png', height: 60, width: 100),
              const SizedBox(height: 16),
              const Text('Invite Sent',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit')),
              const SizedBox(height: 8),
              const Text(
                'An invite has being sent to this runner  .',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is RunnerDetailsInviteSentSuccessState) {
          setState(() {
            runnerData = state.runners as GetRunnerProfileModel;
          });
        }
        if (state is RunnerDetailsInviteSentErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        if (state is InviteSentSuccessState) {
          _showInviteSentModal();
        }
      },
      builder: (context, state) {
        if (state is RunnerDetailsInviteSentLoadingState ||
            runnerData == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          context.pushReplacement(MyAppRouteConstant.runner);
                        }),
                    const SizedBox(height: 20),
                    const Text(
                      'Runner Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Outfit'),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: runnerData?.profilePictureUrl != null
                          ? NetworkImage(runnerData!.profilePictureUrl!)
                          : AssetImage('assets/images/circle.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          runnerData?.userName ?? "Runner",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Outfit'),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.verified,
                            color: Colors.green, size: 20),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      runnerData?.bio ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Outfit'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        Text(
                          " ${runnerData?.averageRating?.toStringAsFixed(1) ?? '0.0'} ",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "| ${runnerData?.totalTasksCompleted ?? 0} errands completed",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.directions_car, size: 10),
                        const SizedBox(width: 5),
                        Text(runnerData?.transportMode ?? '',
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// ✅ Send Invite Button (Fixed)
                    GestureDetector(
                      onTap: () {
                        final inviteModel = InviteSentToRunnerModel(
                          runnerId: widget.userId,
                        );
                        print('${widget.taskId}************ ');
                        context.read<ProfileBloc>().add(
                              InviteSentEvent(
                                // taskId: "22dc7f6c-fc0b-4cc9-88b1-e8c893f41a7e",
                                taskId: av.taskModelbeingCreated?.id ?? "",
                                // 'e4afbf20-0a87-43a4-9f04-dad4ea7f76af',
                                sendInvite: inviteModel,
                              ),
                            );
                      },
                      child: FancyContainer(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                        height: 50,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'Send Invite',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
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
                          Tab(text: 'Verification'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FancyContainer(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trust Score',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Based on client reviews and task reliability',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    value: double.tryParse(
                                            runnerData?.trustScore ?? '0')! /
                                        100,
                                    strokeWidth: 6,
                                    backgroundColor: const Color(0xFF4A85E4),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                ),
                                Text(
                                  "${runnerData?.trustScore}%",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 800,
                      child: TabBarView(
                        children: [
                          _buildAboutSection(runnerData!),
                          _buildVerificationSection(),
                          _buildReviewSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection(GetRunnerProfileModel data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bio", style: _sectionTitleStyle),
          Text(data.bio, style: _sectionContentStyle),
          const SizedBox(height: 16),
          const Text("Task History", style: _sectionTitleStyle),
          Text("Tasks Completed: ${data.totalTasksCompleted}",
              style: _sectionContentStyle),
          const SizedBox(height: 16),
          const Text("Languages", style: _sectionTitleStyle),
          Text(data.languages.join(', '), style: _sectionContentStyle),
          const SizedBox(height: 16),
          const Text("Specializations", style: _sectionTitleStyle),
          Text(data.specializedTasks.join(', '), style: _sectionContentStyle),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verified Credentials", style: _sectionTitleStyle),
          SizedBox(height: 10),
          Column(
            children: staticListOfDocuments
                .where(
                  (element) => element['isAttendedTo'] ?? false,
                )
                .map(
                  (e) => VerificationItemWidget(
                      e['name'], e['verification_status']),
                )
                .toList(),
          )
          // ...List.generate(staticListOfDocuments.length, )

          // _VerificationItem("Government ID"),
          // _VerificationItem("Vehicle Registration"),
          // _VerificationItem("International Passport"),

          // _VerificationItem("Background Check"),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewItem(
              name: 'Serah A',
              review:
                  'James was quick and reliable — delivered my parcel within an hour.'),
          SizedBox(height: 10),
          _ReviewItem(
              name: 'John B',
              review:
                  'Very efficient and professional. Would hire again without hesitation.'),
        ],
      ),
    );
  }
}

// Shared styles
const _sectionTitleStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Outfit');
const _sectionContentStyle = TextStyle(fontSize: 14, fontFamily: 'Outfit');

// Reusable widgets

class _ReviewItem extends StatelessWidget {
  final String name;
  final String review;
  const _ReviewItem({required this.name, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: _sectionTitleStyle),
        Text(review, style: _sectionContentStyle),
        const Row(
          children: [
            Icon(Icons.star, color: Colors.orange, size: 18),
            Icon(Icons.star, color: Colors.orange, size: 18),
            Icon(Icons.star, color: Colors.orange, size: 18),
            Icon(Icons.star, color: Colors.orange, size: 18),
            Icon(Icons.star, color: Colors.orange, size: 18),
          ],
        ),
      ],
    );
  }
}
