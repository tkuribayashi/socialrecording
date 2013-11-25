//
//  MyPageViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/11.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"
#import "MypageTokoCell.h"
#import "VoiceCell.h"
#import "VoiceCellNoSeiyu.h"
#import "SeiyuCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "RetrieveJson.h"

@interface MyPageViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) int playing_number;
@property (nonatomic) UIImage * playing_image;
@property (nonatomic) UIImage * not_playing_image;
@property (nonatomic)AVAudioRecorder *recorder;
@property (nonatomic)AVAudioSession *session;
@property (nonatomic)AVAudioPlayer *player;
@property (nonatomic,copy) NSDictionary *toko_data;
@property (nonatomic)NSArray *contents;
@property (nonatomic) NSString * toko_id;
@property (nonatomic) NSString * seiyu_id;
@property (nonatomic)int current_page;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_title;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_content;

@end
