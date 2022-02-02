import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:scanner/components/target_machine_config.dart';
import 'package:http/http.dart';

class IntentReciver extends StatefulWidget {
  const IntentReciver({Key? key}) : super(key: key);

  @override
  State<IntentReciver> createState() => _IntentReciverState();
}

class _IntentReciverState extends State<IntentReciver> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles = [];
  String _sharedText = '';

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
      });
    });

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen((event) {
      setState(() {
        _sharedFiles = event;
      });
    });

    // // For sharing or opening urls/text coming from outside the app while the app is closed
    // ReceiveSharingIntent.getInitialText().then((value) {
    //   setState(() {
    //     _sharedText = value!;
    //   });
    // });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void sendFile() async {
    if (_sharedFiles.length < 1) return;
    try {
      var target = await TargetMachineConfig.getTargetMachineIPnPort();
      MultipartRequest request = MultipartRequest('POST', Uri.parse(target));

      for (var element in _sharedFiles) {
        request.files.add(await MultipartFile.fromPath(
            element.path.split('/').last, element.path));
      }

      StreamedResponse response = await request.send();
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_sharedFiles.isNotEmpty)
          Container(
            height: 200,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.file(File(_sharedFiles[0].path)),
            ),
          )
        else
          Text('Not Fount'),
        Center(
          child: Text(_sharedFiles.map((f) => f.path).join(",")),
        ),
      ],
    );
  }
}
