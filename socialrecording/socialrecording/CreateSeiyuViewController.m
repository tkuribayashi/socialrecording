//
//  CreateSeiyuViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/22.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "CreateSeiyuViewController.h"
#import "CompleteSeiyuViewController.h"

@interface CreateSeiyuViewController ()

@end

@implementation CreateSeiyuViewController

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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.complete_flg){
        self.complete_flg = false;
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.complete_flg = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_ok_tapped:(id)sender {
    [self performSegueWithIdentifier:@"CreateSeiyuToCompleteSeiyu" sender:self];
    self.complete_flg = true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CreateSeiyuToCompleteSeiyu"]) {
        CompleteSeiyuViewController *viewController = (CompleteSeiyuViewController*)[segue destinationViewController];
        viewController.message = @"声優登録完了しました。";
    }
}
@end
