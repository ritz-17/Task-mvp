import 'package:flutter/material.dart';

import '../utils/utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    final double paddingLarge = screenWidth * 0.05;
    final double paddingMedium = screenWidth * 0.03;
    final double paddingSmall = screenWidth * 0.02;

    final double headerFontSize = screenWidth * 0.05;
    final double subheaderFontSize = screenWidth * 0.035;

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
                  //-------------------- Header Section ------------------------
                  _buildHeader(
                    context,
                    headerFontSize: headerFontSize,
                    subheaderFontSize: subheaderFontSize,
                    padding: paddingLarge,
                    avatarRadius: screenWidth * 0.06,
                    iconSize: screenWidth * 0.06,
                  ),
                  //--------------------- Summary Card -------------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingMedium),
                    child: _buildSummaryCard(
                      context,
                      titleSize: headerFontSize * 0.8,
                      subtitleSize: subheaderFontSize,
                      imageSize: screenWidth * 0.2,
                      padding: paddingMedium,
                    ),
                  ),
                  //---------------------- Team Section ------------------------
                  Padding(
                    padding: EdgeInsets.all(paddingSmall),
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
                  ),
                  //----------------------- Create Task Card ----------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingMedium),
                    child: Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 122, 90, 248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(paddingMedium),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: paddingLarge,
                            ),
                            //----------------- Add New Task -------------------
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //----------------- Add Task Image------------------
                                  Image.asset(
                                    'assets/add_task.png', // Replace with your actual image path
                                    width: screenWidth * 0.15,
                                    height: screenWidth * 0.15,
                                  ),
                                  SizedBox(width: paddingSmall),
                                  Text(
                                    "Add New Task",
                                    style: TextStyle(
                                      fontSize: headerFontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/createTask");
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenWidth * 0.12,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: screenWidth * 0.09,
                                      color: const Color.fromARGB(
                                          255, 122, 90, 248),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------- Header Build Method ----------------------------
  Widget _buildHeader(
    BuildContext context, {
    required double headerFontSize,
    required double subheaderFontSize,
    required double padding,
    required double avatarRadius,
    required double iconSize,
  }) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //-------------------- Profile and Info ------------------------------
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/2815/2815428.png',
                  ),
                ),
                SizedBox(width: padding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Aditya',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            'Manager',
                            style: TextStyle(
                              fontSize: subheaderFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: padding * 0.3),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: subheaderFontSize * 1.2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //-------------------- Notification and Settings Icons ---------------
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
                iconSize: iconSize,
                padding: EdgeInsets.all(padding * 0.3),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
                iconSize: iconSize,
                padding: EdgeInsets.all(padding * 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //------------------------ Summary Card Build Method -------------------------
  Widget _buildSummaryCard(
    BuildContext context, {
    required double titleSize,
    required double subtitleSize,
    required double imageSize,
    required double padding,
  }) {
    return Card(
      color: const Color(0xFF795FFC),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //------------------------- Summary Text ---------------------------
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Work Summary",
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: padding * 0.5),
                  Text(
                    "Today task & presence activity",
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
            //------------------------ Summary Image ---------------------------
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/camera.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}