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

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
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
                // 🔹 Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Notification',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Tabs with rounded background & pill indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      indicatorPadding: const EdgeInsets.all(4),
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
                        horizontal: 20,
                        vertical: 6,
                      ),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Tasks Updates'),
                        Tab(text: 'Bids & Offers'),
                        Tab(text: 'Payments'),
                      ],
                    ),
                  ),
                ),

                // 🔹 Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBody(context, state, "All"),
                      _buildBody(context, state, "Tasks Updates"),
                      _buildBody(context, state, "Bids & Offers"),
                      _buildBody(context, state, "Payments"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Tab Body Builder
  Widget _buildBody(BuildContext context, WalletState state, String tab) {
    if (state is GetClientNotificationLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetClientNotificationsSucessState) {
      List<ClientNotificationEntity> all = state.clientNotification;

      final tasks = all
          .where((n) =>
              n.type == 'Task Update' ||
              (n.title?.toLowerCase().contains('task invitation') ?? false))
          .toList();
      final bids = all
          .where((n) =>
              n.type == 'Bid & Offers' ||
              (n.title?.toLowerCase().contains('budget accepted') ?? false))
          .toList();
      final payments = all.where((n) => n.type == 'Payment').toList();

      switch (tab) {
        case "Tasks Updates":
          return buildNotificationList(tasks);
        case "Bids & Offers":
          return buildNotificationList(bids);
        case "Payments":
          return buildNotificationList(payments);
        default:
          return buildNotificationList(all);
      }
    } else if (state is GetClientNotificationErrorState) {
      return Center(child: Text(state.errorMessage));
    } else {
      context.read<WalletBloc>().add(
            GetClientNotificationEvent(clientnote: ClientNotificationModel()),
          );
      return const Center(child: CircularProgressIndicator());
    }
  }

  // 🔹 Notification List
  Widget buildNotificationList(List<ClientNotificationEntity> notifications) {
    if (notifications.isEmpty) {
      return Center(child: buildEmptyNotificationList());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final isBid = item.title == "You received a new bid";
        final isNewTaskAssign =
            (item.title?.trim().toLowerCase() ?? '') == 'new task assign';

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
              // Title Row
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
              Text(
                item.message ?? '',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (isNewTaskAssign) return;
                  final taskId = item.taskId ?? '';
                  context.goNamed(
                    MyAppRouteConstant.taskDetails,
                    extra: {'taskId': taskId},
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
