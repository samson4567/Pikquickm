// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_constants.dart';
import 'package:pikquick/component/button_nav.dart';

class MainPage2 extends StatefulWidget {
  const MainPage2(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;
  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  bool checkIfCurrentIndexIsTheSameAsItem(int index) {
    return (widget.navigationShell.currentIndex == index);
  }

  int? previousIndex;
  // List<TabItem> items = [];
  void onTap(index) {
    try {} catch (e) {}

    toPop = true;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    if (index == 1) {}

    previousIndex = index;
    toPop = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: widget.navigationShell,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                color: Colors.white, child: _buildBottomNavigationBar()),
          ),
        ),
      ]),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavBar(
      selectedIndex: widget.navigationShell.currentIndex,
      onItemTapped: onTap,
    );
  }
}
