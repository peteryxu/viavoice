//
//  MQTTSwift.swift
//  MQTTSwift
//
//  Created by Christoph Krey on 23.05.16.
//  Copyright © 2016 OwnTracks. All rights reserved.
//

import MQTTClient
import Foundation

class MQTTSwift: NSObject, MQTTSessionDelegate  {
    var sessionConnected = false;
    var sessionError = false;
    var sessionReceived = false;
    var sessionSubAcked = false;
    var session : MQTTSession?;

    func connect() {
        session = MQTTSession();
        session!.delegate = self;
        
        
        let clientId = "d:dgpgip:ViaVoice:viavoice1"
        let useName  = "use-token-auth"
        let password = "XY1lhylh"
        let host = "dgpgip.messaging.internetofthings.ibmcloud.com"
        
        session = MQTTSession(
            clientId: clientId,
            userName: useName,
            password: password,
            keepAlive: 3000,
            cleanSession: true,
            will: false,
            willTopic: nil,
            willMsg: nil,
            willQoS: .AtMostOnce,
            willRetainFlag: false,
            protocolLevel: 4,
            runLoop: nil,
            forMode: nil
        )


        session!.connectToHost(host,
                               port:1883,
                               usingSSL: false);
        
        print("connected ... hopefully ")
        
        session!.subscribeToTopic("iot-2/cmd/#/fmt/json", atLevel: .AtMostOnce)
        
        print("subcribed ... hopefully ")
        
       /* while !sessionConnected  {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
        }
        

       session!.subscribeToTopic("iot-2/cmd/command_id/fmt/format_string", atLevel: .AtMostOnce)

        while sessionConnected && !sessionError && !sessionSubAcked {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
        }

        session!.publishData("sent from Xcode using Swift".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                             onTopic: "MQTTSwift",
                             retain: false,
                             qos: .AtMostOnce)

        while sessionConnected && !sessionError && !sessionReceived {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
        }

        session!.close() */
        
    }
    
    func publish(message: String, topic: String){
        session!.publishData(message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                             onTopic: topic,
                             retain: false,
                             qos: .AtMostOnce)
        print("publish message")
        
    }

    func handleEvent(session: MQTTSession!, event eventCode: MQTTSessionEvent, error: NSError!) {
        switch eventCode {
        case .Connected:
            sessionConnected = true
            print("session Connected")
        case .ConnectionClosed:
            sessionConnected = false
            print("session Closed")
        default:
            sessionError = true
        }
    }

    func newMessage(session: MQTTSession!, data: NSData!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        print("Received \(data) on:\(topic) q\(qos) r\(retained) m\(mid)")
        sessionReceived = true;
    }

func subAckReceived(session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        print("Session SubAcked")
        sessionSubAcked = true;
    }

}
