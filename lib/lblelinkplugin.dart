import 'dart:async';

import 'package:flutter/services.dart';

class Lblelinkplugin {
  static const MethodChannel _channel =
      const MethodChannel('lblelinkplugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
