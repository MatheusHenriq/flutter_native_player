import 'package:flutter/services.dart';
import 'package:native_communication/src/controller/player_variables.dart';

class PlayerMethods extends PlayerVariables {
  Future initPlayer(String mediaUrl) async {
    try {
      await methodChannel.invokeMethod("initPlayer", {"mediaUrl": mediaUrl});
    } catch (e) {
      throw PlatformException(code: e.toString());
    }
  }

  Future play() async {
    try {
      await methodChannel.invokeMethod(
        "play",
      );
    } catch (e) {
      throw PlatformException(
        code: e.toString(),
      );
    }
  }

  Future pause() async {
    try {
      await methodChannel.invokeMethod(
        "pause",
      );
    } catch (e) {
      throw PlatformException(
        code: e.toString(),
      );
    }
  }
}
