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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 122, 90, 248),
              // color: Color.fromRGBO(122, 90, 248, 100),
              borderRadius: BorderRadius.circular(30),
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home, color: Colors.white),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  activeIcon: Icon(Icons.article, color: Colors.white),
                  label: 'Task',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  activeIcon: Icon(Icons.person, color: Colors.white),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              elevation: 0,
              selectedItemColor: Color.fromARGB(255, 249, 250, 251),
              unselectedItemColor: Color.fromARGB(200, 241, 243, 248),
              showSelectedLabels: true,
              showUnselectedLabels: false,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
