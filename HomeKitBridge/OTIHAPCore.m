//
//  OTIHAPCore.m
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OTIHAPCore.h"

#import "HAKTransportManager.h"
#import "HAKIPTransport.h"
#import "HAKAccessory.h"

#import "HAKNameCharacteristic.h"
#import "HAKModelCharacteristic.h"
#import "HAKManufacturerCharacteristic.h"
#import "HAKSerialNumberCharacteristic.h"
#import "HAKBrightnessCharacteristic.h"
#import "HAKHueCharacteristic.h"
#import "HAKSaturationCharacteristic.h"
#import "HAKOnCharacteristic.h"

#import "HAKLightBulbService.h"


@interface OTIHAPCore (){
    BOOL        _isBridge;
}

@property (strong,nonatomic) HAKTransportManager        *transportManager;
@property (strong,nonatomic) HAKIPTransport             *bridgeTransport;
@property (strong,nonatomic) NSMutableDictionary        *accessories;

@end

@implementation OTIHAPCore

- (id)init {
    self = [super init];
    
    if (self) {
        _accessories = [NSMutableDictionary dictionary];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:[[self homeDataPath] path]])
        {
            _transportManager = [[HAKTransportManager alloc]initWithURL:[self homeDataPath]];
            for (HAKIPTransport *transport in _transportManager.transports) {
                _bridgeTransport = transport;
                if (_bridgeTransport) {
                    NSLog(@"Find Transport");
                    for (HAKAccessory *accessory in _bridgeTransport.accessories) {
                        [_accessories setObject:accessory forKey:accessory.serialNumber];
                    }
                }
            }
            NSLog(@"Restore:%@",_transportManager);
        }else{
            [self setupHAP];
        }
    }
    
    return self;
}

- (NSURL *)homeDataPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportDir = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    appSupportDir = [appSupportDir URLByAppendingPathComponent:@"org.oltica.HomeKitBridge"];
    
    if ([fileManager fileExistsAtPath:[appSupportDir path]] == NO)
    {
        [fileManager createDirectoryAtPath:[appSupportDir path] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return [appSupportDir URLByAppendingPathComponent:@"HomeData.plist"];
}

- (id)initAsBridge:(BOOL)isBridge {
    self = [self init];
    
    if (isBridge) {
        _isBridge = true;
        [self setupBridgeAccessory];
    }
    
    return self;
}

- (void)setupHAP {
    _transportManager = [HAKTransportManager transportManager];
    
    _bridgeTransport = [[HAKIPTransport alloc] init];
    _bridgeTransport.name = @"Hue Bridge";
    
    [_transportManager addTransport:_bridgeTransport];
    
    [_transportManager startAllTransports];
    
    NSLog(@"Finished. Password:%@", _bridgeTransport.password);
    
    [_transportManager writeToURL:[self homeDataPath] atomically:YES];
}

- (void)setupBridgeAccessory {
    HAKAccessory *bridgeAccessory = [[HAKAccessory alloc] init];
    HAKAccessoryInformationService *infoService = [[HAKAccessoryInformationService alloc] init];
    infoService.nameCharacteristic.name = @"Hue Bridge";
    infoService.serialNumberCharacteristic.serialNumber = @"972BB8AF";
    infoService.manufacturerCharacteristic.manufacturer = @"Philips";
    infoService.modelCharacteristic.model = @"Hue Bridge";
    
    bridgeAccessory.accessoryInformationService = infoService;
    [bridgeAccessory addService:infoService];
    
    [self addAccessory:bridgeAccessory];
}

- (HAKAccessory *)addAccessory:(HAKAccessory *)accessory {
    NSLog(@"Add accessory:%@",accessory);
    if (!accessory) {
        return nil;
    }
    
    if (_accessories[accessory.serialNumber] != nil) {
        return _accessories[accessory.serialNumber];
    }
    
    _accessories[accessory.serialNumber] = accessory;
    
    [_bridgeTransport addAccessory:accessory];
    
    [_transportManager writeToURL:[self homeDataPath] atomically:YES];
    
    return accessory;
}

- (HAKAccessory *)createHueAccessoryWithUUID:(NSString *)uuid Name:(NSString *)name {
    NSLog(@"Init Accessory With UUID:%@, name:%@",uuid,name);
    HAKAccessory *hueAccessory = [[HAKAccessory alloc]init];
    
    HAKAccessoryInformationService *infoService = [[HAKAccessoryInformationService alloc] init];
    infoService.nameCharacteristic.name = [name copy];
    infoService.serialNumberCharacteristic.serialNumber = uuid;
    infoService.manufacturerCharacteristic.manufacturer = @"Philips";
    infoService.modelCharacteristic.model = @"Hue 01";
    
    hueAccessory.accessoryInformationService = infoService;
    [hueAccessory addService:infoService];
    [hueAccessory addService:[self setupLightService]];
    
    return hueAccessory;
}

- (HAKService *)setupLightService {  
    HAKLightBulbService *service = [[HAKLightBulbService alloc] init];
    
    service.nameCharacteristic = [[HAKNameCharacteristic alloc] init];
    service.hueCharacteristic = [[HAKHueCharacteristic alloc] init];
    service.brightnessCharacteristic = [[HAKBrightnessCharacteristic alloc] init];
    service.saturationCharacteristic = [[HAKSaturationCharacteristic alloc] init];
    
    HAKNameCharacteristic *name = service.nameCharacteristic;
    name.name = @"Hue Light";
    HAKBrightnessCharacteristic *brightness = service.brightnessCharacteristic;
    brightness.minimumValue = @0;
    brightness.maximumValue = @254;
    HAKHueCharacteristic *hue = service.hueCharacteristic;
    hue.minimumValue = @0;
    hue.maximumValue = @65535;
    HAKSaturationCharacteristic *sat = service.saturationCharacteristic;
    sat.minimumValue = @0;
    sat.maximumValue = @254;
    HAKOnCharacteristic *state = service.onCharacteristic;
    
    [service addCharacteristic:name];
    [service addCharacteristic:brightness];
    [service addCharacteristic:sat];
    [service addCharacteristic:hue];
    [service addCharacteristic:state];
    
    return service;
}

- (NSString *)password {
    return _bridgeTransport.password;
}

@end
