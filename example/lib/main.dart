import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lblelinkplugin/lblelinkplugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  List<String> _serviceNames = ["1111","2222"];


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
                FlatButton(onPressed: (){
                  Lblelinkplugin.initLBSdk("14342", "c67255e53e3feee87673bc67f6895360");
                }, child: Text("初始化")),
                FlatButton(onPressed: (){
                  Lblelinkplugin.getServicesList((data){

                    print("da is ${data}");

                    setState(() {
                     _serviceNames.addAll(data);

                    });
                  });
                }, child: Text("搜索设备")),
                FlatButton(onPressed: (){
                  Lblelinkplugin.connectToService("123");
                }, child: Text("连接设备")),
                FlatButton(onPressed: (){
                  Lblelinkplugin.play('http://pullhls80d25490.live.126.net/live/7d9cc146131245ddbf2126d56c699191/playlist.m3u8');
                }, child: Text("开始投屏"))
              ],
            ),
           Container(
             height: 400,
             width: 300,
             child:  ListView.builder(
                 itemCount: _serviceNames.length,
                 itemBuilder: (ctx,index){
                   return Text(_serviceNames[index]);
                 }),
           )
          ],
        ),
      ),
    );
  }
}
