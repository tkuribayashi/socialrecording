//
//  VoiceCellNoSeiyu.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/24.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceCellNoSeiyu : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIButton *shosai_button;
@property (weak, nonatomic) IBOutlet UIButton *like_button;
@property (weak, nonatomic) IBOutlet UILabel *like_label;
@property (weak, nonatomic) IBOutlet UIImageView *playing_image;

@end
