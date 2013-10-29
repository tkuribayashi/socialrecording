//
//  CompleteAddTokoViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/29.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "CompleteAddTokoViewController.h"

@interface CompleteAddTokoViewController ()

@end

@implementation CompleteAddTokoViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_back_tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
