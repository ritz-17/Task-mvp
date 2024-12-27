import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import '../provider/timer_provider.dart';
import '../utils/task_list_tile.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
    // Start the timer when the screen is initialized if the task is accepted
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    if (timerProvider.isTimerStarted && widget.task.status == 'Accepted') {
      _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Task Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(widget.task.description),
            SizedBox(height: 20),
            // Circular Countdown Timer
            CircularCountDownTimer(
              duration: widget.task.timeToComplete.inSeconds,
              width: 200,
              height: 200,
              ringColor: Colors.grey,
              fillColor: Colors.green,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
              isReverse: true,
              controller: _controller,
              onComplete: () {
                // Handle timer completion (e.g., display a message)
                print('Timer completed!');
              },
              onChange: (remainingTime) {
                // Update the UI with the remaining time (optional)
              },
            ),
          ],
        ),
      ),
    );
  }
}
