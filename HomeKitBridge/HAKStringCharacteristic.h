//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "HAKCharacteristic.h"

@class NSNumber, NSString;

@interface HAKStringCharacteristic : HAKCharacteristic <NSCopying, NSCoding>
{
    NSNumber *_maximumLength;
}

@property(retain, nonatomic) NSNumber *maximumLength; // @synthesize maximumLength=_maximumLength;
- (id)constraintsDictionaryValue;
@property(retain) NSString *stringValue;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)initWithTypes:(id)arg1;

@end

