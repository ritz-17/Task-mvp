import 'package:flutter/material.dart';
import 'package:task_mvp/screens/new_task_screen.dart';

import '../utils/utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: screenWidth * 0.06,
                                  backgroundImage: NetworkImage(
                                      'https://cdn-icons-png.flaticon.com/512/2815/2815428.png'),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello Aditya',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Manager',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: screenWidth * 0.04,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.notifications_outlined),
                              onPressed: () {},
                              iconSize: screenWidth * 0.06,
                            ),
                            IconButton(
                              icon: Icon(Icons.settings_outlined),
                              onPressed: () {},
                              iconSize: screenWidth * 0.06,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Marketing & Sales Section
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Card(
                      elevation: 10,
                      child: buildTeamSection(
                        context,
                        screenWidth: screenWidth,
                        title: 'Marketing & Sales',
                        activeCount: 1,
                        freeCount: 2,
                        unavailableCount: 1,
                        tasks: [
                          TaskData(
                            title: 'Brochure Creation',
                            personName: 'Saumya Singh',
                            personRole: 'Graphic Designer',
                            status: 'Not Started',
                            statusColor: Colors.red,
                            time: '45:39',
                          ),
                          TaskData(
                            title: 'New Year Campaign',
                            personName: 'Aditya Singhal',
                            personRole: 'Graphic Designer',
                            status: 'In Progress',
                            statusColor: Colors.orange,
                            time: '01:45:39',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTask(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
