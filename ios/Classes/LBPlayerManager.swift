//
//  LBPlayerManager.swift
//  lblelinkplugin
//
//  Created by yunxiwangluo on 2020/5/14.
//

import UIKit
import LBLelinkKit

class LBPlayerManager: NSObject {
    
    static let shareInstance = LBPlayerManager()
    
    //开始播放
    func beginPlay(connection: LBLelinkConnection,playUrl: String){
       
       self.player.lelinkConnection = connection;
       
       let playItem = LBLelinkPlayerItem()
       playItem.mediaType = .videoOnline;
       playItem.mediaURLString = playUrl
       playItem.startPosition = 0;
       self.player.play(with: playItem)
       
   }
    
    //暂停
    func pause(){
        self.player.pause()
    }
    
    //继续播放
    func resumePlay(){
        self.player.resumePlay()
    }
    
    //退出播放
    func stop(){
        self.player.stop()
    }
    
    //增加音量
    func addVolume(){
        self.player.addVolume()
    }
    
    //减小音量
    func reduceVolume(){
        self.player.reduceVolume()
    }
    
    
   // MARK:--------懒加载--------
   //播放器
   lazy var player: LBLelinkPlayer = {
       let a = LBLelinkPlayer()
       a!.delegate = self;
       return a!
   }()

}

extension LBPlayerManager: LBLelinkPlayerDelegate{
    
    //播放状态回调
    func lelinkPlayer(_ player: LBLelinkPlayer!, playStatus: LBLelinkPlayStatus) {
        
    }
    
    //播放错误回调
    func lelinkPlayer(_ player: LBLelinkPlayer!, onError error: Error!) {
        
    }
    
}
