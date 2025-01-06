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
    // ---------------------------------- Load Employees ------------------------------------
    // Load employee data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider =
          Provider.of<EmployeeProvider>(context, listen: false);
      employeeProvider.loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ----------------------------------- Screen Dimensions --------------------------------
    // Get the dimensions of the screen for responsive UI
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ----------------------------------- Employee Provider --------------------------------
    // Access the EmployeeProvider for data
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    // ----------------------------------- Filtered Employees -------------------------------
    // Categorize employees based on their status
    final employees = employeeProvider.employees;
    final activeMembers =
        employees.where((member) => member.status == 'active').toList();
    final freeMembers =
        employees.where((member) => member.status == 'free').toList();
    final unavailableMembers =
        employees.where((member) => member.status == 'unavailable').toList();

    // --------------------------------------- UI Layout ------------------------------------
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: employeeProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------- Active Members Section ----------------------
                  _buildSection("Active Members", activeMembers, screenWidth,
                      screenHeight),
                  SizedBox(height: screenHeight * 0.03),

                  // ------------------------ Free Members Section ----------------------
                  _buildSection("Free", freeMembers, screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.03),

                  // -------------------- Unavailable Members Section -------------------
                  _buildSection("Unavailable", unavailableMembers, screenWidth,
                      screenHeight),
                ],
              ),
            ),
    );
  }

  // ------------------------------------ Section Builder ------------------------------------
  // Builds each section of employees (Active, Free, Unavailable)
  Widget _buildSection(
    String title,
    List<Employee> members,
    double screenWidth,
    double screenHeight,
  ) {
    return Center(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(screenHeight * 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.015),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content here
            children: [
              // --------------------------- Section Title ---------------------------
              Text(
                title,
                style: TextStyle(
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // ---------------------- Employee Cards in Wrap -----------------------
              Wrap(
                alignment:
                    WrapAlignment.center, // Center the items inside the Wrap
                spacing: screenWidth * 0.04,
                runSpacing: screenHeight * 0.02,
                children: members
                    .map((member) =>
                        _buildMemberCard(member, screenWidth, screenHeight))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(
      Employee member, double screenWidth, double screenHeight) {
    // ----------------------- Determine Status Color ---------------------------
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

    // -------------------------- Member Card Layout ---------------------------
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      crossAxisAlignment:
          CrossAxisAlignment.center, // Center content horizontally
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // ----------------------- Placeholder Avatar -------------------------
            CircleAvatar(
              radius: screenHeight * 0.04,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: screenHeight * 0.04,
                color: Colors.white,
              ),
            ),
            // ------------------------ Status Indicator --------------------------
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
        // ------------------------- Employee Name ------------------------------
        Text(
          member.firstName,
          style: TextStyle(fontSize: screenHeight * 0.018),
        ),
      ],
    );
  }
}
