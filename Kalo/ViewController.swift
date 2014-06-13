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
        
        //
        // We do our initialization here because it's called when the app view
        // loads.
        //
        
        super.viewDidLoad()
        
        
        //
        // Generate ourselves a unique client identifier and initalize a client
        // object.
        //
        
        var uuid = NSUUID.UUID().UUIDString
        var client = MQTTClient(clientId: uuid)
        
        //
        // Set up a message handler.  This one just logs the MQTT topic and
        // payload string.
        //
        
        client.messageHandler = {(message: MQTTMessage!) in
            NSLog("message received on %@: %@",
                message.topic, message.payloadString())
        }
        
        //
        // Finally, connect (to localhost, in this case.)  Once connected, we'll
        // run an additional closure to subscribe to all topics starting with
        // callaloo/.
        //
        
        NSLog("connecting")
        client.connectToHost("localhost", {(code: MQTTConnectionReturnCode) in
            if code.value == ConnectionAccepted.value {
                NSLog("subscribing")
                client.subscribe("callaloo/#", nil)
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

