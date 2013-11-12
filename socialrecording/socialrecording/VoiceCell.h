//
//  VoiceCell.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/12.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIButton *shosai_button;
@property (weak, nonatomic) IBOutlet UIButton *like_button;
@property (weak, nonatomic) IBOutlet UIImageView *playing_image;
@property (weak, nonatomic) IBOutlet UILabel *like_label;
@property (weak, nonatomic) IBOutlet UILabel *seiyu_label;
@end
