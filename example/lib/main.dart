import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lblelinkplugin/tv_list.dart';
import 'package:flutter/services.dart';
import 'package:lblelinkplugin/lblelinkplugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  List<TvData> _serviceNames = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Lblelinkplugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      if (Platform.isIOS)
                        Lblelinkplugin.initLBSdk(
                            "14342", "c67255e53e3feee87673bc67f6895360");
                      else
                        Lblelinkplugin.initLBSdk(
                            "14345", "596d9df457fb194f6944c9bc51e8343d");
                    },
                    child: Text("初始化")),
                FlatButton(
                    onPressed: () {
                      Lblelinkplugin.getServicesList((data) {
                        setState(() {
                          _serviceNames.addAll(data);
                        });
                      });
                    },
                    child: Text("搜索设备")),
                FlatButton(
                    onPressed: () {
//                      Lblelinkplugin.connectToService("123");
                    },
                    child: Text("连接设备")),
                FlatButton(
                    onPressed: () {
                      Lblelinkplugin.play(
                          'http://v.mifile.cn/b2c-mimall-media/ed921294fb62caf889d40502f5b38147.mp4');
                    },
                    child: Text("开始投屏")),
                FlatButton(
                    onPressed: () {
                      Lblelinkplugin.disConnect();
                    },
                    child: Text("结束投屏"))
              ],
            ),
            Container(
              height: 400,
              width: 300,
              child: ListView.separated(
                itemCount: _serviceNames.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("设备名称：${_serviceNames[index].name}"),
                        Text("Uid：${_serviceNames[index].uId}"),
                      ],
                    ),
                    onTap: () {
                      Lblelinkplugin.connectToService(_serviceNames[index].uId, fConnectListener: (){
                        Lblelinkplugin.play(
                            'http://v.mifile.cn/b2c-mimall-media/ed921294fb62caf889d40502f5b38147.mp4');
                      }, fDisConnectListener: (){

                      });
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                      color: Colors.grey,
                      height: 1,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
