import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/app_variable.dart' as runner;
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/security/secure_key.dart';
import 'package:pikquick/errand_runer.dart/profile/my_profile.dart';
import 'package:pikquick/features/authentication/data/models/refrresh_toke_model.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/features/task/data/model/active_task_model.dart';
import 'package:pikquick/features/task/domain/entitties/my_document_entity.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/features/wallet/data/model/walllet_balance_model.dart';
import 'package:pikquick/features/wallet/data/model/runner_available_model.dart';
import 'package:pikquick/features/wallet/presentation/wallet_bloc.dart';
import 'package:pikquick/features/wallet/presentation/wallet_event.dart';
import 'package:pikquick/features/wallet/presentation/wallet_state.dart';
import 'package:pikquick/hire_an_errand.dart/wallet/add-funds.dart';
import 'package:pikquick/router/router_config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isToggled = false;
  double currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _refreshAccessToken();
  }

  void _fetchInitialData() {
    final walletModel = WalletBalanceModel(balance: 0.0);
    context
        .read<WalletBloc>()
        .add(WalletBalanceEvent(walletBalance: walletModel));

    // this is to help fetch runner image url
    context
        .read<ProfileBloc>()
        .add(GetrunnerProfileEvent(userID: userModelG!.id));
    context.read<AuthBloc>().add(GetRunnerVerificationDetailsEvent());
    context.read<ProfileBloc>().add(GetVerifiedDocumentsEvent());

    context.read<TaskBloc>().add(
          ActivetaskEvent(),
        );
    // SchedulerBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     context.push(MyAppRouteConstant.errandNotification);
    //   },
    // );
  }

  Future<void> _refreshAccessToken() async {
    final appPref = AppPreferenceService();
    final refreshToken =
        await appPref.getValue<String>(SecureKey.refreshTokenKey);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      context.read<AuthBloc>().add(
            RefreshTokenEvent(
              model: RefreshTokenModel(refreshToken: refreshToken),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) async {
        if (state is WalletBalanceSuccessState) {
          setState(() {
            currentBalance = state.balance.balance;
          });
        } else if (state is WalletBalanceErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is RunnerAvailableSuccessState) {
          setState(() => isToggled = true);
          await Future.delayed(Duration(milliseconds: 300));
          if (mounted) _showSuccessDialog();
        } else if (state is RunnerAvailablErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child:
          BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
        print("asdkbdajdgasdj${state}");
        if (state is GetrunnerProfileSuccessState) {
          userModelG?.imageUrl = state.getProfile.profilePictureUrl;
          setState(() {});
        }
        if (state is GetVerifiedDocumentsSuccessState) {
          alignDocumentsNature(state.listOfMyDocumentModel);
        }
      }, builder: (context, state) {
        return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is GetRunnerVerificationDetailsSuccessState) {
            if ((state.runnerVerificationDetailsEntity.totalVerified ?? 0) <
                (state.runnerVerificationDetailsEntity.totalRequired ?? 0)) {
              showDialog(
                context: context,
                builder: (context) {
                  return VerificationAlert(
                    onClose: () {
                      context.pop();
                    },
                    onVerifyIdentity: () {
                      context.pop();
                      context.push(MyAppRouteConstant.accountInfoScreen);
                    },
                  );
                },
              );
            }
            // userModelG?.imageUrl = ;
            setState(() {});
          }
        }, builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                // Background with blue and white sections
                Column(
                  children: [
                    Container(height: 200, color: Colors.blue),
                    Expanded(child: Container(color: Colors.white)),
                  ],
                ),

                // Content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header section on blue background
                      Container(
                        height: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MyProfile())),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: (userModelG?.imageUrl !=
                                            null)
                                        ? NetworkImage(userModelG!.imageUrl!)
                                        : (userModelG?.imageUrl != null)
                                            ? NetworkImage(
                                                userModelG!.imageUrl!)
                                            : AssetImage(
                                                'assets/images/circle.png'),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 17),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<ProfileBloc>()
                                              .add(GetVerifiedDocumentsEvent());
                                          // context.read<AuthBloc>().add(
                                          //     GetRunnerVerificationDetailsEvent());
                                        },
                                        child: Text('Welcome back',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Outfit',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Text(
                                        userModelG?.fullName ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _handleToggle,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 56,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isToggled
                                          ? const Color(0xFF40B869) // ON color
                                          : const Color(
                                              0xFFE4E4E7), // OFF color
                                    ),
                                    child: AnimatedAlign(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      alignment: isToggled
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      curve: Curves.easeInOut,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: const Icon(Icons.notifications,
                                        color: Colors.black),
                                    onPressed: () => context.pushNamed(
                                      MyAppRouteConstant.errandNotification,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 💰 Balance Section
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: balance(),
                          ),

                          // 🧾 Payout + Task Controls Section
                          Container(
                            width: double.infinity,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Row — Request payout
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Request payout to your bank',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context
                                          .go(MyAppRouteConstant.requestpayout),
                                      child: Container(
                                        height: 48,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Withdraw',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Outfit',
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Icon(Icons.arrow_upward,
                                                  size: 18,
                                                  color: Colors.black),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // Bottom Row — Browse & Manage Tasks
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Browse New Tasks
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => context.push(
                                            MyAppRouteConstant.availabeTask),
                                        child: Container(
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFECFBFF),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Browse New Tasks',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Outfit',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Manage Active Tasks
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => context.push(
                                            MyAppRouteConstant
                                                .taskHistoryrunner),
                                        child: Container(
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF1D6),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Manage Active Tasks',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Outfit',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Active Task',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0XFF162844),
                                  fontFamily: 'Outfit'),
                            ),
                            TextButton(
                                onPressed: () {
                                  context.goNamed(
                                      MyAppRouteConstant.taskHistoryrunner);
                                },
                                child: Text(
                                  'View all ',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                      Activetask(),
                      performanceSummary(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }

  alignDocumentsNature(List<MyDocumentEntity> documents) {
    MyDocumentEntity? theDoc;
    staticListOfDocuments.forEach(
      (element) {
        if (documents.any(
          (document) {
            bool isTrue = document.documentTypeId == element["id"];
            if (isTrue) {
              theDoc = document;
            }

            return isTrue;
          },
        )) {
          element['isAttendedTo'] = true;
          element['verification_status'] = theDoc?.verificationStatus;
        }
        ;
      },
    );
// staticListOfDocuments
  }

  Widget balance() {
    return Transform.translate(
      offset: Offset(0, -50),
      child: Container(
        width: 390,
        height: 110,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF2FAFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('Current Balance',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Outfit',
                        color: Color(0XFF070D17))),
                Spacer(),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(height: 8),
            Text('₦${currentBalance.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Outfit')),
          ],
        ),
      ),
    );
  }

  void _handleToggle() {
    if (isToggled) {
      setState(() => isToggled = true);
      return;
    }
    if (currentBalance >= 100) {
      _showConfirmationDialog();
    } else {
      _showLowBalanceDialog();
    }
  }

  void _showConfirmationDialog() {
    _showDialog(
      iconPath: 'assets/images/con.png',
      title: 'Activate Availability',
      message: 'Pay ₦100 to activate your availability today.',
      actionLabel: 'Pay now',
      onAction: () {
        Navigator.of(context, rootNavigator: true).pop();
        final availabilityModel = RunnerAvailableModel(isAvailable: true);
        context
            .read<WalletBloc>()
            .add(RunnerAvailabeEvent(runnerAvailable: availabilityModel));
      },
    );
  }

  void _showSuccessDialog() {
    _showDialog(
      iconPath: 'assets/images/con2.png',
      title: 'Payment Successful',
      message: 'Your availability is now active.',
      actionLabel: 'Continue',
      onAction: () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }

  void _showLowBalanceDialog() {
    _showDialog(
      iconPath: 'assets/images/low.png',
      title: 'Low Balance',
      message: 'Your balance is low. Please top up.',
      actionLabel: 'Add money to your wallet',
      onAction: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddFunds()));
      },
    );
  }

  void _showDialog({
    required String iconPath,
    required String title,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, height: 60),
            SizedBox(height: 20),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Text(message,
                style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(actionLabel, style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

// Active Task Widget
Widget Activetask() {
  return BlocBuilder<TaskBloc, TaskState>(
    builder: (context, state) {
      if (state is ActivetaskLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ActivetaskErrorState) {
        return Center(
          child: Text(
            state.errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        );
      }

      if (state is ActivetaskSuccessState && state.runnertask.isNotEmpty) {
        return SizedBox(
          height: 340,
          child: AnimationLimiter(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.runnertask.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final task = state.runnertask[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 100.0,
                    curve: Curves.easeOut,
                    child: FadeInAnimation(
                      child: _buildTaskCard(
                        taskId: task.id ?? '',
                        title: task.taskDescription ?? '',
                        time:
                            "Needed in ${task.createdAt ?? ''}", // TODO: format properly
                        price: "₦${task.taskBudget ?? ''}",
                        pickupAddress: task.pickupAddress ?? '',
                        dropOffAddress: task.dropOffAddress ?? '',
                        clientName: task.clientName ?? '',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }

      // Fallback demo card
      return SizedBox(
        height: 340,
        child: AnimationLimiter(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 100.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildTaskCard(
                    taskId: "TASK001",
                    title: "Deliver a parcel from Lekki to Ikeja",
                    time: "Needed in 2 hours",
                    price: "₦5000",
                    clientName: 'Sam Client',
                    pickupAddress: '',
                    dropOffAddress: ''),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildTaskCard({
  required String taskId,
  required String title,
  required String time,
  required String price,
  required String clientName,
  required String pickupAddress,
  required String dropOffAddress,
}) {
  return GestureDetector(
    onTapDown: (_) {}, // can add press animation later
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 350,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FAFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // ✅ Wrap content with scroll view to prevent overflow
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: 'Outfit',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Time
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0XFF434953),
                fontFamily: 'Outfit',
              ),
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 10),

            Text(
              'Location',
              style: const TextStyle(
                  fontSize: 14,
                  color: Color(0XFF434953),
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600),
            ),

            // Text(
            //   price,
            //   style: const TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     fontFamily: 'Outfit',
            //     color: Colors.black87,
            //   ),
            // ),
            // Text(
            //   clientName,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //     fontFamily: 'Outfit',
            //     color: Colors.black54,
            //   ),
            // ),

            const SizedBox(height: 16),

            // Pickup
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Pickup: ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0XFF434953),
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: pickupAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Drop-off
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Drop-off: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFF434953),
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: dropOffAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Task ID
            Text(
              "Task ID: $taskId",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontFamily: 'Outfit',
              ),
            ),

            const SizedBox(height: 16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 0.45,
                color: Color(0XFF375EF9),
                backgroundColor: Colors.grey,
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 16),

            // View Details Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  final taskId = runner.taskId ?? '';
                  // context.pushNamed(
                  //   MyAppRouteConstant.taskHOverview,
                  //   extra: {'taskId': taskId},
                  // );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0XFF4A85E4),
                  side: BorderSide(
                    color: Color(0XFF4A85E4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF375EF9)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget performanceSummary() {
  return BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {
      if (state is GetrunnerPerformanceLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is GetrunnerPerformanceeSuccessState) {
        final data = state.getProfilePerformance;

        final hasNoPerformance = data.totalTasksCompleted == 0 &&
            (data.topServices.isEmpty ||
                data.topServices.every((s) => s.trim().isEmpty));

        if (hasNoPerformance) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'No performance yet',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Task completed', style: TextStyle(fontSize: 16)),
                    Text('Average Rating', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data.totalTasksCompleted} this month',
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          data.averageRating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(
                          data.averageRating.toInt(),
                          (index) =>
                              Icon(Icons.star, color: Colors.amber, size: 18),
                        ),
                        if (data.averageRating - data.averageRating.floor() >=
                            0.5)
                          Icon(Icons.star_half, color: Colors.amber, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Top Services',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.topServices
                      .map((service) =>
                          Text(service, style: TextStyle(fontSize: 15)))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      }

      if (state is GetrunnerPerformanceeErrorState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: ${state.errorMessage}'),
        );
      }

      return const SizedBox(); // Default fallback UI
    },
  );
}

class VerificationAlert extends StatelessWidget {
  final Function()? onVerifyIdentity;
  final Function()? onClose;

  const VerificationAlert({
    super.key,
    this.onVerifyIdentity,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FancyContainer2(
        nulledAlign: true,
        width: MediaQuery.of(context).size.width * 0.75, // smaller width
        radius: 18, // slightly smaller radius
        backgroundColor: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20), // tighter padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: FancyContainer2(
                action: onClose,
                isAsync: false,
                child: Icon(
                  Icons.close,
                  size: 17, // smaller close icon
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Icon Container
            FancyContainer2(
              width: 60,
              height: 60,
              radius: 12,
              backgroundColor: const Color(0xFFFFC107).withOpacity(0.85),
              child: const Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            FancyText(
              'Verify Identity',
              size: 16, // smaller title
              weight: FontWeight.w700,
              textColor: Colors.black,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Subtitle/Message
            FancyText(
              'You must complete your verification before you can get hired for tasks.',
              size: 12, // smaller text
              textColor: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Action Button
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return FancyContainer2(
      action: onVerifyIdentity,
      isAsync: true,
      width: double.infinity,
      height: 44, // reduced height
      radius: 10,
      backgroundColor: const Color(0xFF4285F4),
      child: FancyText(
        'Verify Now',
        size: 14, // slightly smaller text
        weight: FontWeight.w600,
        textColor: Colors.white,
        textAlign: TextAlign.center,
      ),
    );
  }
}














// SingleChildScrollView Activetask() {
//   return SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       children: List.generate(5, (index) {
//         // Sample data list with taskId
//         final parcels = [
//           {
//             "taskId": "TASK001",
//             "title": "Deliver a parcel from Lekki to Ikeja",
//             "time": "Needed in 2 hours",
//             "price": "₦5000",
//             "pickup": "Lekki Phase 1",
//             "dropoff": "Ikeja",
//           },
//           {
//             "taskId": "TASK002",
//             "title": "Move documents from VI to Yaba",
//             "time": "Needed by today",
//             "price": "₦3500",
//             "pickup": "Victoria Island",
//             "dropoff": "Yaba",
//           },
//           {
//             "taskId": "TASK003",
//             "title": "Send gift from Ajah to Magodo",
//             "time": "Deliver in 4 hours",
//             "price": "₦7000",
//             "pickup": "Ajah",
//             "dropoff": "Magodo",
//           },
//           {
//             "taskId": "TASK004",
//             "title": "Food delivery to Surulere",
//             "time": "ASAP",
//             "price": "₦2500",
//             "pickup": "Ikeja",
//             "dropoff": "Surulere",
//           },
//           {
//             "taskId": "TASK005",
//             "title": "Send keys to Lekki",
//             "time": "Today before 6pm",
//             "price": "₦3000",
//             "pickup": "Yaba",
//             "dropoff": "Lekki",
//           },
//         ];

//         final item = parcels[index];

//         return Padding(
//           padding: const EdgeInsets.only(right: 16),
//           child: Container(
//             width: 300,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white70,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 4),
//                 Text(
//                   item['title']!,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   item['time']!,
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Divider(height: 9, color: Colors.grey[300]),
//                 SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Text(
//                       item['price']!,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       'Offer your Bid',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Location',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 6),
//                 Text(
//                   'Pick-up: ${item['pickup']}',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Text(
//                   'Drop-off: ${item['dropoff']}',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Text(
//                   'Task ID: ${item['taskId']}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Center(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       // Handle view details action
//                       print('Task ID: ${item['taskId']}');
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'View Details',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     ),
//   );
// }

// ignore: non_constant_identifier_names
// SingleChildScrollView RecommendedTask() {
//   return SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       children: List.generate(5, (index) {
//         // Sample data list (replace with your own dynamic data if needed)
//         final parcels = [
//           {
//             "title": "Deliver a parcel from Lekki to Ikeja",
//             "time": "Needed in 2 hours",
//             "price": "₦5000",
//             "pickup": "Lekki Phase 1",
//             "dropoff": "Ikeja",
//           },
//           {
//             "title": "Move documents from VI to Yaba",
//             "time": "Needed by today",
//             "price": "₦3500",
//             "pickup": "Victoria Island",
//             "dropoff": "Yaba",
//           },
//           {
//             "title": "Send gift from Ajah to Magodo",
//             "time": "Deliver in 4 hours",
//             "price": "₦7000",
//             "pickup": "Ajah",
//             "dropoff": "Magodo",
//           },
//           {
//             "title": "Food delivery to Surulere",
//             "time": "ASAP",
//             "price": "₦2500",
//             "pickup": "Ikeja",
//             "dropoff": "Surulere",
//           },
//           {
//             "title": "Send keys to Lekki",
//             "time": "Today before 6pm",
//             "price": "₦3000",
//             "pickup": "Yaba",
//             "dropoff": "Lekki",
//           },
//         ];

//         final item = parcels[index];

//         return Padding(
//           padding: const EdgeInsets.only(right: 16),
//           child: Container(
//             width: 300,
//             height: 283,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white70,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['title']!,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   item['time']!,
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Divider(height: 9, color: Colors.grey[300]),
//                 SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Text(
//                       item['price']!,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       'Offer your Bid',
//                       style: TextStyle(fontSize: 14, color: Colors.blue),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   'Location',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: 6),
//                 Text(
//                   'Pick-up: ${item['pickup']}',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Text(
//                   'Drop-off: ${item['dropoff']}',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Spacer(),
//                 Center(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       // Handle view details action
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'View Details',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       }),
//     ),
//   );
// }

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text('Recommended Task'),
//     Text('Explore All',
//         style: TextStyle(
//             color: Colors.blue,
//             fontWeight: FontWeight.bold)),
//   ],
// ),
// RecommendedTask(),

// This widget displays a modal alert prompting the user to verify their identity.

// Example of how to show this as a bottom sheet:
/*
void showVerificationAlert(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent, // Important for the rounded FancyContainer to show
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VerificationAlert(
          onVerifyIdentity: () {
            Navigator.pop(context); // Close sheet
            print('Navigating to verification screen...');
            // TODO: Navigate to the ID Verification Document Type screen
          },
          onClose: () {
            Navigator.pop(context); // Close sheet
            print('Alert dismissed');
          },
        ),
      );
    },
  );
}

// You would call it like this:
// ElevatedButton(
//   onPressed: () => showVerificationAlert(context),
//   child: const Text('Show Alert'),
// )
*/