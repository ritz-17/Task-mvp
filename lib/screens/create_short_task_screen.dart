import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mvp/provider/task_provider.dart';
import '../provider/employee_provider.dart';
import '../utils/utils.dart';

class CreateShortTask extends StatefulWidget {
  const CreateShortTask({super.key});

  @override
  State<CreateShortTask> createState() => _CreateShortTaskState();
}

class _CreateShortTaskState extends State<CreateShortTask> {
  String? selectedMember;
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState(); // Retrieve manager's ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider =
          Provider.of<EmployeeProvider>(context, listen: false);
      employeeProvider.loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final freeMembers = Provider.of<EmployeeProvider>(context).freeMembers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Short Task"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // -------------------------- Task Title Input ------------------------
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.title, color: Theme.of(context).primaryColor),
                  hintText: "Enter Task Title",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // ------------------------ Task Description Input ----------------------
              TextField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Enter Task Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // ------------------------- Assign To Dropdown ------------------------
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hint: const Text("Select Member"),
                value: selectedMember,
                onChanged: (value) {
                  setState(() {
                    selectedMember = value;
                  });
                },
                items: freeMembers
                    .map((employee) => DropdownMenuItem(
                          value: employee.id,
                          child: Text(
                              '${employee.firstName} ${employee.lastName}'),
                        ))
                    .toList(),
              ),

              SizedBox(height: screenHeight * 0.03),

              // -------------------------- Create Task Button -------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedMember == null) {
                      showSnackBar(context, "Please select a member.");
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Task Creation"),
                        content: const Text(
                          "Are you sure you want to create this task? You can recheck the details before confirming.",
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              "No, Recheck",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                final taskProvider = Provider.of<TaskProvider>(
                                    context,
                                    listen: false);
                                await taskProvider.createTask(
                                  titleController.text,
                                  descController.text,
                                  "short",
                                  selectedMember!
                                );

                                // Show success message
                                showSnackBar(
                                    context, 'Task created successfully');
                                Navigator.pushReplacementNamed(
                                    context, '/employeeTasks');
                              } catch (e) {
                                showSnackBar(
                                    context, "Error creating task: $e");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: const Text(
                              "Confirm",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  ),
                  child: const Text(
                    "Create Task",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
