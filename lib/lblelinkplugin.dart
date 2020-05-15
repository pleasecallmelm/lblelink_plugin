import 'dart:async';
import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class Lblelinkplugin {
  static const MethodChannel _channel = const MethodChannel('lblelinkplugin');
  static const EventChannel _eventChannel =
      const EventChannel("lblelink_event");

  //设备列表回调
  static ValueChanged<List<String>> _serviecListener;


  //eventChannel监听分发中心
  static eventChannelDistribution(){

    _eventChannel.receiveBroadcastStream().listen((data) {
      int type = data["type"];

      switch (type){
        case -1:
          
          break;
        default:
          break;
      }
    });

  }


  //初始化sdk
  //返回值：初始化成功与否
  static Future<bool> initLBSdk(String appid, String secretKey) async{
    await _channel
        .invokeMethod("initLBSdk", {"appid": appid, "secretKey": secretKey});

    //初始化的时候注册eventChannel回调
    eventChannelDistribution();

  }

  //获取设备列表
  //回调：设备数组
  static getServicesList(ValueChanged<List<String>> serviecListener) {
    //开始搜索设备
    _channel.invokeMethod("beginSearchEquipment");

    _serviecListener = serviecListener;

//    _eventChannel.receiveBroadcastStream().listen((data) {
//
//      List<String> result = [];
//      data.forEach((data) {
//        String name = data as String;
//        result.add(name);
//      });
//        messageListener(result);
//    });
  }

  //连接设备(参数未定)
  static connectToService(String tvUID) {
    _channel.invokeMethod("connectToService",{"tvUID":tvUID});
    //连接设备的回调
    _eventChannel.receiveBroadcastStream().listen((data) {


    });
  }

  //断开连接
  static disConnect() {
    _channel.invokeMethod("disConnect");
  }

  //暂停
  static pause() {
    _channel.invokeMethod("pause");
  }

  //继续播放
  static resumePlay() {
    _channel.invokeMethod("resumePlay");
  }

  //退出播放
  static stop() {
    _channel.invokeMethod("stop");
  }

  //播放
  static play(String playUrlString) {
    _channel.invokeMethod("play", {"playUrlString": playUrlString});
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
