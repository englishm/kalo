//
//  ViewController.swift
//  Kalo
//
//  Created by Mike English on 6/2/14.
//  Copyright (c) 2014 Mike English. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //
    // These outlets allow us to connect the status text to the view in the
    // storyboard.
    //
    
    @IBOutlet var upstairsStatus: UILabel
    @IBOutlet var downstairsStatus: UILabel
    
    func updateStatus(label: UILabel, message: String) {
        
        //
        // Dispatch the update to the main thread.  If you don't do this, the
        // labels won't redraw.
        //
        
        dispatch_async(dispatch_get_main_queue()) {
            
            switch message {
                
            case "open":
                label.textColor = UIColor.greenColor()
                label.text = "Open"
                
            case "closed":
                label.textColor = UIColor.redColor()
                label.text = "Closed"
                
            default:
                label.textColor = UIColor.yellowColor()
                label.text = "Error"
                
            }
            
        }
        
    }
                            
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
            
            var status = message.payloadString()
            NSLog("message received on %@: %@", message.topic, status)
            
            switch message.topic! {
            
            case "callaloo/upstairs":
                self.updateStatus(self.upstairsStatus, message: status)
                
            case "callaloo/downstairs":
                self.updateStatus(self.downstairsStatus, message: status)
              
            default:
                NSLog("don't know how to handle this message")
            }
            
        }
        
        //
        // Finally, connect (to localhost, in this case.)  Once connected, we'll
        // run an additional closure to subscribe to all topics starting with
        // callaloo/.
        //
        
        NSLog("connecting")
        client.connectToHost("localhost", {(code: MQTTConnectionReturnCode) in
            if code.value == ConnectionAccepted.value {
                NSLog("connected; subscribing")
                client.subscribe("callaloo/#", nil)
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

