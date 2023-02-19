import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:surya_mart_v1/presentation/page/home_page.dart';
import 'package:surya_mart_v1/presentation/page/notification_page.dart';
import 'package:surya_mart_v1/presentation/page/catalogue_page.dart';
import 'package:surya_mart_v1/presentation/page/profile_page.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CataloguePage(),
    const NotificationPage(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: GNav(
        tabMargin: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 20),
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
            icon: Icons.notifications_none_outlined,
            iconColor: Colors.grey.shade500,
            text: 'Notifications',
          ),
          GButton(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            icon: Icons.person_outline,
            iconColor: Colors.grey.shade500,
            text: 'Profile',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
