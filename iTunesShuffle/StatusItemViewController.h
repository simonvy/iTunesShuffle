//
//  StatusItemViewController.h
//  iTunesShuffle
//
//  Created by Qian Tao on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusItemView.h"


@interface StatusItemViewController : NSViewController <StatusItemViewDelegate, NSMenuDelegate>

@property (retain) NSStatusItem *statusItem;

@end
