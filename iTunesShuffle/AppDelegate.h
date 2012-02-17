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
}

@property (assign) IBOutlet NSWindow *window;

- (void)shuffleTrack: (id)sender;
- (void)play: (id)sender;

@end
