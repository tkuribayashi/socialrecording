//
//  UIToggleButton.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/18.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "UIToggleButton.h"

@implementation UIToggleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.is_on = false;
    }
    return self;
}
-(void)toggle{
    if(!self.is_on){
        self.backgroundColor = [UIColor colorWithRed:0.2f green:(CGFloat)0.8f blue:(CGFloat)1.0f alpha:1.0f];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    self.is_on = !self.is_on;
}

@end
