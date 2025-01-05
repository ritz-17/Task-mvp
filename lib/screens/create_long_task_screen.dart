import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mvp/provider/task_provider.dart';
import 'package:task_mvp/utils/utils.dart';

import '../provider/employee_provider.dart';

class CreateLongTask extends StatefulWidget {
  const CreateLongTask({super.key});

  @override
  State<CreateLongTask> createState() => _CreateLongTaskState();
}

class _CreateLongTaskState extends State<CreateLongTask> {
  String? selectedMember;
  String? selectedPriority;
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider =
          Provider.of<EmployeeProvider>(context, listen: false);
      employeeProvider.loadEmployees();
    });
  }

  final List<File?> _selectedImages = [null, null, null];
  final List<bool> _isUploading = [false, false, false];
  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Filter lists based on status
    final freeMembers = Provider.of<EmployeeProvider>(context).freeMembers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Task"),
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
              const Text(
                "Attachments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                "Format should be in .pdf, .jpeg, .png less than 5MB",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => InkWell(
                    onTap: () => pickImage(
                      context: context,
                      index: index,
                      selectedImages: _selectedImages,
                      isUploading: _isUploading,
                      updateState: setState,
                    ),
                    child: Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: _isUploading[index]
                              ? 3
                              : 1, // Thicker border during upload
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedImages[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImages[index]!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : _isUploading[index]
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: screenWidth * 0.08,
                                ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Task Title Input
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.title, color: Theme.of(context).primaryColor),
                  hintText: "Enter Task Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Task Description Input
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

              // Assign To Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
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
              SizedBox(height: screenHeight * 0.02),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.priority_high,
                      color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hint: const Text("Select Priority"),
                value: selectedPriority,
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
                items: priorities
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Create Task Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
                                // Outline border
                                color: Theme.of(context).primaryColor,
                                width: 2, // Border width
                              ),
                            ),
                            child: Text(
                              "No, Recheck",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor, // Text color matches border
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              try {
                                final taskProvider = Provider.of<TaskProvider>(
                                    context,
                                    listen: false);
                                await taskProvider.createTask(
                                    titleController.text,
                                    descController.text,
                                    "long",
                                    selectedMember!,
                                    prefs.get('userId').toString());
                                showSnackBar(
                                    context, 'Task created successfully');
                                Navigator.pushReplacementNamed(
                                    context, '/employeeTasks');
                                print('task created');
                              } catch (e) {
                                print(e);
                                showSnackBar(
                                    context, "Error creating task: $e");
                              }
                              Navigator.pop(context);
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
