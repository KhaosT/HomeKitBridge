//
//  HueLight.h
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSColor.h>
#import <HueSDK_OSX/HueSDK.h>
#import "HAKAccessory.h"
#import "OTIHAPCore.h"

@interface HueLight : NSObject

@property (nonatomic,weak)   OTIHAPCore *accessoryCore;
@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) HAKAccessory *lightAccesory;
@property (nonatomic,strong) PHLight *huelight;

- (id)initWithHAPCore:(OTIHAPCore *)core HueLight:(PHLight *)hueLight;
- (void)updateLightValue;
- (void)updateLightValueWithLight:(PHLight *)hueLight;

@end
