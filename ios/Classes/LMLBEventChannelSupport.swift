//
//  LMLBEventChannelSupport.swift
//  lblelinkplugin
//
//  Created by yunxiwangluo on 2020/5/14.
//

import UIKit

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
    

    
}
