//
//  AppDelegate.m
//  iTunesShuffle
//
//  Created by Qian Tao on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "iTunes.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    tracks = nil;
    // timer will be triggered every 10 minutes
    timer = [NSTimer timerWithTimeInterval:60 * 10 target:self selector:@selector(updateTracks:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
    [self updateTracks: nil];
    
    srand((unsigned int)time(NULL));
    
    NSString *iconPath = [[NSBundle mainBundle] pathForImageResource:@"icon2.png"];
    NSImage *icon = [[NSImage alloc] initByReferencingFile: iconPath];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    CGFloat thickness = [statusBar thickness];
    statusItem = [statusBar statusItemWithLength: NSSquareStatusItemLength];
    icon.size = NSMakeSize(thickness, thickness);
    [statusItem setImage: icon];
    [statusItem setHighlightMode: YES];
    [statusItem setAction: @selector(shuffleTrack:)];
    [statusItem setTarget: self];
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
    
    choices = options;
    
    [statusItem popUpStatusItemMenu: shuffleMenu];
}

- (void) play: (id)sender {
    NSMenuItem *menu = (NSMenuItem *)sender;
    NSUInteger index = [menu.keyEquivalent integerValue];
    iTunesTrack *track = [choices objectAtIndex: index];
    [track playOnce: NO];
}

- (void) updateTracks: (id)sender {
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
    if (iTunes.isRunning) {
        tracks = [iTunes valueForKeyPath:@"sources.@distinctUnionOfArrays.playlists.@distinctUnionOfArrays.tracks"];
    }
}

@end
