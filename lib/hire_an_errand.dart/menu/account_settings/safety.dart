import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topGridItems = [
    {
      'title': 'Support',
      'iconPath': 'assets/icons/auth.png',
      'backgroundColor': const Color(0xFFF0F2F5),
      'textColor': Colors.black,
    },
    {
      'title': 'Call Emergency',
      'iconPath': 'assets/icons/auth.png',
      'backgroundColor': Colors.red,
      'textColor': Colors.white,
    },
  ];

  final List<String> textGridItems = [
    'Limit personal information',
    'Vet runner',
    'Task specific without details',
    'Communicate via app',
    'Review runner',
    'Set boundaries',
    'Payment safety',
    'Report suspicious activity',
  ];

  SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support and Call Emergency
              Row(
                children: topGridItems.map((item) {
                  return Expanded(
                    child: Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: item['backgroundColor'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['iconPath'],
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: item['textColor'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Paragraph text
              const Text(
                'How you are protected by following these privacy, security, and safety tips.\nYou can have a positive experience while using PikQuick.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: textGridItems.map((text) {
                  return Container(
                    width: 190,
                    height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
