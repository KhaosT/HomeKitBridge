//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSKeyedUnarchiver.h"

#import "NSKeyedUnarchiverDelegate.h"

@interface HAKVersionedUnarchiver : NSKeyedUnarchiver <NSKeyedUnarchiverDelegate>
{
    id <NSKeyedUnarchiverDelegate> _relayDelegate;
}

+ (id)forwardingClassTable;
@property(nonatomic) __weak id <NSKeyedUnarchiverDelegate> relayDelegate; // @synthesize relayDelegate=_relayDelegate;
- (void)_setClassVersions;
- (void)_registerForwardingClasses;
- (id)initForReadingWithData:(id)arg1;

@end

