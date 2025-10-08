import 'package:dartz/dartz.dart' as task;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/components.dart';
import 'package:pikquick/features/wallet/domain/entities/client_notification.enity.dart';
import 'package:pikquick/features/wallet/presentation/wallet_bloc.dart';
import 'package:pikquick/features/wallet/presentation/wallet_event.dart';
import 'package:pikquick/features/wallet/presentation/wallet_state.dart';
import 'package:pikquick/features/wallet/data/model/client_notification_model.dart';
import 'package:pikquick/router/router_config.dart';

class CleintNotificatiion extends StatefulWidget {
  const CleintNotificatiion({super.key});

  @override
  State<CleintNotificatiion> createState() => _CleintNotificatiionState();
}

class _CleintNotificatiionState extends State<CleintNotificatiion> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is GetClientNotificationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Header - Updated to vertical layout
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                context.go(MyAppRouteConstant.dashboard);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '  Notification',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs - Updated to container style
                  Container(
                    width: 342,
                    height: 44,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        color: Colors
                            .white, // Selection indicator color #FFFFFF would be white, using blue for visibility
                        borderRadius: BorderRadius.circular(6),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                      tabs: const [
                        Tab(
                          child: Text(
                            'All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Task Update',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Bid & Offers',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Payment',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WalletState state) {
    if (state is GetClientNotificationLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetClientNotificationsSucessState) {
      List<ClientNotificationEntity> allNotifications =
          state.clientNotification;
      // allNotifications = [];

      final taskUpdateNotifications = allNotifications.where((n) {
        final title = n.title?.trim().toLowerCase() ?? '';
        return n.type == 'Task Update' || title == 'task rejected';
      }).toList();

      final bidOffersNotifications = allNotifications.where((n) {
        final title = n.title?.trim().toLowerCase() ?? '';
        return n.type == 'Bid & Offers' || title == 'budget accepted';
      }).toList();

      final paymentNotifications =
          allNotifications.where((n) => n.type == 'Payment').toList();

      return TabBarView(
        children: [
          buildNotificationList(allNotifications),
          buildNotificationList(taskUpdateNotifications),
          buildNotificationList(bidOffersNotifications),
          buildNotificationList(paymentNotifications),
        ],
      );
    } else if (state is GetClientNotificationErrorState) {
      return Center(child: Text(state.errorMessage));
    } else {
      context.read<WalletBloc>().add(
            GetClientNotificationEvent(
              clientnote: ClientNotificationModel(),
            ),
          );
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget buildNotificationList(List<ClientNotificationEntity> notifications) {
    if (notifications.isEmpty) {
      return Center(child: buildEmptyNotificationList());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final isBid = item.title == "You received a new bid";
        final isTaskRejected =
            item.title?.trim().toLowerCase() == "task rejected";

        return Center(
          child: SizedBox(
            width: 342,
            height: isBid ? 260 : 230,
            child: Stack(
              children: [
                Container(
                  width: 342,
                  height: isBid ? 260 : 230,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: isBid ? 70 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Title, icon and timestamp in the same row - Icon comes first
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FancyContainer2(
                            borderColor: getFigmaColor("FFC57D00"),
                            borderwidth: 5,
                            height: 20,
                            width: 20,
                            radius: 20,
                            hasBorder: true,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              item.title ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "just now",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.message ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isBid)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Accept Bid',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Reject Bid',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: GestureDetector(
                      onTap: isTaskRejected
                          ? null
                          : () {
                              final taskId = item.taskId ?? '';
                              final userId = item.relatedUserId ?? '';
                              print(
                                  'Navigating to runner profile with userId: $userId');
                              context.goNamed(
                                MyAppRouteConstant.runnerProfileHired,
                                extra: {'userId': userId, 'taskId': taskId},
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 50,
                          maxWidth: 200,
                        ),
                        child: Text(
                          item.message ?? '',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
