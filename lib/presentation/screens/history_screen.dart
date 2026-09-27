import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../data/models/workout_session.dart';
import '../widgets/weekly_chart.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<WorkoutSession>('workouts');

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              box.clear();
              // Also close screen to prevent errors
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<WorkoutSession> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text("No workouts yet. Go do some pushups!"),
            );
          }

          final workouts = box.values.toList().reversed.toList();

          return Column(
            children: [
              // 1. THE CHART (Takes the top part of the screen)
              WeeklyChart(box: box),

              // 2. THE HISTORY LIST (Takes the remaining space)
              Expanded(
                child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final session = workouts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          child: Text(
                            "${session.count}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          DateFormat(
                            'MMM d, yyyy - h:mm a',
                          ).format(session.date),
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "${session.durationSeconds} seconds",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
