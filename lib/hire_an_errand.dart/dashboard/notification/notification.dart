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

class _CleintNotificatiionState extends State<CleintNotificatiion>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

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
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button + title (VERTICAL)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black),
                        onPressed: () {
                          context.go(MyAppRouteConstant.dashboard);
                        },
                      ),
                      Text(
                        'Notification',
                        style: GoogleFonts.outfit(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black.withOpacity(0.6),
                      labelStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Tasks Updates'),
                        Tab(text: 'Bids & Offers'),
                        Tab(text: 'Payments'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tab content
                Expanded(child: _buildBody(context, state)),
              ],
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
        controller: _tabController,
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
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final isTaskRejected =
            item.title?.trim().toLowerCase() == "task rejected";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF8FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (icon + title + time)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FancyContainer2(
                    borderColor: getFigmaColor("FFC57D00"),
                    borderwidth: 5,
                    height: 20,
                    width: 20,
                    radius: 20,
                    hasBorder: true,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Just now',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Message
              Text(
                item.message ?? '',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 10),

              // Action link
              GestureDetector(
                onTap: isTaskRejected
                    ? null
                    : () {
                        final taskId = item.taskId ?? '';
                        final userId = item.relatedUserId ?? '';
                        context.goNamed(
                          MyAppRouteConstant.runnerProfileHired,
                          extra: {'userId': userId, 'taskId': taskId},
                        );
                      },
                child: Text(
                  "View Task",
                  style: GoogleFonts.outfit(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
