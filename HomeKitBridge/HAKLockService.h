//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <HAPAccessoryKit/HAKService.h>

@class HAKLockedCharacteristic, HAKNameCharacteristic;

@interface HAKLockService : HAKService
{
}

+ (id)identifiers;
@property(retain, nonatomic) HAKNameCharacteristic *nameCharacteristic;
@property(readonly, nonatomic) HAKLockedCharacteristic *lockedCharacteristic;
- (id)init;

@end

