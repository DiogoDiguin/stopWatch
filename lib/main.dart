import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StopWatch',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int seconds = 0, minutes = 0, milliseconds = 0;
  String digitSeconds = "00", digitMinutes = "00", digitMilliseconds = "00";
  Timer? timer;
  bool started = false;
  List<String> laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      milliseconds = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitMilliseconds = "00";

      started = false;
      laps.clear();
    });
  }

  void addLaps() {
    String lap = "$digitMinutes:$digitSeconds.$digitMilliseconds";

    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(Duration(milliseconds: 99), (timer) {
      int localMinutes = minutes;
      int localSeconds = seconds;
      int localMilliseconds = milliseconds + 10;

      if (localMilliseconds > 999) {
        if (localSeconds > 59) {
          localMinutes++;
          localSeconds = 0;
        } else {
          localSeconds++;
        }
        localMilliseconds = 0;
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        milliseconds = localMilliseconds;

        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMilliseconds = (milliseconds >= 99)
            ? "${milliseconds ~/ 10}"
            : (milliseconds >= 10)
            ? "0${milliseconds ~/ 10}"
            : "00${milliseconds ~/ 10}";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "StopWatch App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Text("$digitMinutes:$digitSeconds.$digitMilliseconds",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 82.0,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lap nº${index + 1}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "${laps[index]}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          (!started) ? start() : stop();
                        },
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        child: Text(
                          (!started) ? "Start" : "Pause",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        addLaps();
                      },
                      icon: Icon(Icons.flag),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          reset();
                        },
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        shape: const StadiumBorder(),
                        child: Text(
                          "Reset",
                          style:
                          TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
