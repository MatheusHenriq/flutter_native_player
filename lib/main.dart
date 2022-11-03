import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_communication/src/constants/constants.dart';
import 'package:native_communication/src/controller/player_controller.dart';
import 'package:native_communication/src/ui/android_view.dart';
import 'package:native_communication/src/ui/ios_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PlayerController controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: Get.width,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GetPlatform.isAndroid
                    ? const AndroidViewFlutter(url: androidUrl)
                    : const IosView(url: iosUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Obx(
                () => Text(
                  "${controller.currentTime}/${controller.duration}",
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async => controller.isPlaying.value
              ? controller.pause()
              : controller.play(),
          tooltip: 'player',
          child: Icon(
            controller.isPlaying.value
                ? Icons.play_arrow
                : Icons.pause_circle_filled_outlined,
          ),
        ),
      ),
    );
  }
}
