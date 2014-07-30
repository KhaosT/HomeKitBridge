//
//  HueLight.m
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "HueLight.h"
#import <CommonCrypto/CommonDigest.h>
#import "HAKIdentifyCharacteristic.h"
#import "HAKOnCharacteristic.h"
#import "HAKHueCharacteristic.h"
#import "HAKSaturationCharacteristic.h"
#import "HAKBrightnessCharacteristic.h"

@interface HueLight () {
    HAKOnCharacteristic *_state;
    HAKBrightnessCharacteristic *_brightness;
    HAKHueCharacteristic    *_hue;
    HAKSaturationCharacteristic *_saturation;
    BOOL                        _pendingUpdate;
}

@end

@implementation HueLight

- (id)initWithHAPCore:(OTIHAPCore *)core HueLight:(PHLight *)hueLight {
    
    if (core == nil) {
        return nil;
    }
    
    self = [self init];
    
    if (self) {
        _pendingUpdate = NO;
        _accessoryCore = core;
        _huelight = hueLight;
        _lightAccesory = [_accessoryCore addAccessory:[self getLightAccessoryWithName:_huelight.name]];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(characteristicDidUpdateValueNotification:) name:@"HAKCharacteristicDidUpdateValueNotification" object:nil];
        [self processLightAccessory];
    }
    
    return self;
}

- (void)processLightAccessory {
    for (HAKService *service in _lightAccesory.services) {
        for (HAKCharacteristic *characteristic in service.characteristics) {
            if ([characteristic isKindOfClass:[HAKOnCharacteristic class]]) {
                _state = (HAKOnCharacteristic *)characteristic;
            }
            
            if ([characteristic isKindOfClass:[HAKBrightnessCharacteristic class]]) {
                _brightness = (HAKBrightnessCharacteristic *)characteristic;
            }
            
            if ([characteristic isKindOfClass:[HAKHueCharacteristic class]]) {
                _hue = (HAKHueCharacteristic *)characteristic;
            }
            
            if ([characteristic isKindOfClass:[HAKSaturationCharacteristic class]]) {
                _saturation = (HAKSaturationCharacteristic *)characteristic;
            }
        }
    }
    
    [self updateLightValue];
}

- (void)updateLightValue {
    if (!_pendingUpdate) {
        PHLightState *lightState = _huelight.lightState;
        if (_brightness.brightness != lightState.brightness.longLongValue) {
            _brightness.brightness = lightState.brightness.longLongValue;
        }
        
        if (_hue.hue != lightState.hue.floatValue) {
            _hue.hue = lightState.hue.floatValue;
        }
        
        if (_state.on != lightState.on.boolValue) {
            _state.on = lightState.on.boolValue;
        }
        
        if (_saturation.saturation != lightState.saturation.floatValue) {
            _saturation.saturation = lightState.saturation.floatValue;
        }
    }else{
        _pendingUpdate = NO;
    }
}

- (void)updateLightValueWithLight:(PHLight *)hueLight {
    _huelight = hueLight;
    [self updateLightValue];
}

- (HAKAccessory *)getLightAccessoryWithName:(NSString *)name {
    HAKAccessory *accessory = [_accessoryCore createHueAccessoryWithUUID:[self sha1:name] Name:name];
    return accessory;
}

- (void)characteristicDidUpdateValueNotification:(NSNotification *)aNote {
    PHLightState *currentLightState = _huelight.lightState;
    HAKCharacteristic *characteristic = aNote.object;
    if ([characteristic.service.accessory isEqual:_lightAccesory]) {
        if ([characteristic isKindOfClass:[HAKIdentifyCharacteristic class]]) {
            id value = aNote.userInfo[@"HAKCharacteristicValueKey"];
            if ([value isKindOfClass:[NSNumber class]]) {
                if ([value isEqualToNumber: @1]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        PHLightState *lightState = [[PHLightState alloc] init];
                        [lightState setAlert:ALERT_LSELECT];
                        [currentLightState setAlert:ALERT_LSELECT];
                        [[[[PHOverallFactory alloc] init] bridgeSendAPI] updateLightStateForId:_huelight.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                            if (errors) {
                                NSLog(@"ERROR:%@",errors);
                            }
                        }];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        PHLightState *lightState = [[PHLightState alloc] init];
                        [lightState setAlert:ALERT_NONE];
                        [currentLightState setAlert:ALERT_NONE];
                        [[[[PHOverallFactory alloc] init] bridgeSendAPI] updateLightStateForId:_huelight.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                            if (errors) {
                                NSLog(@"ERROR:%@",errors);
                            }
                        }];
                    });
                }
            }
        }
        if ([characteristic isKindOfClass:[HAKOnCharacteristic class]]) {
            id value = aNote.userInfo[@"HAKCharacteristicValueKey"];
            if ([value isKindOfClass:[NSNumber class]]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (![currentLightState.on isEqualToNumber:value]) {
                        NSLog(@"UpdateOn:%@",value);
                        _pendingUpdate = YES;
                        PHLightState *lightState = [[PHLightState alloc] init];
                        [lightState setOn:value];
                        [currentLightState setOn:value];
                        [[[[PHOverallFactory alloc] init] bridgeSendAPI] updateLightStateForId:_huelight.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                            if (errors) {
                                NSLog(@"ERROR:%@",errors);
                            }
                        }];
                    }
                });
            }
        }
        if ([characteristic isKindOfClass:[HAKHueCharacteristic class]]) {
            id value = aNote.userInfo[@"HAKCharacteristicValueKey"];
            if ([value isKindOfClass:[NSNumber class]]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (![currentLightState.hue isEqualToNumber:value]) {
                        NSLog(@"UpdateHue:%@",value);
                        _pendingUpdate = YES;
                        PHLightState *lightState = [[PHLightState alloc] init];
                        
                        [lightState setHue:value];
                        [currentLightState setHue:value];
                        [[[[PHOverallFactory alloc] init] bridgeSendAPI] updateLightStateForId:_huelight.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                            if (errors) {
                                NSLog(@"ERROR:%@",errors);
                            }
                        }];
                    }
                });
            }
        }
        if ([characteristic isKindOfClass:[HAKSaturationCharacteristic class]]) {
            id value = aNote.userInfo[@"HAKCharacteristicValueKey"];
            if ([value isKindOfClass:[NSNumber class]]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (![currentLightState.saturation isEqualToNumber:value]) {
                        NSLog(@"UpdateSaturation:%@",value);
                        _pendingUpdate = YES;
                        PHLightState *lightState = [[PHLightState alloc] init];
                        [lightState setSaturation:value];
                        [currentLightState setSaturation:value];
                        [[[[PHOverallFactory alloc] init] bridgeSendAPI] updateLightStateForId:_huelight.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                            if (errors) {
                                NSLog(@"ERROR:%@",errors);
                            }
                        }];
                    }
                });
            }
        }
        if ([characteristic isKindOfClass:[HAKBrightnessCharacteristic class]]) {
            id value = aNote.userInfo[@"HAKCharacteristicValueKey"];
            if ([value isKindOfClass:[NSNumber class]]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (![currentLightState.brightness isEqualToNumber:value]) {
                        NSLog(@"UpdateBrightness:%@",value);
                        _pendingUpdate = YES;
                        PHLightState *lightState = [[PHLightState alloc] init];
                        [lightState setBrightness:value];
                        [currentLightState setBrightness:value];
                        [[[[PHOverallFactory alloc] init] bridgeSendAPI] updateLightStateForId:_huelight.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                            if (errors) {
                                NSLog(@"ERROR:%@",errors);
                            }
                        }];
                    }
                });
            }
        }
    }
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

@end
