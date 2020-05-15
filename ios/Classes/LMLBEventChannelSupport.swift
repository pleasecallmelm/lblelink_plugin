//
//  LMLBEventChannelSupport.swift
//  lblelinkplugin
//
//  Created by yunxiwangluo on 2020/5/14.
//

import UIKit
import LBLelinkKit

enum ResultType: Int {
    case disConnect = -1;
    case divice = 0;
    case connect = 1;
    case load = 2;
    case start = 3;
    case pause = 4;
    case complete = 5;
    case stop = 6;
    case seek = 7;
    case info = 8;
    case error = 9;
    case position = 10;
}


class LMLBEventChannelSupport: NSObject,FlutterPlugin, FlutterStreamHandler{
    
    static let sharedInstance = LMLBEventChannelSupport()
    
    var eventSink: FlutterEventSink?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterEventChannel(name: "lblelink_event", binaryMessenger: registrar.messenger())
        
        channel.setStreamHandler(LMLBEventChannelSupport.sharedInstance)
        
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events;
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        
        return nil
    }
    
    //发送设备列表到flutter
    func sendServicesToFlutter(services: [LBLelinkService]){
        
        if let sink = self.eventSink{
        
            var a: Array = Array<[String:String]>();
            
            for item in services {
                
                let dict: [String:String] = [
                    "tvName": item.lelinkServiceName,
                    "tvUID": item.tvUID
                ];
                a.append(dict);
            }
            
            sink(self.createResult(type: .divice, data: a));
        }
    }
    
    //发送错误给flutter
    func sendErrorToFlutter(error: Error) {
    
        if let sink = self.eventSink{
        
            sink(self.createResult(type: .error, data: "String(describing: error)"))
    
        }
        
    }
    
    //一般输出（例如连接成功等）
    func sendCommonDesToFlutter(type: ResultType,des: String){
        if let sink = self.eventSink{
            
            sink(self.createResult(type: type, data: des))
        
        }
    }
    
    
    func createResult(type:ResultType,data:Any)->Dictionary<String, Any>{
        
        return ["type":type.rawValue,"data":data]
        
    }
    
}
