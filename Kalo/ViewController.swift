//
//  ViewController.swift
//  Kalo
//
//  Created by Mike English on 6/2/14.
//  Copyright (c) 2014 Mike English. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var uuid = NSUUID.UUID().UUIDString
        var client = MQTTClient(clientId: uuid)
        
        func messageHandler(message: MQTTMessage!) {
            NSLog("message received on %@: %@", message.topic, message.payloadString())
        }
        
        client.messageHandler = messageHandler
        
        func completionHandler(code: MQTTConnectionReturnCode) {
            if code.value == ConnectionAccepted.value {
                NSLog("subscribing")
                client.subscribe("callaloo/#", nil)
            }
        }
        
        NSLog("connecting")
        client.connectToHost("localhost", completionHandler)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

