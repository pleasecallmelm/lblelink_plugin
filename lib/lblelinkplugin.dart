import 'dart:async';

import 'package:flutter/services.dart';

class Lblelinkplugin {
  static const MethodChannel _channel = const MethodChannel('lblelinkplugin');
  static const EventChannel _eventChannel = const EventChannel("lblelink_event");

  //初始化sdk
  static initLBSdk(String appid, String secretKey) {
    _channel
        .invokeMethod("initLBSdk", {"appid": appid, "secretKey": secretKey});
  }

  //获取设备列表
  //回调：设备数组
  static getServicesList() {
    _eventChannel.receiveBroadcastStream().listen((data){


    });
  }

  //连接设备(参数未定)
  static connectToService(){

    _channel.invokeMethod("connectToService");

  }

  //断开连接
  static disConnect(){
    _channel.invokeMethod("disConnect");
  }

  //暂停
  static pause(){
    _channel.invokeMethod("pause");
  }

  //继续播放
  static resumePlay(){
    _channel.invokeMethod("resumePlay");
  }

  //退出播放
  static stop(){
    _channel.invokeMethod("stop");
  }

  //播放
  static play(String playUrlString){
    _channel.invokeMethod("play",{"playUrlString":playUrlString});
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
