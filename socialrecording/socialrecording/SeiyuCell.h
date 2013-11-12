//
//  SeiyuCell.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/12.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeiyuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *like_label;
@property (weak, nonatomic) IBOutlet UILabel *voice_label;
@property (weak, nonatomic) IBOutlet UILabel *watch_label;

@end
