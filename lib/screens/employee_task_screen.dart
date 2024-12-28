import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mvp/provider/timer_provider.dart';
import 'package:task_mvp/utils/task_list_tile.dart';
import 'task_detail_screen.dart';

class EmployeeTaskPage extends StatefulWidget {
  const EmployeeTaskPage({super.key});

  @override
  State<EmployeeTaskPage> createState() => _EmployeeTaskPageState();
}

class _EmployeeTaskPageState extends State<EmployeeTaskPage> {
  List<Task> tasks = [
    Task(
      name: 'Task 1',
      timeToComplete: Duration(minutes: 60), // 1 hour
      description: 'Description 1',
    ),
    Task(
      name: 'Task 2',
      timeToComplete: Duration(minutes: 30),
      description: 'Description 2',
    ),
    Task(
      name: 'Task 3',
      timeToComplete: Duration(hours: 2),
      description: 'Description 3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => TimerProvider(),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(task: tasks[index]),
                  ),
                );
              },
              child: TaskTile(
                task: tasks[index],
                onAccept: () {
                  setState(() {
                    tasks[index].status = 'Accepted';
                  });
                  Provider.of<TimerProvider>(context, listen: false).startTimer(); 
                },
                onReject: () {
                  setState(() {
                    tasks[index].status = 'Rejected';
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}