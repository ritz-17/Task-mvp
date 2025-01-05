import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/models/employee_model.dart';
import 'package:task_mvp/provider/employee_provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      employeeProvider.loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    final employees = employeeProvider.employees;

    // Filter lists based on status
    final activeMembers = employees.where((member) => member.status == 'active').toList();
    final freeMembers = employees.where((member) => member.status == 'free').toList();
    final unavailableMembers =
    employees.where((member) => member.status == 'unavailable').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        centerTitle: true,
      ),
      body: employeeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
      List<Employee> members,
      double screenWidth,
      double screenHeight,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: screenWidth * 0.95,
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Wrap(
                spacing: screenWidth * 0.04,
                runSpacing: screenHeight * 0.02,
                children: members
                    .map((member) => _buildMemberCard(member, screenHeight))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(Employee member, double screenHeight) {
    Color statusColor;
    switch (member.status) {
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
              backgroundColor: Colors.blueAccent, // Placeholder color
              child: Icon(
                Icons.person,
                size: screenHeight * 0.04,
                color: Colors.white,
              ), // Placeholder icon
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
          member.firstName,
          style: TextStyle(fontSize: screenHeight * 0.018),
        ),
      ],
    );
  }
}
