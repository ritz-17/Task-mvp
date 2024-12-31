import 'package:flutter/material.dart';

class Task {
  final String name;
  final String description;
  final Duration timeToComplete;
  String status = "Pending";

  Task({
    required this.name,
    required this.timeToComplete,
    required this.description,
  });
}

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Text(
            task.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Time: ${task.timeToComplete.inMinutes} minutes'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: task.status == "Pending",
                child: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30,
                  ),
                  onPressed: onAccept,
                ),
              ),
              Visibility(
                visible: task.status == "Pending",
                child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: onReject,
                ),
              ),
              Visibility(
                visible: task.status == "Accepted",
                child: Text(
                  "Accepted",
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Visibility(
                visible: task.status == "Rejected",
                child: Text(
                  "Rejected",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
