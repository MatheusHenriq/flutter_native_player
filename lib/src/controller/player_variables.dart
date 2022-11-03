import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:native_communication/src/constants/constants.dart';

class PlayerVariables extends GetxController {
  final methodChannel = const MethodChannel(playerMethodChannelTag);
  final listenerChannel = const EventChannel(playerListenerChannelTag);
  StreamSubscription? eventSubscription;
  RxBool isPlaying = false.obs;
  RxInt currentTime = 0.obs;
  RxInt duration = 0.obs;
}
