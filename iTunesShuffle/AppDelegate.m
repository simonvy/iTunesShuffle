//
//  AppDelegate.m
//  iTunesShuffle
//
//  Created by Qian Tao on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "iTunes.h"
#import "StatusItemView.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    tracks = nil;
    // timer will be triggered every 10 minutes
    timer = [NSTimer timerWithTimeInterval:60 * 10 target:self selector:@selector(updateTracks:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
    [self updateTracks: nil];
    
    srand((unsigned int)time(NULL));
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    CGFloat thickness = [statusBar thickness];
    statusItem = [statusBar statusItemWithLength: NSSquareStatusItemLength];

    StatusItemView *view = [[StatusItemView alloc] initWithFrame: NSMakeRect(0, 0, thickness, thickness) withStatusItem: statusItem];
    view.target = self;
    view.action = @selector(shuffleTrack:);
    view.rightAction = @selector(shuffleTrack:);
    [statusItem setView: view];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    [[NSStatusBar systemStatusBar] removeStatusItem: statusItem];
}

- (void) shuffleTrack: (id) sender {    
    NSUInteger numberOfChoice = 10;
    
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
    if (tracks == nil || !iTunes.isRunning) {
        tracks = [iTunes valueForKeyPath:@"sources.@distinctUnionOfArrays.playlists.@distinctUnionOfArrays.tracks"];
    }
    
    NSUInteger total = [tracks count];
    if (total * 0.2 < numberOfChoice) {
        numberOfChoice = (NSUInteger)(total * 0.1);
        if (numberOfChoice == 0 && total != 0) {
            numberOfChoice = 1;
        }
    }
    
    NSUInteger randomTime = 0;
    NSMutableArray *options = [NSMutableArray arrayWithCapacity: numberOfChoice];
    while([options count] < numberOfChoice) {
        if (++randomTime >= numberOfChoice * 10) { // randomly pick at most numberOfChoice * 10 times.
            break;
        }
        NSUInteger i = arc4random() % [tracks count];
        iTunesTrack *track = [tracks objectAtIndex: i];
        
        BOOL duplicate = NO;
        for (iTunesTrack *it in options) {
            if (it.id == track.id) {
                duplicate = YES;
                break;
            }
        }
        
        if (!duplicate) {
            [options addObject: track];
        }
    }
    
    NSMenu *shuffleMenu = [[NSMenu alloc] initWithTitle: @"Shuffle"];
    
    if ([options count] > 0) {
        for (NSUInteger i = 0; i < [options count]; i++) {
            iTunesTrack *track = [options objectAtIndex: i];
            NSString *keyEquiv = [NSString stringWithFormat: @"%lu", i];
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: track.name action: @selector(play:) keyEquivalent: keyEquiv];
            [item setTarget: self];
            [item setEnabled: YES];
            [shuffleMenu addItem: item];
        }
    } else {
        NSMenuItem *item = [NSMenuItem new];
        [item setTitle: NSLocalizedString(@"No track", @"")];
        [shuffleMenu addItem: item];
    }
    
    shuffleMenu.delegate = sender;
    choices = options;
    
    [statusItem popUpStatusItemMenu: shuffleMenu];
}

- (void) play: (id)sender {
    NSMenuItem *menu = (NSMenuItem *)sender;
    NSUInteger index = [menu.keyEquivalent integerValue];
    iTunesTrack *track = [choices objectAtIndex: index];
    [track playOnce: NO];
    if (track.rating <= 95) {
        track.rating = track.rating + 5;
    }
}

- (void) updateTracks: (id)sender {
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
    if (iTunes.isRunning) {
        tracks = [iTunes valueForKeyPath:@"sources.@distinctUnionOfArrays.playlists.@distinctUnionOfArrays.tracks"];
    }
}

@end
