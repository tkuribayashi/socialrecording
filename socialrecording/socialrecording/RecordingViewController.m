//
//  RecordingViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "RecordingViewController.h"

@interface RecordingViewController ()

@end

@implementation RecordingViewController

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
    if(self.flag_end){
        self.flag_end = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_record_tapped:(id)sender {
}

- (IBAction)button_play_tapped:(id)sender {
}

- (IBAction)button_send_tapped:(id)sender {
    //投稿が成功すれば投稿完了画面へ
    self.flag_end = YES;
    [self performSegueWithIdentifier:@"RecordingToCompleteRecording" sender:self];
}
@end
