import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:fluffy/main.dart';

void main() {
  testWidgets('Counter increments smoke test with my title and Message', (tester) async {

    // Here below is he test code
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(title: 'My Test Title', message: 'Hello, Flutter!'));
/*
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget); 
*/
    // Creating finders
    final titleFinder = find.text('My Test Title');
    final messageFinder = find.text('Hello, Flutter!');

    // Use the `findsOneWidget` matcher provider by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsNothing);
    expect(messageFinder, findsOneWidget); 
    
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
