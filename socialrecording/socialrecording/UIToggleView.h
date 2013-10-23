//
//  UIToggleView.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/18.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"

@interface UIToggleView : UIView
- (id)initWithFrame:(CGRect)frame sync_toggle_button:(UIToggleButton *)sync_toggle_button;

-(void)toggleWithDownView:(UIView *)downview callback:(void(^)())callback;
@property (nonatomic) CGRect original_frame;
@property (nonatomic) CGRect original_subview_frame;
@property (nonatomic) BOOL is_animating;
@property (nonatomic) BOOL is_hidden;
@property (nonatomic) UIView *view_contain_subviews;
@property (nonatomic)
UIToggleButton * sync_toggle_button;
+ (void)animationSelectWithSelectView:(UIToggleView *)target_view downview:(UIView *)downview callback:(void(^)())callback;
@end
