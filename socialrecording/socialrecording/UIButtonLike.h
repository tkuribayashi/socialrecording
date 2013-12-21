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
@property (nonatomic)NSMutableDictionary *sync_data;
@property (nonatomic)BOOL like_flag;
- (void)setInitWithSyncLabel:(UILabel *)sync_label SyncData:(NSMutableDictionary *)sync_data;
@end
