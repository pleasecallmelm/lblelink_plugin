import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lblelinkplugin/tv_list.dart';

class Lblelinkplugin {
  static const MethodChannel _channel = const MethodChannel('lblelinkplugin');
  static const EventChannel _eventChannel =
      const EventChannel("lblelink_event");

  //设备列表回调
  static ValueChanged<List<TvData>> _serviecListener;

  static Function _connectListener;
  static Function _disConnectListener;
  static LbCallBack _lbCallBack;

  static set lbCallBack(LbCallBack value) {
    _lbCallBack = value;
  } //eventChannel监听分发中心

  static eventChannelDistribution() {
    _eventChannel.receiveBroadcastStream().listen((data) {
      print(data);
      int type = data["type"];

      switch (type) {
        case -1:
          _disConnectListener.call();
          break;
        case 0:
          TvListResult _tvList = TvListResult();
          _tvList.getResultFromMap(data["data"]);
          _serviecListener?.call(_tvList.tvList);
          break;
        case 1:
          _connectListener?.call();
          break;
        case 2:
          _lbCallBack.loading();
          break;
        case 3:
          _lbCallBack.start();
          break;
        case 4:
          _lbCallBack.pause();
          break;
        case 5:
          _lbCallBack.pause();
          break;
        case 6:
          _lbCallBack.stop();
          break;
        case 9:
          _lbCallBack.error();
          break;
        default:
          print(data["data"]);
          break;
      }
    });
  }

  //初始化sdk
  //返回值：初始化成功与否
  static Future<bool> initLBSdk(String appid, String secretKey) async {
    await _channel
        .invokeMethod("initLBSdk", {"appid": appid, "secretKey": secretKey});

    //初始化的时候注册eventChannel回调
    eventChannelDistribution();
  }

  //获取设备列表
  //回调：设备数组
  static getServicesList(ValueChanged<List<TvData>> serviecListener) {
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
  static connectToService(String tvUID,
      {@required Function fConnectListener,
      @required Function fDisConnectListener}) {
    _connectListener = fConnectListener;
    _disConnectListener = fDisConnectListener;
    _channel.invokeMethod("connectToService", {"tvUID": tvUID});
  }


  //断开连接
  static disConnect() {
    _channel.invokeMethod("disConnect");
//        .then((data){
//      if(data == 0){
//        _disConnectListener.call();
//      }
//    });
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

abstract class LbCallBack {
  void start();

  void loading();

  void complete();

  void pause();

  void stop();

  void error();
}
