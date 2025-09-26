import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/router/router_config.dart';

class HireRunnerPage extends StatefulWidget {
  const HireRunnerPage({super.key});

  @override
  State<HireRunnerPage> createState() => _HireRunnerPageState();
}

class _HireRunnerPageState extends State<HireRunnerPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    context.go(
      MyAppRouteConstant.tasklocation,
      extra: {
        'taskType': _titleController.text.trim(),
        'additionalNote': _descriptionController.text.trim(),
        'specialInstructions': _instructionController.text.trim(),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    taskModelbeingCreated?.clientId = userModelG?.id;
    taskModelbeingCreated?.categoryId = "455a8eed-729e-11f0-8703-00163cbf7aa3";

    // 455a8eed-729e-11f0-8703-00163cbf7aa3
    _titleController.addListener(
      () {
        taskModelbeingCreated?.name = _titleController.text;
        taskModelbeingCreated?.taskType = _titleController.text;
      },
    );
    _descriptionController.addListener(
      () {
        taskModelbeingCreated?.description = _descriptionController.text;
      },
    );
    _instructionController.addListener(
      () {
        taskModelbeingCreated?.specialInstructions =
            _instructionController.text;
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required double width,
    required double height,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = screenWidth - 32; // 16px padding on both sides

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                const Text(
                  "Tell us about your task",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 24),
                _buildInputField(
                  label: "Task Title",
                  hint: "E.g deliver document to Ikeja",
                  controller: _titleController,
                  width: fieldWidth,
                  height: 50,
                ),
                _buildInputField(
                  label: "Description",
                  hint: "Provide additional details",
                  controller: _descriptionController,
                  width: fieldWidth,
                  height: 150,
                  maxLines: 5,
                ),
                _buildInputField(
                  label: "Special Instruction",
                  hint: "Provide any special instruction",
                  controller: _instructionController,
                  width: fieldWidth,
                  height: 150,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        GestureDetector(
          onTap: _navigateToNextPage,
          child: const Text(
            "Next",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
