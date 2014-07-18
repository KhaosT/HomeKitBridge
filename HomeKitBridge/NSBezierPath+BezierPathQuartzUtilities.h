//
//  NSBezierPath+BezierPathQuartzUtilities.h
//  MiniLoader
//
//  Created by Khaos Tian on 5/4/14.
//  Copyright (c) 2014 Punch Through. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (BezierPathQuartzUtilities)

- (CGPathRef)quartzPath;

@end
