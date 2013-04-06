//
//  StatusItemView.m
//  iTunesShuffle
//
//  Created by Qian Tao on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusItemView.h"

@implementation StatusItemView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self) {
        NSString *iconPath = [[NSBundle mainBundle] pathForImageResource:@"icon2.png"];
        NSImage *icon = [[NSImage alloc] initByReferencingFile: iconPath];
        icon.size = NSMakeSize(frameRect.size.width, frameRect.size.height);
        [self setImage: icon];
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
    if ([self.delegate respondsToSelector:@selector(leftClicked:)]) {
        [self.delegate performSelector:@selector(leftClicked:) withObject: theEvent];
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    if ([self.delegate respondsToSelector:@selector(rightClicked:)]) {
        [self.delegate performSelector:@selector(rightClicked:) withObject:theEvent];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    if ([self.delegate respondsToSelector:@selector(drawStatusItem)]) {
        [self.delegate performSelector:@selector(drawStatusItem)];
    }
    [super drawRect: dirtyRect];
}

@end
