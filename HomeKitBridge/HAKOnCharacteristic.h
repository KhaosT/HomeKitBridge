//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "HAKBoolCharacteristic.h"

#import "HAKVersioning-Protocol.h"

@interface HAKOnCharacteristic : HAKBoolCharacteristic <HAKVersioning>
{
}

+ (id)forwardingClassNames;
+ (unsigned long long)archiveVersion;
+ (id)identifiers;
@property(nonatomic, getter=isOn) BOOL on;
- (id)initWithCoder:(id)arg1;
- (id)init;

@end

