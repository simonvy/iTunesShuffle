//
//  TrackLibrary.m
//  iTunesShuffle
//
//  Created by Qian Tao on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackLibrary.h"
#import "iTunes.h"

@interface TrackLibrary ()

@property (retain) NSArray *tracks;
- (void) updateTracks: (id) sender;

@end

@implementation TrackLibrary

@synthesize tracks = _tracks;

- (id) init
{
    self = [super init];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(updateTracks:) userInfo:nil repeats:YES];
        [self updateTracks: nil];
        srand((unsigned int)time(NULL));
    }
    return self;
}

- (void) updateTracks: (id)sender {
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
    if (iTunes.isRunning) {
        self.tracks = [iTunes valueForKeyPath:@"sources.@distinctUnionOfArrays.playlists.@distinctUnionOfArrays.tracks"];
    }
}

- (NSArray *) randomTracks
{
    NSUInteger numberOfChoice = 10;
    
    NSUInteger total = [self.tracks count];
    if (total * 0.2 < numberOfChoice) {
        numberOfChoice = (NSUInteger)(total * 0.1);
        if (numberOfChoice == 0 && total != 0) {
            numberOfChoice = 1;
        }
    }
    
    NSUInteger randomTime = 0;
    NSMutableArray *options = [NSMutableArray arrayWithCapacity: numberOfChoice];
    while([options count] < numberOfChoice) {
        if (++randomTime >= numberOfChoice * 10) { // randomly pick at most numberOfChoice * 10 times.
            break;
        }
        NSUInteger i = arc4random() % [self.tracks count];
        iTunesTrack *track = [self.tracks objectAtIndex: i];
        
        BOOL duplicate = NO;
        for (iTunesTrack *it in options) {
            if (it.id == track.id) {
                duplicate = YES;
                break;
            }
        }
        
        if (!duplicate) {
            [options addObject: track];
        }
    }
    
    return options;
}

- (void)setTracks:(NSArray *)tracks
{
    _tracks = tracks;
}

- (NSArray *) tracks
{
    if (!_tracks) {
        iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
        _tracks = [iTunes valueForKeyPath:@"sources.@distinctUnionOfArrays.playlists.@distinctUnionOfArrays.tracks"];
    }
    
    return _tracks;
}

@end
