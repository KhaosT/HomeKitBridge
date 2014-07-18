//
//  SimpleHue.h
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTIHAPCore.h"

@interface SimpleHue : NSObject

@property (nonatomic,weak) OTIHAPCore *accessoryCore;

- (void)startSearch;

@end
