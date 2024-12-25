import 'package:flutter/material.dart';
import 'package:task_mvp/screens/task_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    TaskScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: PhysicalModel(
        color: Colors.transparent,
        elevation: 8,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 249, 250, 251),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home, color: Color.fromARGB(255, 122, 90, 248)),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                activeIcon: Icon(Icons.article, color: Color.fromARGB(255, 122, 90, 248)),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                activeIcon: Icon(Icons.person, color: Color.fromARGB(255, 122, 90, 248)),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            elevation: 0,
            selectedItemColor: const Color.fromARGB(255, 122, 90, 248),
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
