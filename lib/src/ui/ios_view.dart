import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:native_communication/src/constants/constants.dart';
import 'package:native_communication/src/controller/player_controller.dart';

class IosView extends GetView<PlayerController> {
  final String url;
  const IosView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: playerViewTag,
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: const {},
      onPlatformViewCreated: (value) async {
        controller.initPlayer(url);
        controller.listenerPlayerEvents();
      },
    );
  }
}
