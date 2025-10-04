import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/features/profile/data/model/auto_sub_daily.dart';
import 'package:pikquick/features/profile/data/model/unto_auto_daily.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';
import 'package:pikquick/features/task/data/model/wallet_summary_model.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';
import 'package:pikquick/features/transaction/presentation/transaction_bloc.dart';
import 'package:pikquick/features/transaction/presentation/transaction_event.dart';
import 'package:pikquick/features/transaction/presentation/transaction_state.dart';
import 'package:pikquick/features/wallet/data/model/walllet_balance_model.dart'
    show WalletBalanceModel;
import 'package:pikquick/features/wallet/presentation/wallet_bloc.dart';
import 'package:pikquick/features/wallet/presentation/wallet_event.dart';
import 'package:pikquick/features/wallet/presentation/wallet_state.dart';
import 'package:pikquick/router/router_config.dart';

class ErrandWallet extends StatefulWidget {
  const ErrandWallet({super.key});

  @override
  State<ErrandWallet> createState() => _ErrandWalletState();
}

class _ErrandWalletState extends State<ErrandWallet> {
  bool isAutoDeductionEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Fetch transactions
    context.read<TransactionBloc>().add(
          const TransactionHistoryEvent(
            limit: '10',
            page: '1',
          ),
        );

    // Fetch wallet balance
    final walletModel = WalletBalanceModel(balance: 0.0);
    context
        .read<WalletBloc>()
        .add(WalletBalanceEvent(walletBalance: walletModel));

    // Fetch wallet summary
    final summaryModel = WalletSummaryModel(
      totalEarningsAllTime: null,
      withdrawableBalance: null,
      pendingPayments: null,
      completedTasks: null,
      totalTasks: null,
      averageEarningsPerTask: null,
      thisMonthEarnings: null,
      lastMonthEarnings: null,
      earningsBreakdown: null,
      recentTransactions: [],
    );
    context.read<TaskBloc>().add(WalletSummaryEvent(model: summaryModel));
  }

  // 🔵 Custom Dialog
  void _showCustomDialog({required String title, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 342,
            height: 190,
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close,
                        size: 20, color: Colors.black54),
                  ),
                ),

                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Outfit",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: "Outfit",
                      ),
                    ),
                    const Spacer(),

                    // Action button
                    Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            minimumSize: const Size(
                                120, 40), // 👈 set width=120, height=40
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Dashbord",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Outfit",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  ],
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: const [
                SizedBox(width: 20),
                Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Wallet Balance
            balance(context),
            const SizedBox(height: 20),

            // Auto Deduction Toggle (Bloc integrated)
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is SubscribeAutoDeductionSuccess) {
                  setState(() => isAutoDeductionEnabled = true);
                  _showCustomDialog(
                    title: "Availability Fee Deducted",
                    message:
                        "Your wallet has been deducted your daily availability. "
                        "This fee will make you available for 24 hours.",
                  );
                } else if (state is UnsubscribeAutoDeductionSuccess) {
                  setState(() => isAutoDeductionEnabled = false);
                  _showCustomDialog(
                    title: "Auto-Deduction Disabled",
                    message: "You have successfully unsubscribed "
                        "from auto-deduction.",
                  );
                } else if (state is SubscribeAutoDeductionError ||
                    state is UnsubscribeAutoDeductionError) {
                  final errorMessage = state is SubscribeAutoDeductionError
                      ? state.errorMessage
                      : (state as UnsubscribeAutoDeductionError).errorMessage;
                  _showCustomDialog(
                    title: "Error",
                    message: errorMessage,
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is SubscribeAutoDeductionLoading ||
                    state is UnsubscribeAutoDeductionLoading;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Auto Deduction ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Enable daily auto-deduction of 100 availability",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : Switch(
                            value: isAutoDeductionEnabled,
                            onChanged: (value) {
                              if (value) {
                                context.read<ProfileBloc>().add(
                                      ToggleSubscribeAutoDeductionEvent(
                                        model: SubscribeAutoDeductionModel(
                                          subscribe: true,
                                        ),
                                      ),
                                    );
                              } else {
                                context.read<ProfileBloc>().add(
                                      UnsubscribeAutoDeductionEvent(
                                        model: UnsubscribeAutoDeductionModel(
                                          unsubscribe: false,
                                        ),
                                      ),
                                    );
                              }
                            },
                          ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Earning Summary (Bloc integrated)
            BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is WalletSummaryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WalletSummaryErrorState) {
                  return Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is WalletSummarySuccessState) {
                  final summary = state.walletSummary;
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Earning Summary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pending Earning",
                              style:
                                  TextStyle(fontFamily: 'Outfit', fontSize: 14),
                            ),
                            Text(
                              "₦${summary.pendingPayments ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Withdrawal Balance",
                              style:
                                  TextStyle(fontFamily: 'Outfit', fontSize: 14),
                            ),
                            Text(
                              "₦${summary.withdrawableBalance ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "All-time Earning",
                              style:
                                  TextStyle(fontFamily: 'Outfit', fontSize: 14),
                            ),
                            Text(
                              "₦${summary.totalEarningsAllTime ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 30),

            // Transaction History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Transaction History",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push(MyAppRouteConstant.addpayment);
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Transactions List
            Expanded(child: transactionList()),
          ],
        ),
      ),
    );
  }
}

Expanded transactionList() {
  return Expanded(
    child: BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionHistoryLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionHistoryErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is TransactionHistorySuccessState) {
          final transactions = state.transactionHistory;

          if (transactions.isEmpty) {
            return Center(child: Image.asset('assets/images/tract.png'));
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 30),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Image.asset(
                        transaction.metadata ?? 'assets/icons/ri.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              transaction.type ?? 'Transaction',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Text(
                              "₦${transaction.amount ?? '0'}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              transaction.status ?? 'Date not available',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Text(
                              transaction.status ?? 'Completed',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const Center(
          child: Text(
            "No transaction data",
            style: TextStyle(fontFamily: 'Outfit'),
          ),
        );
      },
    ),
  );
}

Container balance(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wallet Balance",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 10),

        /// BlocBuilder to show dynamic balance
        BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            String balanceText = "₦0.00";

            if (state is WalletBalanceLoadingState) {
              balanceText = "Loading...";
            } else if (state is WalletBalanceSuccessState) {
              balanceText = "₦${state.balance.balance}";
            } else if (state is WalletBalanceErrorState) {
              balanceText = "Error loading balance";
            }

            return Text(
              balanceText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Buttons
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(MyAppRouteConstant.addfunds);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "+ Add Funds",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(MyAppRouteConstant.requestpayout);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Request Payout",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
