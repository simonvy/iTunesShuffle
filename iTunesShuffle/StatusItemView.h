//
//  StatusItemView.h
//  iTunesShuffle
//
//  Created by Qian Tao on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol StatusItemViewDelegate <NSObject>

- (void) leftClicked: (NSEvent *)e;
- (void) rightClicked: (NSEvent *)e;
- (void) drawStatusItem;

@end


@interface StatusItemView : NSImageView

@property (retain) id<StatusItemViewDelegate> delegate;

@end
