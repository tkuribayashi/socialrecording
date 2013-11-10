//
//  MyPageViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/11.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "MyPageViewController.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *buttons = @[@"お題",@"ボイス",@"ユーザ"];
    for (int i = 0; i < [buttons count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:buttons[i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i*100, 0, 100, 50)];
        [self.scroll_title addSubview:button];
    }
    [self.scroll_content setContentSize:CGSizeMake(self.scroll_content.frame.size.width*[buttons count], self.scroll_content.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
