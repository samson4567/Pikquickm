import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/features/authentication/data/models/refrresh_toke_model.dart';
import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/features/transaction/presentation/transaction_bloc.dart';
import 'package:pikquick/features/transaction/presentation/transaction_event.dart';
import 'package:pikquick/features/transaction/presentation/transaction_state.dart';
import 'package:pikquick/router/router_config.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/security/secure_key.dart';

class DashboardPage extends StatefulWidget {
  final String taskId;
  final String bidId;
  const DashboardPage({super.key, required this.taskId, required this.bidId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, String>> _categories = const [
    {
      "id": "pickup",
      "image": "assets/images/product1.png",
      "title": "Pick Up & \nDelivery",
      "name": "Pick Up & Delivery",
      "description": "We pick up items and deliver them anywhere",
    },
    {
      "id": "doc",
      "image": "assets/images/product2.png",
      "title": "Document & \nDispatch",
      "name": "Document & Dispatch",
      "description": "Urgent documents, contracts, passports, etc.",
    },
    {
      "id": "gift",
      "image": "assets/images/product3.png",
      "title": "Gift & \nParcel",
      "name": "Gift & Parcel",
      "description": "Wrap up the perfect surprise and deliver it",
    },
    {
      "id": "helping",
      "image": "assets/images/product3.png",
      "title": "Helping",
      "name": "Helping Hands",
      "description": "Hire someone for small tasks and errands",
    },
  ];

  double _popupTop = 10;
  double _popupLeft = 16;

  /// controls showing bid popup
  bool _showBidPopup = false;

  @override
  void initState() {
    super.initState();
    _refreshAccessToken();

    context.read<AuthBloc>().add(
          TaskCategoryEvent(categoryModel: CustomCategoryTaskModel()),
        );
    context.read<TransactionBloc>().add(
          BidHistroyEvent(taskId: widget.taskId),
        );
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

  void _showSuccessModal({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/con2.png', height: 60, width: 100),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) =>
              c is TaskCategorySuccessState ||
              c is TaskCategoryErrorState ||
              c is RefreshTokenErrorState ||
              c is RefreshTokenSuccessState,
          listener: (context, state) {
            if (state is TaskCategorySuccessState) {
              setState(() {
                _categories = state.categories.map((e) {
                  final model =
                      CustomCategoryTaskModel.fromCustomCategoryTaskEntity(e);
                  return {
                    "id": model.id ?? "",
                    "image": model.categoryImage ?? "",
                    "title": model.name ?? "",
                    "name": model.name ?? "",
                    "description": model.description ?? "",
                  };
                }).toList();
              });
            } else if (state is TaskCategoryErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is RefreshTokenErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Session expired. Please log in again."),
                ),
              );
              context.goNamed(MyAppRouteConstant.login);
            } else if (state is RefreshTokenSuccessState) {
              final appPref = AppPreferenceService();
              appPref.saveValue(
                  SecureKey.loginAuthTokenKey, state.token.refreshToken);
            }
          },
        ),

        BlocListener<TaskBloc, TaskState>(
          listenWhen: (p, c) =>
              c is AcceptBidSuccessState ||
              c is AcceptBidErrorState ||
              c is BidRejectSuccessState ||
              c is BidRejectErrorState,
          listener: (context, state) {
            if (state is AcceptBidSuccessState) {
              setState(() => _showBidPopup = false);
              _showSuccessModal(
                title: "Bid Accepted",
                message: "You have successfully accepted this bid.",
              );
            } else if (state is AcceptBidErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is BidRejectSuccessState) {
              setState(() => _showBidPopup = false);
              _showSuccessModal(
                title: "Bid Rejected",
                message: "You have successfully rejected this bid.",
              );
            } else if (state is BidRejectErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),

        /// Detect when bid history is loaded to show popup
        BlocListener<TransactionBloc, TransactionState>(
          listenWhen: (p, c) => c is BidaHistorySuccessState,
          listener: (context, state) {
            if (state is BidaHistorySuccessState) {
              setState(() => _showBidPopup = true);
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is TaskCategoryLoadingState ||
              state is RefreshTokenLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: size.height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(size),
                        SizedBox(height: size.height * 0.02),
                        const Text(
                          "Find an errand runner",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gap',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        _buildSectionTitle(context, "Featured Categories"),
                        SizedBox(height: size.height * 0.015),
                        _buildCategoryGrid(size),
                        SizedBox(height: size.height * 0.04),
                        _buildLargeContainer(size, const Color(0xFF4A85E4)),
                      ],
                    ),
                  ),

                  /// Draggable Bid popup
                  if (_showBidPopup)
                    Positioned(
                      top: _popupTop,
                      left: _popupLeft,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _popupTop += details.delta.dy;
                            _popupLeft += details.delta.dx;
                          });
                        },
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            width: 355,
                            constraints: const BoxConstraints(minHeight: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2FAFF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/com.png",
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "You Received a New Bid!",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "You have received a new bid for your task. Would you like to accept or reject it?",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.read<TaskBloc>().add(
                                                AcceptBidEvent(
                                                    acceptBid: widget.bidId),
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.read<TaskBloc>().add(
                                              BidRejectEvent(
                                                  bidReject: widget.bidId));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Welcome back, ${av.userModelG?.fullName ?? ''}',
            style: const TextStyle(
              fontFamily: 'Gap',
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CircleAvatar(
          radius: size.width * 0.06,
          backgroundColor: Colors.grey.shade100,
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              context.pushNamed(MyAppRouteConstant.clientNotification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Gap',
          ),
        ),
        GestureDetector(
          onTap: () =>
              context.pushNamed(MyAppRouteConstant.feauturedCategoriesTask),
          child: const Text(
            "View All",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Gap',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(Size size) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: size.width * 0.02,
          mainAxisSpacing: size.width * 0.02,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final item = _categories[index];
          final image = item["image"] ?? "";
          final isUrl = image.startsWith("http");

          return GestureDetector(
            onTap: () {
              av.taskModelbeingCreated = TaskModel(
                categoryId: item['id']!,
                taskType: item['name']!,
                description: item['description']!,
                name: item['name']!,
              );
              context.push(MyAppRouteConstant.deliveryScreen);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.width * 0.18,
                  width: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isUrl
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          )
                        : Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item["title"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _buildLargeContainer(Size size, Color color) {
    return GestureDetector(
      onTap: () {
        av.taskModelbeingCreated ??= TaskModel.empty();
        context.pushNamed(MyAppRouteConstant.hirerunnerPage);
      },
      child: Container(
        width: double.infinity,
        height: size.height * 0.16,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Book a task now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Gap',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Book an errand runner to take care of your task for you",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}

  // const taskId = "51656f02-30fc-4ce1-8082-0de534795acd";
  //   context.read<TransactionBloc>().add(
  //         BidHistroyEvent(taskId: taskId),
  //       );
  // }