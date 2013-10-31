//
//  RecordingViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordingViewController : UIViewController{
    NSString *_toko_id;
}

@property (nonatomic)AVAudioRecorder *recorder;
@property (nonatomic)AVAudioSession *session;
@property (nonatomic)AVAudioPlayer *player;
- (IBAction)button_record_tapped:(id)sender;
- (IBAction)button_play_tapped:(id)sender;
- (IBAction)button_send_tapped:(id)sender;
@property (nonatomic)BOOL flag_end;
@property (nonatomic) NSString *toko_id;

@end
