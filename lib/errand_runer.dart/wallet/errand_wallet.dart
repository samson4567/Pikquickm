import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
    context.read<TransactionBloc>().add(
          const TransactionHistoryEvent(limit: '10', page: '1'),
        );

    final walletModel = WalletBalanceModel(balance: 0.0);
    context
        .read<WalletBloc>()
        .add(WalletBalanceEvent(walletBalance: walletModel));

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

  void _showCustomDialog({required String title, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 342,
            height: 190,
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close,
                        size: 20, color: Colors.black54),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Outfit")),
                    const SizedBox(height: 12),
                    Text(message,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: "Outfit")),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          minimumSize: const Size(120, 40),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Dashboard",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Outfit",
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⬅️ Back and Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Wallet Balance",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 💳 Wallet Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0XFFF2F2F2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Wallet Balance",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(height: 10),
                    BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        String balanceText = "₦0.00";
                        if (state is WalletBalanceLoadingState) {
                          balanceText = "Loading...";
                        } else if (state is WalletBalanceSuccessState) {
                          balanceText = "₦${state.balance.balance}";
                        } else if (state is WalletBalanceErrorState) {
                          balanceText = "Error";
                        }
                        return Text(balanceText,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Outfit",
                              color: Colors.black,
                            ));
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                context.go(MyAppRouteConstant.addfunds),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A85E4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: const Text("Add Money",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                context.go(MyAppRouteConstant.requestpayout),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A85E4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: const Text("Request Payout",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 🔄 Auto Deduction Toggle
              BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is SubscribeAutoDeductionSuccess) {
                    setState(() => isAutoDeductionEnabled = true);
                    _showCustomDialog(
                        title: "Availability Fee Deducted",
                        message:
                            "Your wallet has been deducted ₦100 for daily availability. This keeps you active for 24 hours.");
                  } else if (state is UnsubscribeAutoDeductionSuccess) {
                    setState(() => isAutoDeductionEnabled = false);
                    _showCustomDialog(
                        title: "Auto-Deduction Disabled",
                        message: "You have unsubscribed from auto-deduction.");
                  } else if (state is SubscribeAutoDeductionError ||
                      state is UnsubscribeAutoDeductionError) {
                    final msg = state is SubscribeAutoDeductionError
                        ? state.errorMessage
                        : (state as UnsubscribeAutoDeductionError).errorMessage;
                    _showCustomDialog(title: "Error", message: msg);
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
                            Text("Auto-Deduction",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text(
                                "Enable daily deduction of ₦100 availability fee",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0XFF434953))),
                          ],
                        ),
                      ),
                      isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Switch(
                              value: isAutoDeductionEnabled,
                              activeColor: const Color(0xFF3A75FF),
                              onChanged: (value) {
                                if (value) {
                                  context.read<ProfileBloc>().add(
                                        ToggleSubscribeAutoDeductionEvent(
                                          model: SubscribeAutoDeductionModel(
                                              subscribe: true),
                                        ),
                                      );
                                } else {
                                  context.read<ProfileBloc>().add(
                                        UnsubscribeAutoDeductionEvent(
                                          model: UnsubscribeAutoDeductionModel(
                                              unsubscribe: false),
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

              // 📊 Earning Summary
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is WalletSummaryLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WalletSummaryErrorState) {
                    return Text(state.errorMessage,
                        style: const TextStyle(color: Colors.red));
                  } else if (state is WalletSummarySuccessState) {
                    final s = state.walletSummary;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0XFFF0F2F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Earning Summary",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit')),
                          const SizedBox(height: 16),
                          _summaryRow(
                              "Pending Payments", "₦${s.pendingPayments ?? 0}"),
                          const SizedBox(height: 8),
                          _summaryRow("Withdrawable Balance",
                              "₦${s.withdrawableBalance ?? 0}"),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          _summaryRow("Total Earnings (All-Time)",
                              "₦${s.totalEarningsAllTime ?? 0}"),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 25),

              // 🧾 Transaction History
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Transaction History",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Outfit')),
                  TextButton(
                    onPressed: () =>
                        context.push(MyAppRouteConstant.addpayment),
                    child: const Text("See All",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3A75FF),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Outfit')),
                  )
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(height: 400, child: transactionList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontFamily: 'Outfit')),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit')),
      ],
    );
  }
}

// Transaction List Widget (Unchanged logic, modernized style)
Expanded transactionList() {
  return Expanded(
    child: BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionHistoryLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionHistoryErrorState) {
          return Center(
              child: Text(state.errorMessage,
                  style: const TextStyle(color: Colors.red)));
        } else if (state is TransactionHistorySuccessState) {
          final transactions = state.transactionHistory;
          if (transactions.isEmpty) {
            return Center(child: Image.asset('assets/images/tract.png'));
          }
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 25),
            itemBuilder: (context, i) {
              final t = transactions[i];
              return Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/vic.svg', // <-- SVG file path
                        width: 32.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t.type ?? "Transaction",
                                style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            Text("₦${t.amount ?? '0'}",
                                style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t.status ?? "11:20 PM Today",
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  color: Color(0xFF434953),
                                )),
                            Text(
                              (t.createdAt ?? '11:20 PM Today').toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF434953),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            )
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
            child: Text("No transaction data",
                style: TextStyle(fontFamily: 'Outfit')));
      },
    ),
  );
}
