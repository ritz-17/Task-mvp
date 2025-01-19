import 'package:flutter/material.dart';
import 'package:task_mvp/screens/employee_task_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/employeeList_screen.dart';
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
    EmployeeScreen(),
    TaskListScreen(),
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
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                activeIcon:
                    Icon(Icons.home, color: Theme.of(context).primaryColor),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                activeIcon: Icon(Icons.people_alt_rounded,
                    color: Theme.of(context).primaryColor),
                label: 'Employees',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                activeIcon:
                    Icon(Icons.article, color: Theme.of(context).primaryColor),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                activeIcon:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            elevation: 0,
            selectedItemColor: Theme.of(context).primaryColor,
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
