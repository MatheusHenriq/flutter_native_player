import 'package:flutter/services.dart';
import 'package:native_communication/src/controller/player_variables.dart';

class PlayerMethods extends PlayerVariables {
  void initPlayer(String mediaUrl) async {
    try {
      await methodChannel.invokeMethod("initPlayer", {"mediaUrl": mediaUrl});
    } catch (e) {
      throw PlatformException(code: e.toString());
    }
  }

  void play() async {
    try {
      await methodChannel.invokeMethod(
        "play",
      );
      isPlaying.value = true;
    } catch (e) {
      throw PlatformException(
        code: e.toString(),
      );
    }
  }

  void pause() async {
    try {
      await methodChannel.invokeMethod(
        "pause",
      );
      isPlaying.value = false;
    } catch (e) {
      throw PlatformException(
        code: e.toString(),
      );
    }
  }
}
