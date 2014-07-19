//
//  AppDelegate.m
//  HomeKitBridge
//
//  Created by Khaos Tian on 7/18/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "AppDelegate.h"
#import "OTIContentController.h"
#import "OTIHAPCore.h"
#import "SimpleHue.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong,nonatomic) OTIContentController *contentController;
@property (strong,nonatomic) OTIHAPCore           *accessoryCore;
@property (strong,nonatomic) SimpleHue            *hueController;

@property (weak) IBOutlet NSTextField *passwordLabel;
@property (weak) IBOutlet NSButton *closeButton;
@property (weak) IBOutlet NSView *contentView;

- (IBAction)closeApp:(id)sender;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _accessoryCore = [[OTIHAPCore alloc]initAsBridge:YES];
    
    _contentController = [[OTIContentController alloc]init];
    _contentController.view = _contentView;
    
    _closeButton.layer = [CALayer layer];
    _closeButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
    _closeButton.wantsLayer = YES;
    
    _passwordLabel.stringValue = _accessoryCore.password;
    _passwordLabel.wantsLayer = YES;
    _passwordLabel.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    _hueController = [[SimpleHue alloc]init];
    _hueController.accessoryCore = _accessoryCore;
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)closeApp:(id)sender {
    [[NSApplication sharedApplication] hide:self];
}

@end
