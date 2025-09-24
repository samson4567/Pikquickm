import 'package:flutter/material.dart';
import 'package:pikquick/component/button_nav.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/dashboard.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/more.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/featurestask.dart';
import 'package:pikquick/hire_an_errand.dart/wallet/wallet.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _indexSelection = 0;
  final List<Widget> _pages = [
    const DashboardPage(
      taskId: '',
      bidId: '',
    ),
    const FeatureTaskCategories(),
    const Wallet(),
    const AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: IndexedStack(
        index: _indexSelection,
        children: _pages,
      )),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavBar(
        selectedIndex: _indexSelection,
        onItemTapped: (index) {
          setState(() {
            _indexSelection = index;
          });
        });
  }
}
