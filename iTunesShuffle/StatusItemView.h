//
//  StatusItemView.h
//  iTunesShuffle
//
//  Created by Qian Tao on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSImageView <NSMenuDelegate> {
    
    BOOL isMenuVisible;
}

- (id) initWithFrame:(NSRect)frameRect withStatusItem: (NSStatusItem *)sitem;

@property (assign) SEL rightAction;
@property (retain) NSStatusItem *statusItem;

@end
