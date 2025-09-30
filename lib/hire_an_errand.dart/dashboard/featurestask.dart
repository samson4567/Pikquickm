import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/domain/entities/task_categores_entity.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/router/router_config.dart';

class FeatureTaskCategories extends StatefulWidget {
  const FeatureTaskCategories({super.key});

  @override
  State<FeatureTaskCategories> createState() => _FeatureTaskCategoriesState();
}

class _FeatureTaskCategoriesState extends State<FeatureTaskCategories>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Dispatch Bloc Event
    context
        .read<AuthBloc>()
        .add(const TaskCategoryEvent(categoryModel: CustomCategoryTaskModel()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGridItemTap(CustomCategoryTaskEntity category) {
    // av.
    taskModelbeingCreated = TaskModel(
        categoryId: category.id,
        taskType: category.name,
        description: category.description,
        name: category.name,
        clientId: userModelG?.id);
    context.push(MyAppRouteConstant.deliveryScreen);

    // context.pushNamed(MyAppRouteConstant.deliveryScreen, extra: category);
  }

  Widget _buildCategoryCard(CustomCategoryTaskEntity category, int index) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(
          parent: _controller, curve: Interval(0.1 * index, 1.0))),
      child: FadeTransition(
        opacity: _animation,
        child: GestureDetector(
          onTap: () => _onGridItemTap(category),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            shadowColor: Colors.black26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: category.id ?? 'category_$index',
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: category.categoryImage != null &&
                            category.categoryImage!.isNotEmpty
                        ? Image.network(
                            category.categoryImage!,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 120,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF434953),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double crossAxisCount =
        MediaQuery.of(context).size.width < 600 ? 2 : 4; // Responsive

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Services",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.goNamed(MyAppRouteConstant.dashboard),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What do you need help with?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for a service...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is TaskCategoryErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is TaskCategoryLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskCategorySuccessState) {
                      final categories = state.categories;
                      if (categories.isEmpty) {
                        return const Center(
                          child: Text("No categories found"),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount.toInt(),
                          childAspectRatio: 165 / 210,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryCard(categories[index], index);
                        },
                      );
                    } else if (state is TaskCategoryErrorState) {
                      return Center(
                          child: Text(
                        state.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
