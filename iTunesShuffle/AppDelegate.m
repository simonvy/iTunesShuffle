//
//  AppDelegate.m
//  iTunesShuffle
//
//  Created by Qian Tao on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "StatusItemView.h"
#import "StatusItemViewController.h"

@interface AppDelegate ()

@property (assign) IBOutlet StatusItemViewController *statusItemViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSSquareStatusItemLength];
    
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    StatusItemView *view = [[StatusItemView alloc] initWithFrame: NSMakeRect(0, 0, thickness, thickness)];
    
    self.statusItemViewController.view = view;
    view.delegate = self.statusItemViewController;
    
    
    self.statusItemViewController.statusItem = statusItem;
    
    [statusItem setView: view];
}

- (void) applicationWillTerminate:(NSNotification *)notification
{
    [[NSStatusBar systemStatusBar] removeStatusItem: self.statusItemViewController.statusItem];
}

@end
