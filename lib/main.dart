import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Timer App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isRunning = false;
  late int timer = 600;
  late int currentDuration = timer;
  late double _currentFactor = 1.0;

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  late dynamic currentTimer = _printDuration(Duration(seconds: timer));

  void startTimer() {
    if (!isRunning) {
      isRunning = true;
      currentDuration = timer;
      setState(() {
        _currentFactor = 0;
        currentTimer = _printDuration(Duration(seconds: timer));
      });
      for (int i = timer; i > 0; i--) {
        Future.delayed(Duration(seconds: i), () => setState(() {
          currentTimer = _printDuration(Duration(seconds: timer - i));
        }));
        Future.delayed(Duration(seconds: timer), () => setState(() {
          isRunning = false;
          currentDuration = 0;
          currentTimer = _printDuration(Duration(seconds: timer));
          _currentFactor = 1;
        }));
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                '$currentTimer',
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w300
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 350.0,
                height: 30,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: AnimatedFractionallySizedBox(
                    duration: Duration(seconds: currentDuration),
                    alignment: Alignment.centerLeft,
                    widthFactor: _currentFactor,
                    heightFactor: 1,
                    child: const DecoratedBox(decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    )),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: startTimer,
                child: const Text('Start timer!')
            )
          ],
        ),
      ),
    );
  }
}
