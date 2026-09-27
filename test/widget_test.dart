import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pushup_counter/logic/counter_provider.dart';
import 'package:pushup_counter/presentation/screens/home_screen.dart';

class _TestCounterProvider extends ChangeNotifier implements CounterProvider {
  @override
  int count = 7;

  @override
  bool isNear = false;

  @override
  Future<void> saveAndReset() async {}
}

void main() {
  testWidgets('home screen displays the current push-up count', (tester) async {
    final counterProvider = _TestCounterProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<CounterProvider>.value(
        value: counterProvider,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('7'), findsOneWidget);
    expect(find.text('/ 20'), findsOneWidget);
    expect(find.text('PUSH UP!'), findsOneWidget);
  });
}
