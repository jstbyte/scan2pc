import 'package:flutter/material.dart';
import 'package:scanner/components/target_machine_config.dart';
import 'package:scanner/intent_reciver.dart';
import 'package:scanner/scanner.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Scanner"),
            ),
            body: Column(children: [
              TargetMachineConfig(context),
              MyScanner(),
              IntentReciver(),
            ])));
  }
}
