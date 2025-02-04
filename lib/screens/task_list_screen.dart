import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTaskList();
    });
  }

  Future<void> _fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = taskProvider.taskList;

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              String taskId = task.id;

              Widget taskTile = InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/task-details',
                      arguments: taskId);
                },
                child: Card(
                  color: task.status == 'pending'
                      ? Colors.yellow[100]
                      : task.status == 'accepted'
                          ? Colors.green[100]
                          : Colors.red[100],
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: ListTile(
                    title: Text(
                      'Task: ${task.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description: ${task.description}"),
                        Text("Status: ${task.status}"),
                      ],
                    ),
                    trailing: _role == 'employee'
                        ? task.status == 'pending'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.cancel,
                                        color: Colors.red),
                                    onPressed: () {
                                      taskProvider.updateTaskStatus(
                                          taskId, 'rejected');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    onPressed: () {
                                      taskProvider.updateTaskStatus(
                                          taskId, 'accepted');
                                    },
                                  ),
                                ],
                              )
                            : Icon(
                                task.status == 'accepted'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: task.status == 'accepted'
                                    ? Colors.green
                                    : Colors.red,
                              )
                        : null, // Hide trailing actions for managers
                  ),
                ),
              );

              // If role is 'manager', wrap with Slidable
              return _role == 'manager'
                  ? Slidable(
                      key: ValueKey(taskId),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              print("Reassign task: $taskId");
                              // Handle reassign task action here
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.refresh,
                            label: 'Reassign',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              await taskProvider.deleteTask(taskId);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.cancel,
                            label: 'Cancel',
                          ),
                        ],
                      ),
                      child: taskTile,
                    )
                  : taskTile;
            },
          );
        },
      ),
    );
  }
}
