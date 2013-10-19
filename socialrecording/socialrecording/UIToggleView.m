//
//  UIToggleView.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/18.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "UIToggleView.h"

@implementation UIToggleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect f = self.frame;
        self.original_frame = f;
        self.hidden = true;
        self.is_animating = NO;
        self.is_hidden = YES;
        self.original_subview_frame = CGRectMake(0, 0, f.size.width, f.size.height);
        UIView *view = [[UIView alloc] initWithFrame:self.original_subview_frame];
        [self addSubview:view];
        self.clipsToBounds = YES;
    }
    return self;
}
-(void)addSubview:(UIView *)view{
    if(self.view_contain_subviews){
        [self.view_contain_subviews addSubview:view];
    }else{
        [super addSubview:view];
        self.view_contain_subviews = view;
    }
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
-(void)toggleWithDownView:(UIView *)downview callback:(void(^)())callback{
    if(self.is_animating == YES) return;
    
    self.hidden = false;
    
    CGRect start_frame = self.original_frame;
    CGRect end_frame = self.original_frame;
    if(self.is_hidden == YES){
        start_frame.size.height = 0;
    }else{
        end_frame.size.height = 0;
    }
    
    CGRect subview_start_frame = self.original_subview_frame;
    CGRect subview_end_frame = self.original_subview_frame;
    if(self.is_hidden == YES){
        subview_start_frame.origin.y = - self.original_frame.size.height;
    }else{
        subview_end_frame.origin.y = - self.original_frame.size.height;
    }
    
    CGRect downview_start_frame = downview.frame;
    CGRect downview_end_frame = downview.frame;
    if(self.is_hidden == YES){
        downview_end_frame.origin.y += self.original_frame.size.height;
    }else{
        downview_end_frame.origin.y -= self.original_frame.size.height;
    }
    
    self.is_animating = YES;
    self.is_hidden = !self.is_hidden;
    self.frame = start_frame;
    self.view_contain_subviews.frame = subview_start_frame;
    downview.frame = downview_start_frame;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = end_frame;
                         self.view_contain_subviews.frame = subview_end_frame;
                         downview.frame = downview_end_frame;
                     } completion:^(BOOL finished) {
                         self.is_animating = NO;
                         callback();
                     }];
}

@end
