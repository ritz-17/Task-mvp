import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import '../provider/timer_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId; // Pass only the task ID

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final CountDownController _controller = CountDownController();
  Task? _task;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _task = taskProvider.getTaskById(widget.taskId); // Fetch task by ID
    if (_task != null && _task!.status == 'Accepted') {
      _controller.start();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    if (_task == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_task!.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Details',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _task!.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (_task!.status == 'Accepted')
              Center(
                child: CircularCountDownTimer(
                  duration: 60,
                  controller: _controller,
                  width: 200,
                  height: 200,
                  ringColor: Colors.grey.shade300,
                  fillColor: Colors.green,
                  backgroundColor: Colors.white,
                  strokeWidth: 10.0,
                  strokeCap: StrokeCap.round,
                  textStyle: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  isReverse: true,
                  isReverseAnimation: true,
                  onComplete: () {
                    // Notify timer completion
                    timerProvider.stopTimer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task time completed!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Text(
                  'This task is ${_task!.status}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.stopTimer();
    super.dispose();
  }
}
