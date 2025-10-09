import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/errand_runer.dart/available_runner/runner_prrofile.dart';
import 'package:pikquick/features/profile/data/model/get_runner_profile_model.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/features/task/data/model/assign_task_model.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RunnerProfileHired extends StatefulWidget {
  final String userId;
  final String taskId;
  // ✅ Required to pass taskId

  const RunnerProfileHired({
    super.key,
    required this.userId,
    required this.taskId,
  });

  @override
  State<RunnerProfileHired> createState() => _RunnerProfileHiredState();
}

class _RunnerProfileHiredState extends State<RunnerProfileHired> {
  GetRunnerProfileModel? runnerData;
  bool isHired = false;

  @override
  void initState() {
    super.initState();
    _loadHireStatus();
    context.read<ProfileBloc>().add(
          RunnerDetailsInviteSentEvent(userId: widget.userId),
        );
  }

  Future<void> _loadHireStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isHired =
          prefs.getBool("hired_${widget.userId}_${widget.taskId}") ?? false;
    });
  }

  Future<void> _saveHireStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hired_${widget.userId}_${widget.taskId}", true);
  }

  void _showHireDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/con2.png', height: 60, width: 100),
                const SizedBox(height: 16),
                const Text(
                  'Runner Hired',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You hired this runner, kindly wait for feedback.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // 👇 Blue button-like container
                GestureDetector(
                  onTap: () {
                    context.pushReplacement(
                        MyAppRouteConstant.dashboard); // close dialog

                    context.pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      ' Go to Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ✅ Listen for profile state
        BlocListener<ProfileBloc, ProfileState>(
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
          },
        ),
        // ✅ Listen for assign task state
        BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is AssignTaskeSuccessState) {
              setState(() {
                isHired = true;
              });
              _saveHireStatus();
              _showHireDialog();
              // GetRunnerProfileModel;
            }
            if (state is AssignTaskeSErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: (runnerData == null)
          ? const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            )
          : DefaultTabController(
              length: 3,
              child: Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          onPressed: () {
                            context.pushReplacementNamed(
                                MyAppRouteConstant.clientNotification);
                          },
                        ),
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
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Outfit'),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.verified,
                                color: Colors.green, size: 20),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Experienced errand runner with a focus on \nreliability and speed.",
                          // runnerData?.bio ?? '',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0XFF434953),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Outfit'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            Text(
                              " ${runnerData?.averageRating?.toStringAsFixed(1) ?? '0.0'} ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0XFF98A2B3)),
                            ),
                            Text(
                              "| ${runnerData?.totalTasksCompleted ?? 0} errands completed",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0XFF98A2B3)),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.directions_bike,
                              size: 14,
                              color: Color(0XFF98A2B3),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              runnerData?.transportMode ?? '',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0XFF98A2B3)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// ✅ Button area (Hire OR Call/Message)
                        isHired
                            ? Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final phone = runnerData?.bio ?? '';
                                        if (phone.isNotEmpty) {
                                          final uri = Uri.parse("tel:$phone");
                                        }
                                      },
                                      child: FancyContainer(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.blue),
                                        height: 50,
                                        child: const Center(
                                          child: Text(
                                            'Call',
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
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final phone = runnerData?.bio ?? '';
                                        if (phone.isNotEmpty) {
                                          final uri = Uri.parse("sms:$phone");
                                        }
                                      },
                                      child: FancyContainer(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.blue),
                                        height: 50,
                                        child: const Center(
                                          child: Text(
                                            'Message',
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
                                  ),
                                ],
                              )
                            :

                            /// ✅ Hire Button
                            GestureDetector(
                                onTap: () {
                                  final hireModel = AssignTaskModel(
                                    runnerId: widget.userId,
                                    taskId: widget.taskId,
                                  );
                                  context.read<TaskBloc>().add(
                                      AssignTaskEvent(taskAssign: hireModel));
                                },
                                child: FancyContainer(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue),
                                  height: 50,
                                  width: double.infinity,
                                  child: const Center(
                                    child: Text(
                                      'Hire ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Outfit',
                                          color: Color(0XFF4A85E4)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    // Background half circle
                                    Container(
                                      width: 75,
                                      height:
                                          70, // Half the height for half circle
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(35),
                                          topRight: Radius.circular(35),
                                        ),
                                      ),
                                    ),
                                    // Progress half circle
                                    SizedBox(
                                      width: 90,
                                      height:
                                          30, // Half the height for half circle
                                      child: CustomPaint(
                                        painter: HalfCircleProgressPainter(
                                          progress: double.tryParse(
                                                  runnerData?.trustScore ??
                                                      '0')! /
                                              100,
                                          backgroundColor:
                                              const Color(0xFF4A85E4),
                                          progressColor: Colors.white,
                                          strokeWidth: 6,
                                        ),
                                      ),
                                    ),
                                    // Percentage text positioned in the middle of the half circle
                                    Positioned(
                                      top:
                                          30, // Adjusted to be in the middle of the half circle
                                      child: Text(
                                        "${runnerData?.trustScore}%",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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
            ),
    );
  }
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
                (e) => _VerificationItem(e['name'], e['verification_status']),
              )
              .toList(),
        )
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

// Shared styles
const _sectionTitleStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Outfit');
const _sectionContentStyle = TextStyle(fontSize: 14, fontFamily: 'Outfit');

class _VerificationItem extends StatelessWidget {
  final String title;
  final String status;

  const _VerificationItem(this.title, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _sectionContentStyle),
          (status == "verified")
              ? const Image(
                  image: AssetImage('assets/images/ci.png'),
                  width: 20,
                  height: 20,
                )
              : (status == "pending")
                  ? Icon(
                      Icons.pending_actions_rounded,
                      color: Colors.yellow,
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
        ],
      ),
    );
  }
}

// Reusable widgets
// class _VerificationItem extends StatelessWidget {
//   final String title;
//   const _VerificationItem(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: _sectionContentStyle),
//           const Image(
//             image: AssetImage('assets/images/ci.png'),
//             width: 20,
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }

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




































































//

//  void _showInviteSentModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return Container(
//           height: 250,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/icons/pending.png',
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Success',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Outfit',
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'You hired a runner',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Outfit',
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }


//  void _showInviteSentModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return Container(
//           height: 250,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/icons/pending.png',
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Success',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Outfit',
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'You hired a runner',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Outfit',
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }