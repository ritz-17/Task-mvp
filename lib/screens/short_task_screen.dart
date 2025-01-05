import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class ShortTaskScreen extends StatefulWidget {
  const ShortTaskScreen({super.key});

  @override
  State<ShortTaskScreen> createState() => _ShortTaskScreenState();
}

class _ShortTaskScreenState extends State<ShortTaskScreen> {
  String? selectedMember;
  String? selectedJobType;
  String? createdBy; // To store the createdBy ID

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<Map<String, String>> members = [
    {'name': 'Aditya', 'id': ''},
    {'name': 'Mayur', 'id': '6e982759be9031c94ae967'},
    {'name': 'Vanshika', 'id': ''},
  ];

  final List<String> jobTypes = ['short'];

  @override
  void initState() {
    super.initState();
    fetchCreatedBy(); // Fetch createdBy ID when screen loads
  }

  Future<void> fetchCreatedBy() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await authProvider.fetchUserId(); // Get the createdBy ID
    setState(() {
      createdBy = userId;
    });
  }

  void submitTask() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedMember == null ||
        selectedJobType == null ||
        createdBy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    final selectedMemberId =
        members.firstWhere((member) => member['name'] == selectedMember)['id'];

    final requestBody = {
      "title": titleController.text,
      "description": descriptionController.text,
      "jobType": selectedJobType,
      "assignedTo": selectedMemberId,
      "createdBy": createdBy, // Dynamically fetched createdBy ID
    };

    try {
      // Awaiting the result of the createTask method to ensure it's completed
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.createTask(requestBody);

      // If task creation is successful, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task created successfully!")),
      );
    } catch (e) {
      // If an error occurs, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating task: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            children: [
              SizedBox(height: screenHeight * 0.02),

              // -------------------- Task Title Field -------------------------
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

              // ------------------ Task Description Field ---------------------
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Enter Task Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // --------------------- Assign To Dropdown ----------------------
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
                items: members
                    .map((member) => DropdownMenuItem(
                          value: member['name'],
                          child: Text(member['name']!),
                        ))
                    .toList(),
              ),
              SizedBox(height: screenHeight * 0.02),

              // -------------------- Job Type Dropdown ------------------------
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.work, color: Theme.of(context).primaryColor),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hint: const Text("Select Job Type"),
                value: selectedJobType,
                onChanged: (value) {
                  setState(() {
                    selectedJobType = value;
                  });
                },
                items: jobTypes
                    .map((jobType) => DropdownMenuItem(
                          value: jobType,
                          child: Text(jobType),
                        ))
                    .toList(),
              ),

              SizedBox(height: screenHeight * 0.03),

              // -------------------- Create Task Button -----------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitTask,
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
