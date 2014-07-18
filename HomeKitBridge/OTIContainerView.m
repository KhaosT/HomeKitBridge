//
//  OTIContainerView.m
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OTIContainerView.h"

@implementation OTIContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    // Clear the drawing rect.
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
    
    NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: 4 yRadius: 4];
    [[NSColor whiteColor] setFill];
    [roundedRectanglePath fill];
}

@end
