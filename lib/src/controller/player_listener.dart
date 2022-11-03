import 'package:native_communication/src/controller/player_methods.dart';

abstract class PlayerListener extends PlayerMethods {
  Future listenerPlayerEvents() async {
    eventSubscription =
        listenerChannel.receiveBroadcastStream().listen((event) async {
      switch (event) {
        case "isPlaying":
          break;
        case "isReady":
          break;
        default:
      }
    });
  }
}
