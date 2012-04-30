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
#import "TrackLibrary.h"

@interface AppDelegate ()

@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) TrackLibrary *trackLibrary;

- (void)shuffleTrack: (id)sender;
- (void)play: (NSMenuItem *)sender;


@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize trackLibrary = _trackLibrary;
@synthesize statusItem = _statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    NSRect frame = NSMakeRect(0, 0, thickness, thickness);
    
    StatusItemView *view = [[StatusItemView alloc] initWithFrame: frame withStatusItem: self.statusItem];
    view.target = self;
    view.action = @selector(shuffleTrack:);
    view.rightAction = @selector(shuffleTrack:);
    [self.statusItem setView: view];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    [[NSStatusBar systemStatusBar] removeStatusItem: self.statusItem];
}

- (void) shuffleTrack: (id) sender {    
    NSMenu *shuffleMenu = [[NSMenu alloc] initWithTitle: @"Shuffle"];
    NSArray *options = [self.trackLibrary getRandomTracks];
    
    if ([options count] > 0) {
        for (NSUInteger i = 0; i < [options count]; i++) {
            iTunesTrack *track = [options objectAtIndex: i];
            NSString *keyEquiv = [NSString stringWithFormat: @"%lu", i];
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: track.name action: @selector(play:) keyEquivalent: keyEquiv];
            [item setTarget: self];
            [item setEnabled: YES];
            item.representedObject = track;
            [shuffleMenu addItem: item];
        }
    } else {
        NSMenuItem *item = [NSMenuItem new];
        [item setTitle: NSLocalizedString(@"No track", @"")];
        [shuffleMenu addItem: item];
    }
    
    shuffleMenu.delegate = sender;
    
    [self.statusItem popUpStatusItemMenu: shuffleMenu];
}

- (void) play: (NSMenuItem *)sender {
    iTunesTrack *track = (iTunesTrack *)sender.representedObject;
    [track playOnce: NO];
    
    // increase the rating.
    NSInteger oldRating = track.rating;
    NSInteger newRating = oldRating + 5;
    
    if (newRating > 100) {
        newRating = 100;
    }
    
    if (oldRating != newRating) {
        track.rating = newRating;
    }
}

- (TrackLibrary *) trackLibrary
{
    if (!_trackLibrary) {
        self.trackLibrary = [TrackLibrary new];
    }
    return _trackLibrary;
}

- (NSStatusItem *) statusItem
{
    if (!_statusItem) {
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSSquareStatusItemLength]; 
    }
    return _statusItem;
}

@end
