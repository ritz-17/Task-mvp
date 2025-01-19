import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  bool _isTimerStarted = false;
  int _remainingTime = 0; // Remaining time in seconds
  Timer? _timer;

  bool get isTimerStarted => _isTimerStarted;
  int get remainingTime => _remainingTime;

  /// Starts the timer with the given duration (in seconds).
  void startTimer(int durationInSeconds) {
    _remainingTime = durationInSeconds;
    _isTimerStarted = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        _isTimerStarted = false;
        notifyListeners();
      }
    });
  }

  /// Stops the timer.
  void stopTimer() {
    _timer?.cancel();
    _isTimerStarted = false;
    _remainingTime = 0;
    notifyListeners();
  }

  /// Resets the timer to the given duration (in seconds).
  void resetTimer(int durationInSeconds) {
    stopTimer();
    startTimer(durationInSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
