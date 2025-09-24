import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final List<Map<String, dynamic>> navItems = const [
    {
      'icon': 'assets/icons/home.png',
      'label': 'Home',
    },
    {'icon': 'assets/icons/transact.png', 'label': 'Task'},
    {'icon': 'assets/icons/wallet.png', 'label': 'Wallet'},
    {'icon': 'assets/icons/More.png', 'label': 'More'},
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: navItems.map((item) {
        int index = navItems.indexOf(item);
        return BottomNavigationBarItem(
          icon: Image.asset(
            item['icon']!,
            width: 24,
            height: 24,
            color: selectedIndex == index ? Colors.blue : Colors.grey,
          ),
          label: item['label'],
        );
      }).toList(),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
    );
  }
}
