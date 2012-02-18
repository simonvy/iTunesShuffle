//
//  StatusItemView.h
//  iTunesShuffle
//
//  Created by Qian Tao on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSImageView <NSMenuDelegate> {
    
    id target;
    SEL action;
    SEL rightAction;
    
    NSStatusItem *statusItem;
    BOOL isMenuVisible;
}

- (id) initWithFrame:(NSRect)frameRect withStatusItem: (NSStatusItem *)sitem;

@property (retain) id target;
@property (assign) SEL action;
@property (assign) SEL rightAction;
@property (retain) NSStatusItem *statusItem;

@end
