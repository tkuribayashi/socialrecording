//
//  SeiyuShosaiViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/03.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "RetrieveJson.h"

@interface SeiyuShosaiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSString *seiyu_id;
@property (nonatomic) NSString *toko_id;
@property (nonatomic, copy) NSDictionary *toko_data;
@property (nonatomic) NSMutableArray *voice_data;
@property (nonatomic) int playing_number;
@property (nonatomic) UIImage* playing_image;
@property (nonatomic) UIImage* not_playing_image;

@property (nonatomic)AVAudioRecorder *recorder;
@property (nonatomic)AVAudioSession *session;
@property (nonatomic)AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_good;
@property (weak, nonatomic) IBOutlet UILabel *label_voice;
@property (weak, nonatomic) IBOutlet UILabel *label_watch;
@property (weak, nonatomic) IBOutlet UILabel *label_good_rank;
@property (weak, nonatomic) IBOutlet UILabel *label_voice_rank;
@property (weak, nonatomic) IBOutlet UILabel *label_watch_rank;
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)iine_button_tapped:(id)sender forEvent:(UIEvent *)event;
- (IBAction)button_toko_tapped:(id)sender forEvent:(UIEvent *)event;
- (IBAction)button_favo_tapped:(id)sender;

@end
