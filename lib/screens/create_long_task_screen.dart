import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/task_provider.dart';
import 'package:task_mvp/utils/utils.dart';

import '../provider/employee_provider.dart';
import 'employee_task_screen.dart';

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

  final List<File?> _selectedImages = [null, null, null];
  final List<bool> _isUploading = [false, false, false];
  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final freeMembers = Provider.of<EmployeeProvider>(context).freeMembers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Long Task"),
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
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Attachments Section
              const Text(
                "Attachments (Max 3)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Formats: PDF, JPEG, PNG (Max: 5MB each)",
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
                          width: _isUploading[index] ? 3 : 1,
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

              // Task Title
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title,
                      color: Theme.of(context).primaryColor),
                  hintText: "Enter Task Title",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Task Description
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

              // Member Selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,
                      color: Theme.of(context).primaryColor),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hint: const Text("Select Member"),
                value: selectedMember,
                onChanged: (value) => setState(() => selectedMember = value),
                items: freeMembers
                    .map((employee) => DropdownMenuItem(
                          value: employee.id,
                          child: Text(
                              '${employee.firstName} ${employee.lastName}'),
                        ))
                    .toList(),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Priority Selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.priority_high,
                      color: Theme.of(context).primaryColor),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hint: const Text("Select Priority"),
                value: selectedPriority,
                onChanged: (value) => setState(() => selectedPriority = value),
                items: priorities
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Create Task Button
              ElevatedButton(
                onPressed: () async {
                  if (selectedMember == null || selectedPriority == null) {
                    showSnackBar(context, "Please complete all fields.");
                    return;
                  }

                  try {
                    final taskProvider =
                        Provider.of<TaskProvider>(context, listen: false);
                    final encodedAttachments =
                        encodeImagesToBase64(_selectedImages);

                    await taskProvider.createTask(
                      titleController.text,
                      descController.text,
                      "long",
                      selectedMember!,
                      selectedPriority!,
                      encodedAttachments: encodedAttachments,
                    );

                    showSnackBar(context, "Task created successfully!");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TaskListScreen(),
                      ),
                    );
                  } catch (e) {
                    showSnackBar(context, "Error: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Create Task",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
