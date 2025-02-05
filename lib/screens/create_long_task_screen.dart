import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/task_provider.dart';
import 'package:task_mvp/utils/utils.dart';
import '../provider/employee_provider.dart';
import 'task_list_screen.dart';

class CreateLongTask extends StatefulWidget {
  const CreateLongTask({super.key});

  @override
  State<CreateLongTask> createState() => _CreateLongTaskState();
}

class _CreateLongTaskState extends State<CreateLongTask> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final List<File?> _selectedImages = [null, null, null];
  final List<bool> _isUploading = [false, false, false];
  final List<String> priorities = ['high', 'medium', 'low'];

  List<String> selectedMembers = [];
  String? selectedPriority;
  DateTime? selectedDeadline;

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

  //multiple member selection dialog
  void showMultiSelectDialog(List employees) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  const Text("Select Members",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return CheckboxListTile(
                          title: Text(
                              '${employee.firstName} ${employee.lastName}'),
                          value: selectedMembers.contains(employee.id),
                          onChanged: (value) {
                            setState(() {
                              value == true
                                  ? selectedMembers.add(employee.id)
                                  : selectedMembers.remove(employee.id);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //pick deadline
  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
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
                  prefixIcon:
                      Icon(Icons.title, color: Theme.of(context).primaryColor),
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

              // Multi-Select Member
              GestureDetector(
                onTap: () => showMultiSelectDialog(freeMembers),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedMembers.isEmpty
                          ? "Select Members"
                          : "${selectedMembers.length} members selected"),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
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
                        value: priority, child: Text(priority)))
                    .toList(),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Deadline Selection
              GestureDetector(
                onTap: () => pickDeadline(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDeadline == null
                            ? "Select Deadline"
                            : selectedDeadline!.toUtc().toIso8601String(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Create Task Button
              ElevatedButton(
                onPressed: () async {
                  if (selectedMembers.isEmpty || selectedPriority == null) {
                    showSnackBar(context, "Please complete all fields");
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
                      selectedMembers,
                      selectedPriority!,
                      null,
                      encodedAttachments,
                      selectedDeadline!,
                    );

                    showSnackBar(context, "Task created successfully!");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskListScreen()),
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                    showSnackBar(context, "Error creating task");
                  }
                },
                child: const Text("Create Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
