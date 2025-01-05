import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../provider/timer_provider.dart';
import '../models/task_model.dart';

class EmployeeTaskPage extends StatefulWidget {
  const EmployeeTaskPage({super.key});

  @override
  State<EmployeeTaskPage> createState() => _EmployeeTaskPageState();
}

class _EmployeeTaskPageState extends State<EmployeeTaskPage> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTaskList();
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
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TimerProvider()),
        ],
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            final tasks = taskProvider.taskList;

            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

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

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: ListTile(
                    title: Text(
                      task.title,
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
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           task.status = 'Accepted';
                    //         });
                    //         Provider.of<TimerProvider>(context, listen: false)
                    //             .startTimer();
                    //       },
                    //       child: const Text('Accept'),
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.green,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 5),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           task.status = 'Rejected';
                    //         });
                    //       },
                    //       child: const Text('Reject'),
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.red,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
