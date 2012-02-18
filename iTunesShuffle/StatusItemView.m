//
//  StatusItemView.m
//  iTunesShuffle
//
//  Created by Qian Tao on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusItemView.h"
#import "iTunes.h"

@implementation StatusItemView

@synthesize target;
@synthesize action;
@synthesize rightAction;
@synthesize statusItem;

- (id)initWithFrame:(NSRect)frame withStatusItem: (NSStatusItem *) sitem {
    self = [super initWithFrame:frame];
    
    if (self) {
        isMenuVisible = NO;
        self.statusItem = sitem;
        NSString *iconPath = [[NSBundle mainBundle] pathForImageResource:@"icon2.png"];
        NSImage *icon = [[NSImage alloc] initByReferencingFile: iconPath];
        icon.size = NSMakeSize(frame.size.width, frame.size.height);
        [self setImage: icon];
    }
    
    return self;
}

- (void) drawRect:(NSRect)dirtyRect {
    [self.statusItem drawStatusBarBackgroundInRect:self.bounds withHighlight: isMenuVisible];
    [super drawRect: dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [NSApp sendAction: self.action to: self.target from: self];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
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

- (void) menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay];
}

- (void) menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [self setNeedsDisplay];
}


@end
