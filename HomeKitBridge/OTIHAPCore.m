//
//  OTIHAPCore.m
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OTIHAPCore.h"

#import "HAKIPTransport.h"
#import "HAKAccessory.h"

#import "HAKAccessoryInformationService.h"
#import "HAKService.h"
#import "HAKCharacteristic.h"
#import "HAKUUID.h"

@interface OTIHAPCore (){
    BOOL        _isBridge;
}

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
            _bridgeTransport = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self homeDataPath] path]];
            if (_bridgeTransport) {
                NSLog(@"Find Transport");
                for (HAKAccessory *accessory in _bridgeTransport.accessories) {
                    [_accessories setObject:accessory forKey:accessory.serialNumber];
                }
            }
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
    
    return [appSupportDir URLByAppendingPathComponent:@"HomeDataV2.plist"];
}

- (id)initAsBridge:(BOOL)isBridge {
    self = [self init];
    
    if (isBridge) {
        _isBridge = true;
        [self setupBridgeAccessory];
    }
    
    return self;
}

- (void)startTransport {
    [_bridgeTransport start];
}

- (void)resetTransportPairings {
    [_bridgeTransport removeAllPairings];
    [_bridgeTransport removeAllConnections];
}

- (void)setupHAP {    
    _bridgeTransport = [[HAKIPTransport alloc] init];
    
    NSLog(@"Finished. Password:%@", _bridgeTransport.password);
}

- (void)setupBridgeAccessory {
    HAKAccessory *bridgeAccessory = [[HAKAccessory alloc] init];
    bridgeAccessory.name = @"Hue Bridge";
    bridgeAccessory.manufacturer = @"Philips";
    bridgeAccessory.serialNumber = @"F7B47CD5EA72";
    bridgeAccessory.model = @"Hue Bridge";
    
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
    
    [NSKeyedArchiver archiveRootObject:_bridgeTransport toFile:[[self homeDataPath] path]];
    
    return accessory;
}

- (HAKAccessory *)createHueAccessoryWithUUID:(NSString *)uuid Name:(NSString *)name {
    NSLog(@"Init Accessory With UUID:%@, name:%@",uuid,name);
    HAKAccessory *hueAccessory = [[HAKAccessory alloc]init];
    hueAccessory.name = name;
    hueAccessory.serialNumber = uuid;
    hueAccessory.manufacturer = @"Philips";
    hueAccessory.model = @"Hue 01";
    
    [hueAccessory addService:[self setupLightService]];
    
    return hueAccessory;
}

- (HAKService *)setupLightService {
    HAKService* lightService = [[HAKService alloc] initWithType:[[HAKUUID alloc] initWithUUIDString:@"00000043"] name:@"Light Control"];
    
    HAKCharacteristic* powerCharacteristic = [lightService characteristicWithType:[[HAKUUID alloc] initWithUUIDString:@"00000025"]];
    HAKCharacteristic* saturationCharacteristic = [[HAKCharacteristic alloc] initWithType:[[HAKUUID alloc] initWithUUIDString:@"0000002F"]];
    HAKCharacteristic* hueCharacteristic = [[HAKCharacteristic alloc] initWithType:[[HAKUUID alloc] initWithUUIDString:@"00000013"]];
    HAKCharacteristic* brightnessCharacteristic = [[HAKCharacteristic alloc] initWithType:[[HAKUUID alloc] initWithUUIDString:@"00000008"]];
    
    powerCharacteristic.value = @0;
    saturationCharacteristic.value = @0;
    hueCharacteristic.value = @0;
    brightnessCharacteristic.value = @0;
    
    [lightService addCharacteristic:hueCharacteristic];
    [lightService addCharacteristic:brightnessCharacteristic];
    [lightService addCharacteristic:saturationCharacteristic];
    
    return lightService;
}

- (NSString *)password {
    return _bridgeTransport.password;
}

@end
