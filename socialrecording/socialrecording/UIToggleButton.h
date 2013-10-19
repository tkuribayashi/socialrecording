//
//  UIToggleButton.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/18.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToggleButton : UIButton
-(void)toggle;
@property (nonatomic) BOOL is_on;
@end
