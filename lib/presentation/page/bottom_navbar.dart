import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:surya_mart_v1/presentation/page/home_page.dart';
import 'package:surya_mart_v1/presentation/page/catalogue_page.dart';
import 'package:surya_mart_v1/presentation/page/profile_page.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  const BottomNavbar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int? _selectedIndex;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CataloguePage(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions[_selectedIndex!],
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        tabMargin: const EdgeInsets.only(bottom: 16, top: 16),
        tabActiveBorder: Border.all(color: Colors.black),
        gap: 6,
        tabBorderRadius: 40,
        tabs: [
          GButton(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            icon: Icons.home_outlined,
            iconColor: Colors.grey.shade500,
            text: 'Home',
          ),
          GButton(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            icon: Icons.space_dashboard_outlined,
            iconColor: Colors.grey.shade500,
            text: 'Catalogue',
          ),
          GButton(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            icon: Icons.person_outline,
            iconColor: Colors.grey.shade500,
            text: 'Profile',
          ),
        ],
        selectedIndex: _selectedIndex!,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
