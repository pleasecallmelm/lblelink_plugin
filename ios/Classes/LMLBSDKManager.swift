//
//  LMLBSDKManager.swift
//  lblelinkplugin
//
//  Created by yunxiwangluo on 2020/5/14.
//

import UIKit
import LBLelinkKit

class LMLBSDKManager: NSObject {
    
    static let shareInstance = LMLBSDKManager()
    //设备搜索类
    
    //初始化乐播sdk
    func initLBSDK(appid: String,secretKey: String){
        
        #if DEBUG
            LBLelinkKit.enableLog(true);
        #else
        
        #endif

        let authResult: Bool = ((try? LBLelinkKit.auth(withAppid: appid, secretKey: secretKey)) != nil)

        if (authResult){
            print("sdk初始化成功")
        }else{
            print("sdk初始化失败")
        }
        
        LBLelinkKit.registerAsInteractiveAdObserver()
        
        self.beginSearchEquipment()
        
    }
    
    //开始搜索设备
    func beginSearchEquipment(){
        
        //点击搜索设备时上报
        LBLelinkBrowser.reportAPPTVButtonAction()
        
        //设置设备搜索代理
        self.linkBrowser.delegate = self;
        //开始搜索设备
        self.linkBrowser.searchForLelinkService()
        
    }
    
    //连接设备
    func linkToService() {
        self.linkConnection.lelinkService = self.services[0]
        self.linkConnection.connect();
        
    }
    
    //断开连接
    func disConnect(){
        self.linkConnection.disConnect();
    }
    
    
//    //开始播放
//    func beginPlay(){
//
//        self.player.lelinkConnection = self.linkConnection;
//
//        let playItem = LBLelinkPlayerItem()
//        playItem.mediaType = .videoOnline;
//        playItem.mediaURLString = ""
//        playItem.startPosition = 0;
//        self.player.play(with: playItem)
//
//    }
    
    // MARK:--------懒加载--------
    
    //设备
    lazy var linkBrowser: LBLelinkBrowser = {
        let a = LBLelinkBrowser()
        a.delegate = self;
        return a
    }()
    
    //连接
    lazy var linkConnection: LBLelinkConnection = {
        let a = LBLelinkConnection()
        a.delegate = self;
        return a
    }()
    
//    //播放器
//    lazy var player: LBLelinkPlayer = {
//        let a = LBLelinkPlayer()
//        a!.delegate = self;
//        return a!
//    }()
    
    //设备列表
    lazy var services: [LBLelinkService] = {
        let a = Array<LBLelinkService>()
        return a;
    }()
    
}

//设备搜索代理
extension LMLBSDKManager: LBLelinkBrowserDelegate{
    
    //搜索列表发生错误回调
    func lelinkBrowser(_ browser: LBLelinkBrowser!, onError error: Error!) {
        
        print("搜索设备发生错误：\(String(describing: error))")
        
        
    }
    
    //设备列表发生变化回调
    func lelinkBrowser(_ browser: LBLelinkBrowser!, didFind services: [LBLelinkService]!) {
        
        self.services = services;
        
    }
    
}

//连接代理
extension LMLBSDKManager: LBLelinkConnectionDelegate{
    
    //连接成功
   func lelinkConnection(_ connection: LBLelinkConnection, didConnectTo service: LBLelinkService) {
       
    print("连接成功");
    
   }

    //连接断开
    func lelinkConnection(_ connection: LBLelinkConnection, disConnectTo service: LBLelinkService) {
        
        print("连接断开");
    }
    
    //连接出错
    func lelinkConnection(_ connection: LBLelinkConnection, onError error: Error) {
        
        print("连接出错");
    }
    
    //收到互动广告
    func lelinkConnection(_ connection: LBLelinkConnection, didReceive adInfo: LBADInfo) {
        
    }
    
}


//extension LMLBSDKManager: LBLelinkPlayerDelegate{
//    
//    //播放状态回调
//    func lelinkPlayer(_ player: LBLelinkPlayer!, playStatus: LBLelinkPlayStatus) {
//        
//    }
//    
//    //播放错误回调
//    func lelinkPlayer(_ player: LBLelinkPlayer!, onError error: Error!) {
//        
//    }
//    
//}
