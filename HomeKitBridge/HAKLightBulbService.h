//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <HAPAccessoryKit/HAKService.h>

@class HAKBrightnessCharacteristic, HAKHueCharacteristic, HAKNameCharacteristic, HAKOnCharacteristic, HAKSaturationCharacteristic;

@interface HAKLightBulbService : HAKService
{
}

+ (id)identifiers;
@property(retain, nonatomic) HAKNameCharacteristic *nameCharacteristic;
@property(retain, nonatomic) HAKSaturationCharacteristic *saturationCharacteristic;
@property(retain, nonatomic) HAKHueCharacteristic *hueCharacteristic;
@property(retain, nonatomic) HAKBrightnessCharacteristic *brightnessCharacteristic;
@property(readonly, nonatomic) HAKOnCharacteristic *onCharacteristic;
- (id)init;

@end

