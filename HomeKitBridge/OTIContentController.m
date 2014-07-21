//
//  OTIContentController.m
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OTIContentController.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"
#import <Quartz/Quartz.h>

#import "HAKTransportManager.h"
#import "HAKIPTransport.h"
#import "HAKAccessory.h"

#import "HAKNameCharacteristic.h"
#import "HAKIdentifyCharacteristic.h"
#import "HAKBrightnessCharacteristic.h"
#import "HAKHueCharacteristic.h"
#import "HAKSaturationCharacteristic.h"
#import "HAKOnCharacteristic.h"

#import "HAKKeychainService.h"
#import <HueSDK_OSX/HueSDK.h>

@interface OTIContentController () {
    
}

@end

@implementation OTIContentController

- (id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(characteristicDidUpdateValueNotification:) name:@"HAKCharacteristicDidUpdateValueNotification" object:nil];
        
        [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(authenticationSuccess) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION];
        [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(buttonNotPressed:) forNotification:PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION];
    }
    
    return self;
}

- (void)authenticationSuccess {
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
}

- (void)buttonNotPressed:(NSNotification *)notification {
    NSLog(@"Press the button on the bridge to finish the setup.");
}

- (void)addIdentifyAnimation
{
    CGFloat radius = 300;
    
    NSBezierPath *ovalPath = [NSBezierPath bezierPathWithOvalInRect:CGRectMake((radius/2)*(-1), (radius/2)*(-1), radius, radius)];
    
    CAShapeLayer *backgroundShape = [[CAShapeLayer alloc]init];
    backgroundShape.path = ovalPath.quartzPath;
    backgroundShape.position = CGPointMake(self.view.frame.size.width / 2.0,self.view.frame.size.height / 2.0);
    
    backgroundShape.fillColor = [NSColor clearColor].CGColor;
    backgroundShape.strokeColor = [NSColor colorWithHue:0.552 saturation:0.78 brightness:0.99 alpha:1.0].CGColor;
    
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1;
    animationGroup.repeatCount = 3;
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = 1;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1;
    opacityAnimation.values = @[@1.0, @0.85, @0.45, @0];
    opacityAnimation.keyTimes = @[@0, @0.6, @0.8, @1];
    opacityAnimation.removedOnCompletion = YES;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    animationGroup.animations = animations;
    animationGroup.delegate = self;
    
    [self.view.layer addSublayer:backgroundShape];
    [backgroundShape addAnimation:animationGroup forKey:@"ZoomOutScan"];
}

- (void)characteristicDidUpdateValueNotification:(NSNotification *)aNote {
    HAKCharacteristic *characteristic = aNote.object;
    if ([characteristic isKindOfClass:[HAKIdentifyCharacteristic class]]) {
        id value = aNote.userInfo[@"HAKCharacteristicValueKey"];
        if ([value isKindOfClass:[NSNumber class]]) {
            if ([value isEqualToNumber: @1]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addIdentifyAnimation];
                });
            }
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.view.layer.sublayers = nil;
}

@end
