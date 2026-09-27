import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../data/models/workout_session.dart';

class WeeklyChart extends StatelessWidget {
  final Box<WorkoutSession> box;

  const WeeklyChart({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    // 1. Calculate the data for the chart
    final List<int> weeklyCounts = _getLast7DaysCounts();
    final double maxCount = weeklyCounts
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    // Add some buffer to the top of the chart so bars don't hit the ceiling
    final double maxY = maxCount > 0 ? maxCount * 1.2 : 10;

    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        color: Colors.grey[900],
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Last 7 Days",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    // Hide the ugly grid lines
                    gridData: const FlGridData(show: false),
                    // Hide the border box
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      // Hide Top and Right labels
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      // Left labels (Numbers)
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      // Bottom labels (Days of Week)
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Calculate the day name (Mon, Tue) based on index
                            final date = DateTime.now().subtract(
                              Duration(days: 6 - value.toInt()),
                            );
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat(
                                  'E',
                                ).format(date)[0], // First letter (M, T, W)
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // The actual bars
                    barGroups: List.generate(7, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: weeklyCounts[index].toDouble(),
                            color: Colors.deepOrange,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                            // Show the number on top of the bar
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LOGIC: Sums up pushups for each of the last 7 days
  List<int> _getLast7DaysCounts() {
    final List<int> counts = List.filled(7, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var session in box.values) {
      final sessionDate = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );

      // Check if this session happened within the last 7 days
      final difference = today.difference(sessionDate).inDays;
      if (difference >= 0 && difference < 7) {
        // Index 6 is Today, Index 5 is Yesterday... Index 0 is 6 days ago
        counts[6 - difference] += session.count;
      }
    }
    return counts;
  }
}
