//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@import Foundation;

#import "HAKAccessoryDelegate-Protocol.h"
#import "HAKPairingSessionDelegate-Protocol.h"

@interface HAKTransport : NSObject <NSCopying, NSCoding, HAKPairingSessionDelegate, HAKAccessoryDelegate>
{
    NSMutableOrderedSet *_accessories;
    BOOL _started;
    NSString *_name;
    NSString *_username;
    NSString *_password;
    HAKTransportManager *_transportManager;
    unsigned long long _accessoryInstanceID;
    NSObject<OS_dispatch_queue> *_notificationQueue;
}

@property(retain, nonatomic) NSObject<OS_dispatch_queue> *notificationQueue; // @synthesize notificationQueue=_notificationQueue;
@property(nonatomic) unsigned long long accessoryInstanceID; // @synthesize accessoryInstanceID=_accessoryInstanceID;
@property(nonatomic) __weak HAKTransportManager *transportManager; // @synthesize transportManager=_transportManager;
@property(nonatomic, getter=isStarted) BOOL started; // @synthesize started=_started;
@property(copy, nonatomic) NSString *password; // @synthesize password=_password;
@property(copy, nonatomic) NSString *username; // @synthesize username=_username;
@property(copy, nonatomic) NSString *name; // @synthesize name=_name;
@property(retain, nonatomic) NSOrderedSet *accessories; // @synthesize accessories=_accessories;
- (id)accessoryWithInstanceID:(unsigned long long)arg1;
- (void)removeAccessory:(id)arg1;
- (void)addAccessory:(id)arg1;
- (void)stop;
- (void)start;
- (void)accessory:(id)arg1 didUpdateValue:(id)arg2 forCharacteristic:(id)arg3;
- (void)accessory:(id)arg1 didUpdateService:(id)arg2;
- (void)accessory:(id)arg1 didRemoveService:(id)arg2;
- (void)accessory:(id)arg1 didAddService:(id)arg2;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)init;

@end

