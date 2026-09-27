import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/workout_session.dart';
// These imports will be red until we create the files in the next steps
import 'logic/counter_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized before async code
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(WorkoutSessionAdapter());
  await Hive.openBox<WorkoutSession>('workouts');

  // 4. Run the App
  runApp(const PushupApp());
}

class PushupApp extends StatelessWidget {
  const PushupApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows us to access data (pushup counts) anywhere in the app
    return MultiProvider(
      providers: [
        // We will create this logic class next
        ChangeNotifierProvider(create: (_) => CounterProvider()),
      ],
      child: MaterialApp(
        title: 'Pushup Counter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Using a dark theme because it saves battery and looks "gym-like"
          brightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: const Color(0xFF121212),
          useMaterial3: true,
        ),
        // This will be our landing page
        home: const HomeScreen(),
      ),
    );
  }
}
