import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter_tts/flutter_tts.dart'; // <--- NEW IMPORT

import '../data/models/workout_session.dart';

class CounterProvider with ChangeNotifier {
  int _count = 0;
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;
  DateTime? _startTime;

  // 1. Create the Speaker
  final FlutterTts _flutterTts = FlutterTts();

  int get count => _count;
  bool get isNear => _isNear;

  CounterProvider() {
    _initSensor();
    _initTts(); // <--- Initialize logic
  }

  // 2. Configure the voice settings
  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Slower is clearer
    await _flutterTts.setVolume(1.0);
  }

  void _initSensor() {
    _streamSubscription = ProximitySensor.events.listen((int event) {
      bool isNowNear = (event > 0);

      if (isNowNear && _count == 0) {
        _startTime = DateTime.now();
      }

      if (isNowNear && !_isNear) {
        _increment();
      }

      _isNear = isNowNear;
      notifyListeners();
    });
  }

  void _increment() {
    _count++;

    // 3. SPEAK THE NUMBER!
    _speakCount();

    notifyListeners();
  }

  Future<void> _speakCount() async {
    // If it's the first one, say "Start" or just "One"
    await _flutterTts.speak(_count.toString());
  }

  Future<void> saveAndReset() async {
    if (_count > 0) {
      final box = Hive.box<WorkoutSession>('workouts');

      final duration = _startTime != null
          ? DateTime.now().difference(_startTime!).inSeconds
          : 0;

      final session = WorkoutSession(
        date: DateTime.now(),
        count: _count,
        durationSeconds: duration,
      );

      await box.add(session);

      // 4. Give audio confirmation
      await _flutterTts.speak("Workout Saved");
    }

    _count = 0;
    _startTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _flutterTts.stop(); // Stop talking if app closes
    super.dispose();
  }
}
