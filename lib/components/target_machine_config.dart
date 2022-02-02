import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class TargetMachineConfig extends StatefulWidget {
  BuildContext context;
  TargetMachineConfig(this.context, {Key? key}) : super(key: key);

  @override
  State<TargetMachineConfig> createState() => _TargetMachineConfigState();

  static Future<String> getTargetMachineIPnPort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('target_url') ?? '';
  }
}

class _TargetMachineConfigState extends State<TargetMachineConfig> {
  String _ipnPort = '';
  final _ipnPortInput = TextEditingController(text: '');
  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var result = await TargetMachineConfig.getTargetMachineIPnPort();
    setState(() {
      _ipnPort = result;
      _ipnPortInput.text = result;
    });
  }

  void _savePrefs() async {
    var value = _ipnPortInput.text;
    await prefs.setString('target_url', value);
    setState(() {
      _ipnPort = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {});
      },
      controller: _ipnPortInput,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Target',
          hintText: 'Enter url:port',
          prefixIcon: const Icon(
            Icons.electrical_services_rounded,
          ),
          suffixIcon: IconButton(
            onPressed: _savePrefs,
            icon: Icon(Icons.save,
                color:
                    _ipnPort == _ipnPortInput.text ? Colors.green : Colors.red),
          )),
    );
  }
}
