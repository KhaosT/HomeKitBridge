//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class NSMutableArray;

@interface HAKTLV8Container : NSObject
{
    NSMutableArray *_packets;
}

- (void).cxx_destruct;
- (id)numberForType:(unsigned char)arg1;
- (void)setNumber:(id)arg1 forType:(unsigned char)arg2;
- (unsigned long long)sizeOfNumber:(id)arg1;
- (id)stringForType:(unsigned char)arg1;
- (void)setString:(id)arg1 forType:(unsigned char)arg2;
- (id)dataForType:(unsigned char)arg1;
- (void)setData:(id)arg1 forType:(unsigned char)arg2;
- (id)serialize;
- (void)addPacketsWithData:(id)arg1;
- (void)removePacketsWithType:(unsigned char)arg1;
- (id)description;
- (id)initWithData:(id)arg1;
- (id)init;

@end

