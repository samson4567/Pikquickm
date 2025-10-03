import 'package:dartz/dartz.dart' as task;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
            appBar: AppBar(
              automaticallyImplyLeading: true, // Enables back arrow
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.go(MyAppRouteConstant.dashboard);
                },
              ),
              title: const Text('Notification'),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Task Update'),
                  Tab(text: 'Bid & Offers'),
                  Tab(text: 'Payment'),
                ],
              ),
            ),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WalletState state) {
    if (state is GetClientNotificationLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetClientNotificationsSucessState) {
      final allNotifications = state.clientNotification;

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
      return const Center(child: Text("No notifications found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final isBid = item.title == "You received a new bid";
        final isNewTaskAssign =
            (item.title?.trim().toLowerCase() ?? '') == 'new task assign';

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
                      left: 16, right: 16, top: 40, bottom: isBid ? 70 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        item.title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.id ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
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
                Positioned(
                  top: 10,
                  left: 10,
                  child: Image.asset(
                    'assets/icons/com.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
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
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        // Completely block click for "New Task assign"
                        if (isNewTaskAssign) return;

                        final taskId = item.taskId ?? '';
                        context.goNamed(
                          MyAppRouteConstant.taskDetails,
                          extra: {'taskId': taskId},
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              isNewTaskAssign ? Colors.grey : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 50,
                          maxWidth: 200,
                        ),
                        child: Text(
                          item.message ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            decoration: isNewTaskAssign
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
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

  Widget buildNotificationListOld(
      List<ClientNotificationEntity> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text("No notifications found."));
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
                      left: 16, right: 16, top: 40, bottom: isBid ? 70 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        item.title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                Positioned(
                  top: 10,
                  left: 10,
                  child: Image.asset(
                    'assets/icons/com.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
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
                    right: 15,
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
                          color:
                              isTaskRejected ? Colors.grey : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 50,
                          maxWidth: 200,
                        ),
                        child: Text(
                          item.message ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
