import 'package:flutter/material.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final List<Map<String, dynamic>> allMembers = [
    {"name": "Chad", "image": "https://i.pravatar.cc/150?img=1", "status": "active"},
    {"name": "Matt", "image": "https://i.pravatar.cc/150?img=2", "status": "active"},
    {"name": "Julie", "image": "https://i.pravatar.cc/150?img=3", "status": "active"},
    {"name": "Chad", "image": "https://i.pravatar.cc/150?img=1", "status": "active"},
    {"name": "Matt", "image": "https://i.pravatar.cc/150?img=2", "status": "active"},
    {"name": "Julie", "image": "https://i.pravatar.cc/150?img=3", "status": "active"},
    {"name": "Yuri", "image": "https://i.pravatar.cc/150?img=4", "status": "free"},
    {"name": "Chad", "image": "https://i.pravatar.cc/150?img=5", "status": "free"},
    {"name": "Matt", "image": "https://i.pravatar.cc/150?img=6", "status": "unavailable"},
    {"name": "Julie", "image": "https://i.pravatar.cc/150?img=7", "status": "unavailable"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Filter lists based on status
    final activeMembers = allMembers.where((member) => member['status'] == 'active').toList();
    final freeMembers = allMembers.where((member) => member['status'] == 'free').toList();
    final unavailableMembers = allMembers.where((member) => member['status'] == 'unavailable').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("Active Members", activeMembers, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.02),
            _buildSection("Free", freeMembers, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.02),
            _buildSection("Unavailable", unavailableMembers, screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title,
      List<Map<String, dynamic>> members,
      double screenWidth,
      double screenHeight,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: screenWidth * 0.95, // Stretching card width
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Wrap(
                spacing: screenWidth * 0.04,
                runSpacing: screenHeight * 0.02,
                children: members.map((member) => _buildMemberCard(member, screenHeight)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member, double screenHeight) {
    Color statusColor;
    switch (member["status"]) {
      case "active":
        statusColor = Colors.green;
        break;
      case "free":
        statusColor = Colors.yellow;
        break;
      case "unavailable":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: screenHeight * 0.04,
              backgroundImage: NetworkImage(member["image"]),
            ),
            CircleAvatar(
              radius: screenHeight * 0.012,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: screenHeight * 0.01,
                backgroundColor: statusColor,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.005),
        Text(
          member["name"],
          style: TextStyle(fontSize: screenHeight * 0.018),
        ),
      ],
    );
  }
}
