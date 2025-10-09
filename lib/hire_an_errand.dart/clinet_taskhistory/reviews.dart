import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart' as av;
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_container.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';
import 'package:pikquick/features/transaction/data/model/client_review.dart';
import 'package:pikquick/features/transaction/presentation/transaction_bloc.dart';
import 'package:pikquick/features/transaction/presentation/transaction_event.dart';
import 'package:pikquick/features/transaction/presentation/transaction_state.dart';
import 'package:pikquick/router/router_config.dart';

class Reviews extends StatefulWidget {
  final GetTaskOverviewEntity review;
  const Reviews({
    super.key,
    required this.review,
  });

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0; // ⭐ keep track of selected rating

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating")),
      );
      return;
    }

    final review = ClientReviewModel(
      runnerId: widget.review.runnerId ?? '',
      clientId: widget.review.clientId ?? '',
      taskId: widget.review.id ?? '',
      rating: _selectedRating.toInt(),
      review: _reviewController.text.isEmpty ? null : _reviewController.text,
    );

    context.read<TransactionBloc>().add(ClientReviewEvent(makeReview: review));
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 295,
            height: 250,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/welcome.png', width: 60, height: 40),
                const SizedBox(height: 20),
                const Text(
                  'Review added',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Thank you! Your review helps\n the community',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Outfit',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                FancyContainer(
                  color: const Color(0XFF98A2B3),
                  onTap: () => context.go(MyAppRouteConstant.dashboard),
                  borderRadius: BorderRadius.circular(10),
                  height: 50,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Done',
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

  Widget _buildReviewInput() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _reviewController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          hintText: "Share your thoughts about this task\n(optional)",
          border: InputBorder.none,
          isCollapsed: true,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _selectedRating = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
          child: BlocConsumer<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is ClientReviewSuccessState) {
                _showReviewDialog();
              } else if (state is ClientReviewErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      onPressed: () => context.go(MyAppRouteConstant.dashboard),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Add review & rating',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: (userModelG?.imageUrl != null)
                              ? NetworkImage(userModelG!.imageUrl!)
                              : AssetImage('assets/images/circle.png'),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${av.userModelG?.fullName ?? ''}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(Icons.verified,
                                    color: Colors.green, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text(
                          "Task Completed",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Pick Up and Deliver a Package",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "How was your experience?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStarRating(),
                    const SizedBox(height: 12),
                    _buildReviewInput(),
                    const SizedBox(height: 40),
                    Center(
                      child: FancyContainer(
                        color: const Color(0XFF98A2B3),
                        onTap: state is ClientReviewInitalLoadingState
                            ? null
                            : _submitReview,
                        borderRadius: BorderRadius.circular(10),
                        height: 50,
                        width: 342,
                        child: Center(
                          child: state is ClientReviewInitalLoadingState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Submit review',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
