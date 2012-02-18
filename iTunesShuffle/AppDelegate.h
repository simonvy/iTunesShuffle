//
//  AppDelegate.h
//  iTunesShuffle
//
//  Created by Qian Tao on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
    NSArray *choices;
    // cache the tracks and only update the track when timer the triggers or when iTunes is not running when active this app.
    NSArray *tracks;
    NSTimer *timer;
}

@property (assign) IBOutlet NSWindow *window;

- (void)shuffleTrack: (id)sender;
- (void)play: (id)sender;
- (void)updateTracks: (id)sender;

@end
