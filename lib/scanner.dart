import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:scanner/components/target_machine_config.dart';

class MyScanner extends StatefulWidget {
  const MyScanner({Key? key}) : super(key: key);

  @override
  State<MyScanner> createState() => _MyScannerState();
}

class _MyScannerState extends State<MyScanner> {
  String result = '';
  String state = '';

  @override
  void initState() {
    super.initState();
  }

  void _scan() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", false, ScanMode.BARCODE);

    setState(() {
      this.result = result != '-1' ? result : '';
      state = '';
    });
  }

  void _sendToUrl() async {
    if (result == '') return;

    String _target = await TargetMachineConfig.getTargetMachineIPnPort();

    final res = await http.get(Uri.parse("http://${_target}?result=$result"));
    if (res.statusCode == 200) {
      setState(() {
        state = 'SENT';
      });
    } else {
      setState(() {
        state = 'ERROR';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.00, bottom: 16.00),
            child: SelectableText(
              result,
              style: const TextStyle(fontSize: 30.00, color: Colors.green),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: _scan,
                  label: const Text(
                    'Scan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.scanner)),
              ElevatedButton.icon(
                  onPressed: _sendToUrl,
                  label: const Text(
                    'Send',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
