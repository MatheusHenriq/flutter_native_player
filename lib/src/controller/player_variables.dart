import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:native_communication/src/constants/constants.dart';

class PlayerVariables extends GetxController {
  final methodChannel = const MethodChannel(playerMethodChannelTag);
  final listenerChannel = const EventChannel(playerListenerChannelTag);
  StreamSubscription? eventSubscription;
}
