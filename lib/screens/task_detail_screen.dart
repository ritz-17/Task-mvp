import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/timer_provider.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task? _task;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    _task = taskProvider.getTaskById(widget.taskId);

    if (_task != null && _task!.status == 'accepted') {
      if (!timerProvider.isRunning) {
        timerProvider.startTimer(60);
      }
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
            if (_task!.status == 'accepted')
              Center(
                child: CircularCountDownTimer(
                  duration: 60, 
                  initialDuration: 60 -
                      timerProvider.remainingTime, 
                  controller: CountDownController(),
                  width: 200, 
                  height: 200, 
                  ringColor: Colors.grey.shade300, 
                  fillColor: Colors.green, 
                  backgroundColor: Colors.white, 
                  strokeWidth: 12.0, 
                  strokeCap: StrokeCap.round, 
                  textStyle: const TextStyle(
                    fontSize: 28.0, 
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  isReverse: true, 
                  isReverseAnimation: true, 
                  isTimerTextShown: true, 
                  autoStart: true, 
                  onComplete: () {
                    timerProvider.stopTimer();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task time completed!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
}
