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

    @IBOutlet var upstairsArrow: UILabel
    @IBOutlet var upstairsStatus: UILabel
    @IBOutlet var downstairsArrow: UILabel
    @IBOutlet var downstairsStatus: UILabel
    @IBOutlet var connectionStatus: UILabel
    
    func updateStatus(arrow: UILabel, label: UILabel, message: String) {
        
        //
        // Dispatch the update to the main thread.  If you don't do this, the
        // labels won't redraw.
        //
        
        dispatch_async(dispatch_get_main_queue()) {
            
            var color: UIColor
            var text: String
            
            switch message {
                
            case "open":
                color = UIColor.greenColor()
                text = "Open"
                
            case "closed":
                color = UIColor.redColor()
                text = "Closed"
                
            default:
                color = UIColor.purpleColor()
                text = "Error"
                
            }
            
            arrow.textColor = color
            label.text = text
            
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
            
            if message.topic {  // check the topic is non-nil
                
                switch message.topic! {
            
                case "callaloo/upstairs":
                    self.updateStatus(self.upstairsArrow,
                        label: self.upstairsStatus, message: status)
                
                case "callaloo/downstairs":
                    self.updateStatus(self.downstairsArrow,
                        label: self.downstairsStatus, message: status)
              
                default:
                    NSLog("don't know how to handle this message")
                    
                }
                
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
                self.connectionStatus.text = "Connected"
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

