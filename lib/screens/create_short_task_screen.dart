import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/task_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;

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

  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isRecording = false, isPlaying = false;
  String? recordingPath, recordingBase64;
  String? audioPath;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Retrieve manager's ID
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

              SizedBox(height: screenHeight * 0.02),

              // ------------------------- Record Audio Button ------------------------
              FloatingActionButton.extended(
                onPressed: () async {
                  if (isRecording) {
                    // Stop recording
                    final filePath = await audioRecorder.stop();
                    if (filePath != null) {
                      final fileBytes = await File(filePath).readAsBytes();
                      final base64Audio = base64Encode(fileBytes);

                      setState(() {
                        isRecording = false;
                        recordingPath = filePath;
                        recordingBase64 =
                            base64Audio; // Save Base64 audio string
                      });

                      showSnackBar(context, "Recording saved.");
                    }
                  } else {
                    if (await audioRecorder.hasPermission()) {
                      final Directory appDir =
                          await getApplicationDocumentsDirectory();
                      final String audioPath =
                          p.join(appDir.path, "task_audio.wav");
                      await audioRecorder.start(const RecordConfig(),
                          path: audioPath);

                      setState(() {
                        isRecording = true;
                        recordingPath = null;
                      });

                      showSnackBar(context, "Recording started...");
                    }
                  }
                },
                label: Text(isRecording ? "Stop Recording" : "Start Recording"),
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
              ),

              if (recordingPath != null) ...[
                SizedBox(height: screenHeight * 0.02),

                // ------------------------- Play Audio Button ------------------------
                ElevatedButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.setFilePath(recordingPath!);
                      await audioPlayer.play();
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: Text(isPlaying ? "Stop Playback" : "Play Recording"),
                ),
              ],

              SizedBox(height: screenHeight * 0.03),

              // -------------------------- Create Task Button -------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedMember == null) {
                      showSnackBar(context, "Please select a member.");
                      return;
                    }

                    try {
                      final taskProvider =
                          Provider.of<TaskProvider>(context, listen: false);
                      await taskProvider.createTask(
                        titleController.text,
                        descController.text,
                        "short",
                        selectedMember!,
                        "high",
                        audioBase64: recordingBase64, // Send audio as Base64
                      );

                      // Show success message
                      showSnackBar(context, 'Task created successfully');

                      // Navigate to the employee tasks screen
                      Navigator.pushReplacementNamed(context, '/employeeTasks');
                    } catch (e) {
                      showSnackBar(context, "Error creating task: $e");
                      print("====================================");
                      print(e);
                    }
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
