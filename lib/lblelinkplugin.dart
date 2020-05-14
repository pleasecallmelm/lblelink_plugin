import 'dart:async';

import 'package:flutter/services.dart';

class Lblelinkplugin {
  static const MethodChannel _channel =
      const MethodChannel('lblelinkplugin');

  //初始化sdk
  static initLBSdk(String appkey){

    _channel.invokeMethod("initLBSdk",{"appKey":appkey});

  }


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
