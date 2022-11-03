//
//  PlayerView.swift
//  Runner
//
//  Created by Obi Tec on 03/11/22.
//

import Foundation
import Flutter
import AVFoundation
import UIKit
import AVKit
import MediaPlayer

class PlayerView : NSObject, FlutterPlatformView, FlutterStreamHandler{
    private var _view: UIView
    var eventSink : FlutterEventSink?
    var player : AVPlayer?
    var playerItem : AVPlayerItem?
    var playerViewController: AVPlayerViewController?
    var TimeObserveToken : Any?
    let methodChannelName = "playerChannelTag"
    let eventChannelName = "playerListenerChannelTag"
    let timerToSendCurrentTime = 0.5
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessanger messanger : FlutterBinaryMessenger?){
        _view = UIView()
        super.init()
        self.player = AVPlayer()
        self.playerViewController = AVPlayerViewController()
        let eventChannel = FlutterEventChannel(name : eventChannelName, binaryMessenger:  messanger!)
        let methodChannel = FlutterMethodChannel(name : methodChannelName, binaryMessenger:  messanger!)
        eventChannel.setStreamHandler(self)
        methodChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result : FlutterResult) -> Void in
            switch call.method{
            case "initPlayer":
                guard let args = call.arguments as? [String:Any] else{return}
                let mediaUrl = URL(string :args["mediaUrl"] as! String)
                let playerItem : AVPlayerItem = AVPlayerItem(url: mediaUrl!)
                self?.playerItem = playerItem
                self?.player? = AVPlayer(playerItem: self?.playerItem)
                self?.playerBuildInterface()
                self?.addObservers()
                result(true)
            case "pause":
                self?.player?.pause()
                result(true)

            case "play":
                self?.player?.play()
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func view() -> UIView {
        return _view
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func playerBuildInterface(){
        self.playerViewController!.player = self.player
        self.playerViewController!.videoGravity = .resizeAspect
        self.playerViewController!.showsPlaybackControls = false
        self._view.addSubview((self.playerViewController?.view)!)
        self.playerViewController!.view.frame = self._view.frame
    }
    
    private func sendEvent(value : Dictionary<String,Any?>){
        guard let eventSink = self.eventSink else {
            return
        }
        eventSink(value)

    }
    
    func addPeriodicTimeObserver(){
        let timeScaleSec = CMTimeScale(NSEC_PER_SEC)
        let  time = CMTime(seconds : timerToSendCurrentTime,preferredTimescale: timeScaleSec)
        TimeObserveToken = player?.addPeriodicTimeObserver(forInterval:time, queue:.main){
            [weak self] time in if(self?.player?.timeControlStatus != .paused){
                self?.sendEvent(value: ["PlayerEvent" : "isPlaying","currentTime" : String(self!.player!.currentTime().value/Int64(timeScaleSec))])
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath{
        case "status":
            if(player?.currentItem?.status == AVPlayerItem.Status.readyToPlay){
                self.sendEvent(value: ["PlayerEvent" : "isReady","duration" : String((player!.currentItem!.duration.value)/1000)])
            }
        default:
            break
        }
        
    }
    
    func addObservers(){
        self.addPeriodicTimeObserver()
        self.player?.currentItem?.addObserver(self,forKeyPath: "status",options :NSKeyValueObservingOptions.new,context: nil)
    }
}
    

