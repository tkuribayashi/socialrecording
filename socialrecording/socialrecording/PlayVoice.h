//
//  PlayVoice.h
//  socialrecording
//
//  Created by taku on 12/2/13.
//  Copyright (c) 2013 taku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayVoice : NSObject


@property (nonatomic)AVAudioRecorder *recorder;
@property (nonatomic)AVAudioSession *session;
@property (nonatomic)AVAudioPlayer *player;

-(void) playVoice:(NSMutableArray *)voice_data :(NSIndexPath *)indexPath;

@end
