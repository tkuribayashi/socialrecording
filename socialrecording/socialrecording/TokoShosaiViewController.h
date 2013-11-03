//
//  TokoShosaiViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TokoShosaiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSString *_toko_id;
}
@property (nonatomic)AVAudioRecorder *recorder;
@property (nonatomic)AVAudioSession *session;
@property (nonatomic)AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UITextView *text_comment;
@property (weak, nonatomic) IBOutlet UILabel *label_genre;
@property (weak, nonatomic) IBOutlet UIButton *button_record;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) UIImage *playing_image;
@property (nonatomic) UIImage *not_playing_image;
- (IBAction)button_recording_tapped:(id)sender;
- (IBAction)like_button_tapped:(id)sender forEvent:(UIEvent *)event;
- (IBAction)button_seiyu_tapped:(id)sender forEvent:(UIEvent *)event;




@property (nonatomic, copy) NSDictionary *toko_data;
@property (nonatomic) NSString *toko_id;
@property (nonatomic) NSString *seiyu_id;
@property (nonatomic) NSMutableArray *voice_data;
@property (nonatomic) BOOL flg_load_record;
@property (nonatomic) int playing_number;@end
