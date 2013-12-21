//
//  UIButtonLike.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/12/21.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonLike : UIButton
@property (nonatomic)UILabel *sync_label;
@property (nonatomic)BOOL like_flag;
@property (nonatomic)NSString *voice_id;
- (void)setInitWithVoiceID:(NSString *)voice_id SyncLabel:(UILabel *)sync_label;
@end
