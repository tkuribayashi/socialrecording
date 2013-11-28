//
//  UIToggleButton.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/18.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "UIToggleButton.h"

@implementation UIToggleButton {
    UIColor *current;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.is_on = false;
        self.tintColor = [UIColor colorWithRed:46/255.0 green:226/255.0 blue:233/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
-(void)toggle{
    if(!self.is_on){
        current = [self currentTitleColor];
        self.backgroundColor = [UIColor colorWithRed:46/255.0 green:226/255.0 blue:233/255.0 alpha:1.0];
        self.tintColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = current;
    }
    self.is_on = !self.is_on;
}

@end
