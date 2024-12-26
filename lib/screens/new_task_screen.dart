import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_mvp/screens/task_screen.dart';
import 'package:task_mvp/utils/utils.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String? selectedMember;
  String? selectedPriority;
  String? selectedDifficulty;

  final List<File?> _selectedImages = [null, null, null];
  final List<bool> _isUploading = [false, false, false];

  final List<String> members = ['Aditya', 'Mayur', 'Vanshika'];
  final List<String> priorities = ['High', 'Medium', 'Low'];
  final List<String> difficulties = [
    'Very Easy(within Hours)',
    'Easy(A Day)',
    'Moderate(3 Days)',
    'Intermediate(5 Days)',
    'Advance(1 week)'
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(
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
                items: members
                    .map((member) => DropdownMenuItem(
                          value: member,
                          child: Text(member),
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
              SizedBox(height: screenHeight * 0.02),

              // Difficulty Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.speed, color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hint: const Text("Select Difficulty"),
                value: selectedDifficulty,
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value;
                  });
                },
                items: difficulties
                    .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty),
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
                            onPressed: () {
                              Navigator.pop(context);
                              // Add your task creation logic here
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TaskScreen()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Task created successfully!")),
                              );
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
