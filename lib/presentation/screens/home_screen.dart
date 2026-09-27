import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/counter_provider.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<CounterProvider>(context);

    // Target for the visual ring (e.g., 1 set = 20 pushups)
    const int target = 20;
    double progress = (counterProvider.count / target).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Pushup Counter"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CURRENT SET",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // THE ANIMATED BUTTON
            // This shrinks when you go down (isNear) and pops back up
            AnimatedScale(
              scale: counterProvider.isNear ? 0.85 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Background Circle
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 20,
                      color: Colors.grey[850],
                    ),
                  ),
                  // 2. Progress Circle (Fills up)
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 20,
                      color: counterProvider.isNear
                          ? Colors.green
                          : Colors.deepOrange,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  // 3. The Number
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${counterProvider.count}",
                        style: TextStyle(
                          fontSize: 110,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: counterProvider.isNear
                                    ? Colors.green.withValues(alpha: 0.5)
                                    : Colors.orange.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "/ $target",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Helpful Hint
            Text(
              counterProvider.isNear ? "HOLD..." : "PUSH UP!",
              style: TextStyle(
                color: counterProvider.isNear
                    ? Colors.green
                    : Colors.transparent, // Hide text when not near
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (counterProvider.count == 0) return;

          try {
            await counterProvider.saveAndReset();
          } on Exception catch (error) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Could not save set: $error"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Set saved! Keep grinding."),
              backgroundColor: Colors.deepOrange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.check, color: Colors.white),
        label: const Text(
          "FINISH SET",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
