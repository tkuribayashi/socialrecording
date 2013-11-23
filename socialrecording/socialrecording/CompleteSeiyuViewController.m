//
//  CompleteSeiyuViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/22.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "CompleteSeiyuViewController.h"

@interface CompleteSeiyuViewController ()

@end

@implementation CompleteSeiyuViewController

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
	// Do any additional setup after loading the view.
    self.label_message.text = self.message;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
