//
//  Kalo-Bridging-Header.h
//  Kalo
//
//  Created by Matt Behrens on 6/12/14.
//  Copyright (c) 2014 Mike English. All rights reserved.
//
//  Bridging header for using Objective-C code (e.g. MQTTKit, brought in via
//  CocoaPods.  In here, we're importing header files that Swift code needs.
//  Foundation.h is separately imported because MQTTKit.h uses Foundation
//  items, but doesn't import it itself.
//
//  To use this file, it needs to be configured in the project settings at
//  Build Settings > Swift Compiler - Code Generation > Objective-C Bridging
//  Header.
//

#import <Foundation/Foundation.h>
#import "MQTTKit.h"
