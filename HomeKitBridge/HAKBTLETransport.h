//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "HAKTransport.h"

#import "CBPeripheralManagerDelegate.h"

@class CBPeripheralManager, HAKPairingService, NSMapTable, NSString;

@interface HAKBTLETransport : HAKTransport <CBPeripheralManagerDelegate>
{
    CBPeripheralManager *_peripheralManager;
    HAKPairingService *_pairingService;
    NSMapTable *_cbServices;
    NSMapTable *_pendingReadRequests;
}

+ (unsigned long long)maxSupportedAccessories;
@property(retain, nonatomic) NSMapTable *pendingReadRequests; // @synthesize pendingReadRequests=_pendingReadRequests;
@property(retain, nonatomic, setter=setCBServices:) NSMapTable *cbServices; // @synthesize cbServices=_cbServices;
@property(retain, nonatomic) HAKPairingService *pairingService; // @synthesize pairingService=_pairingService;
@property(retain, nonatomic) CBPeripheralManager *peripheralManager; // @synthesize peripheralManager=_peripheralManager;
- (id)_connectionForCentral:(id)arg1;
- (id)_characteristicForCBCharacteristic:(id)arg1;
- (void)_addCBServices;
- (void)_removeService:(id)arg1;
- (void)_addService:(id)arg1;
- (void)_startAdvertising;
- (id)_advertisementData;
- (unsigned long long)type;
- (BOOL)updateValue:(id)arg1 forCharacteristic:(id)arg2 onSubscribedConnections:(id)arg3;
- (void)stop;
- (void)start;
- (void)accessory:(id)arg1 didUpdateService:(id)arg2;
- (void)accessory:(id)arg1 didRemoveService:(id)arg2;
- (void)accessory:(id)arg1 didAddService:(id)arg2;
- (void)peripheralManager:(id)arg1 didReceiveWriteRequests:(id)arg2;
- (void)peripheralManager:(id)arg1 didReceiveReadRequest:(id)arg2;
- (void)peripheralManager:(id)arg1 central:(id)arg2 didUnsubscribeFromCharacteristic:(id)arg3;
- (void)peripheralManager:(id)arg1 central:(id)arg2 didSubscribeToCharacteristic:(id)arg3;
- (void)peripheralManagerDidStartAdvertising:(id)arg1 error:(id)arg2;
- (void)peripheralManagerDidUpdateState:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)init;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

