//
//  StatusItemViewController.m
//  iTunesShuffle
//
//  Created by Qian Tao on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusItemViewController.h"
#import "TrackLibrary.h"
#import "iTunes.h"

@interface StatusItemViewController ()

@property (readonly, retain) TrackLibrary *trackLibrary;
@property (assign) BOOL isMenuOpen;

@end

@implementation StatusItemViewController

@synthesize trackLibrary = _trackLibrary;
@synthesize statusItem = _statusItem;
@synthesize isMenuOpen = _isMenuOpen;

- (TrackLibrary *)trackLibrary
{
    if (_trackLibrary == nil) {
        _trackLibrary = [TrackLibrary new];
    }
    return _trackLibrary;
}

- (void)leftClicked:(NSEvent *)theEvent
{
    NSMenu *shuffleMenu = [[NSMenu alloc] initWithTitle: @"Shuffle"];
    NSArray *options = self.trackLibrary.randomTracks;
    
    if (options.count > 0) {
        for (NSUInteger i = 0; i < options.count; i++) {
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
    
    shuffleMenu.delegate = self;
    
    [self.statusItem popUpStatusItemMenu: shuffleMenu];
}

- (void)rightClicked:(NSEvent *)theEvent
{
    if (theEvent.modifierFlags & NSCommandKeyMask) {
        // if command + right click, then quit the app
        [NSApp terminate:self];
    } else {
        // pause/play the current track
        iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
        if (iTunes.isRunning) {
            [iTunes playpause];
        }
    }
}

- (void) play: (NSMenuItem *)sender
{
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

- (void)menuWillOpen:(NSMenu *)menu
{
    self.isMenuOpen = YES;
    [self.view setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu
{
    self.isMenuOpen = NO;
    [self.view setNeedsDisplay:YES];
}

- (void)drawStatusItem
{
    [self.statusItem drawStatusBarBackgroundInRect:self.view.bounds withHighlight:self.isMenuOpen];
}

@end
