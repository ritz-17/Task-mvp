import 'package:flutter/material.dart';

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
                  // Top Header Section
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
    );
  }

  Widget buildTeamSection(
    BuildContext context, {
    required double screenWidth,
    required String title,
    required int activeCount,
    required int freeCount,
    required int unavailableCount,
    required List<TaskData> tasks,
  }) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Row(
            children: [
              buildStatusChip('Active', activeCount, Colors.blue, screenWidth),
              SizedBox(width: screenWidth * 0.02),
              buildStatusChip('Free', freeCount, Colors.green, screenWidth),
              SizedBox(width: screenWidth * 0.02),
              buildStatusChip(
                  'Unavailable', unavailableCount, Colors.red, screenWidth),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenWidth * 0.03),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return buildTaskCard(context, task, screenWidth);
            },
          ),
        ],
      ),
    );
  }

  Widget buildStatusChip(
      String label, int count, Color color, double screenWidth) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label: Text(
        '$count $label',
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  Widget buildTaskCard(
      BuildContext context, TaskData task, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenWidth * 0.01),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.045,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/2815/2815428.png'),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                Text(
                  '${task.personName} • ${task.personRole}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                task.time,
                style: TextStyle(
                    fontSize: screenWidth * 0.035, color: Colors.grey),
              ),
              SizedBox(height: screenWidth * 0.01),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  color: task.statusColor,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Text(
                  task.status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaskData {
  final String title;
  final String personName;
  final String personRole;
  final String status;
  final Color statusColor;
  final String time;

  TaskData({
    required this.title,
    required this.personName,
    required this.personRole,
    required this.status,
    required this.statusColor,
    required this.time,
  });
}
