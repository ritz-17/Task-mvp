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
  List<String> selectedMembers = [];
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isRecording = false, isPlaying = false;
  String? recordingPath, recordingBase64;
  String? audioPath;
  DateTime? selectedDeadline;

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

  Future<void> startRecording() async {
    if (await audioRecorder.hasPermission()) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String audioPath = p.join(appDir.path, "task_audio.wav");
      await audioRecorder.start(const RecordConfig(), path: audioPath);
      setState(() {
        isRecording = true;
        recordingPath = null;
      });
      showSnackBar(context, "Recording started...");
    }
  }

  Future<void> stopRecording() async {
    final filePath = await audioRecorder.stop();
    if (filePath != null) {
      final fileBytes = await File(filePath).readAsBytes();
      final base64Audio = base64Encode(fileBytes);
      setState(() {
        isRecording = false;
        recordingPath = filePath;
        recordingBase64 = base64Audio;
      });
      showSnackBar(context, "Recording saved");
    }
  }

  Future<void> playRecording() async {
    if (recordingPath != null) {
      await audioPlayer.setFilePath(recordingPath!);
      await audioPlayer.play();
      setState(() => isPlaying = true);
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => isPlaying = false);
        }
      });
    }
  }

  void deleteRecording() {
    setState(() {
      recordingPath = null;
      recordingBase64 = null;
    });
    showSnackBar(context, "Recording deleted");
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

              SizedBox(height: screenHeight * 0.02),

              // ------------------------- Record Audio Button ------------------------

              if (recordingPath == null) ...[
                ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  child:
                      Text(isRecording ? "Stop Recording" : "Start Recording"),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: playRecording,
                      child: Text(isPlaying ? "Playing..." : "Play Recording"),
                    ),
                    ElevatedButton(
                      onPressed: deleteRecording,
                      child: const Text("Delete Recording"),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],

              SizedBox(height: screenHeight * 0.03),

              // -------------------------- Create Task Button -------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedMembers.isEmpty) {
                      showSnackBar(context, "Please select a members");
                      return;
                    }

                    try {
                      final taskProvider =
                          Provider.of<TaskProvider>(context, listen: false);
                      await taskProvider.createTask(
                        titleController.text,
                        descController.text,
                        "short",
                        selectedMembers,
                        "high",
                        recordingBase64,
                        [],
                        selectedDeadline!,
                      );

                      // Show success message
                      showSnackBar(context, 'Task created successfully');

                      // Navigate to the employee tasks screen
                      Navigator.pushReplacementNamed(context, '/employeeTasks');
                    } catch (e) {
                      debugPrint(e.toString());
                      showSnackBar(context, "Error creating task");
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
