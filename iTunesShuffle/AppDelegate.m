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
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    NSRect frame = NSMakeRect(0, 0, thickness, thickness);
    
    StatusItemView *view = [[StatusItemView alloc] initWithFrame: frame];
    
    self.statusItemViewController.view = view;
    view.delegate = self.statusItemViewController;
    
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSSquareStatusItemLength];
    self.statusItemViewController.statusItem = statusItem;
    
    [statusItem setView: view];
}

- (void) applicationWillTerminate:(NSNotification *)notification
{
    [[NSStatusBar systemStatusBar] removeStatusItem: self.statusItemViewController.statusItem];
}

@end
