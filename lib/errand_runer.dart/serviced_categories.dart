import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/task/data/model/specialize_model.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/features/task/presentation/task_state.dart';

class SavedCategoriesScreen extends StatefulWidget {
  const SavedCategoriesScreen({super.key});

  @override
  State<SavedCategoriesScreen> createState() => _SavedCategoriesScreenState();
}

class _SavedCategoriesScreenState extends State<SavedCategoriesScreen> {
  final List<CategoryItem> categories = [
    CategoryItem(
      title: 'Pickup & Delivery',
      description: 'Get all items picked for client',
      imagePath: 'assets/images/product3.png',
    ),
    CategoryItem(
      title: 'Queue & Standing',
      description: 'Stand in line for a client at banks or offices',
      imagePath: 'assets/images/product4.png',
    ),
    CategoryItem(
      title: 'Document & Dispatch',
      description: 'Deliver important papers to specific locations',
      imagePath: 'assets/images/product3.png',
    ),
  ];

  final Set<String> selectedTitles = {};

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is SavedcategoriesSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Specialization updated successfully!')),
          );
        } else if (state is SavedcategoriesErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Saved Categories')),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (state is SavedcategoriesLoadingState)
                  const LinearProgressIndicator(),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      final isSelected = selectedTitles.contains(item.title);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedTitles.remove(item.title);
                            } else {
                              selectedTitles.add(item.title);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4378CD).withOpacity(0.2)
                                : const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4378CD)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item.imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? const Color(0xFF4378CD)
                                    : Colors.grey,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    if (selectedTitles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please select at least one category')),
                      );
                      return;
                    }

                    final model = SavedCategoriesModel(
                      specializedTasks: selectedTitles.toList(),
                    );

                    context.read<TaskBloc>().add(
                          SavedCategoriesEvent(saveModel: model),
                        );
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4378CD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                          color: Colors.white,
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
    );
  }
}

class CategoryItem {
  final String title;
  final String description;
  final String imagePath;

  CategoryItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
