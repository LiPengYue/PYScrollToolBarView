//
//  NSObectEventTransmit+Extension.swift
//  PYSwift
//
//  Created by 李鹏跃 on 2017/11/15.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

import UIKit

extension NSObject {
    
    typealias EVENTCALLBACKBLOCK = (_ signalKey: String, _ messageObj: Any)->(Any)?
    struct NSObectEventTransmitExtension {
        static let EVENTCALLBACKBLOCKKEY = UnsafeRawPointer.init(bitPattern:"EVENTCALLBACKBLOCKKEY".hashValue)
        static let MODELKEY = UnsafeRawPointer.init(bitPattern:"MODELKEY".hashValue)
    }
    
    ///** 上级 的对象对下级对象事件处理注册，
    ///即： 这里可以拿到下级对象发出的消息
    func receivedSignalFunc(eventCallBack: @escaping EVENTCALLBACKBLOCK) {
        objc_setAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY, eventCallBack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @discardableResult
    public func sendSignalFunc (signalKey SignalKey: String, message Message: Any) -> (Any)? {
        var eventBlock: EVENTCALLBACKBLOCK? = objc_getAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY) as? EVENTCALLBACKBLOCK
        if (eventBlock == nil) {
            eventBlock = {(SignalKey, Message) -> (Any)? in
                print("\(self)暂时没有,注册对赢得block，请检查，你想传传递的信息为： \n\n: SignalKey: \(SignalKey)\n\n,Message: \(Message)")
            }
        }
        print("👌\(self):\(SignalKey)")
        return eventBlock!(SignalKey,Message) as (Any)?
    }
    
    ///快速通道
    func stitchChannelFunc(sender Sender: NSObject?) {
        if Sender == nil {
            print("🌶：：sender为你nil\(self)")
            return
        }
        Sender!.receivedSignalFunc { (signalKey, message) -> (Any)? in
            return self.sendSignalFunc(signalKey: signalKey, message: message)
        }
    }
    
    /// 发送一条消息
    ///
    /// - Parameters:
    ///   - SignalKey: 区别信号的key
    ///   - Message: 传输的信息
    /// - Returns: 返回的信息，可以为nil
    @discardableResult
    public func sendSignalFunc<T,R>(signalKey SignalKey: String, message Message:T) -> (R) {
        var eventBlock: EVENTCALLBACKBLOCK? = objc_getAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY) as? EVENTCALLBACKBLOCK
        if (eventBlock == nil) {
            eventBlock = {[weak self](SignalKey, Message) -> (R)? in
                print("\(String(describing: self))暂时没有,注册对赢得block，请检查，你想传传递的信息为： \n\n: SignalKey: \(SignalKey)\n\n,Message: \(Message)" as Any)
                return nil
            }
        }
        print("👌\(self):\(SignalKey)")
        return eventBlock!(SignalKey,Message) as! (R)
    }
    
    func eceivedSignalFunc(eventCallBack: @escaping EVENTCALLBACKBLOCK) {
        objc_setAssociatedObject(self, NSObectEventTransmitExtension.EVENTCALLBACKBLOCKKEY, eventCallBack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    ///储存数据的model
    var modelObj: Any {
        get {
            return objc_getAssociatedObject(self, NSObectEventTransmitExtension.MODELKEY)
        }set {
            objc_setAssociatedObject(self, NSObectEventTransmitExtension.MODELKEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

