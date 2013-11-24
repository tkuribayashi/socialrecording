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
    self.buttons_sex = @[self.toggle_sex_1, self.toggle_sex_2, self.toggle_sex_3];
    self.buttons_genre = @[self.toggle_genre_1, self.toggle_genre_2, self.toggle_genre_3];
    
    self.textview_comment.layer.borderWidth = 1;
    self.textview_comment.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.textview_comment.layer.cornerRadius = 5;
    self.textview_comment.delegate = self;
    
    self.button_edit_end = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_edit_end setFrame:self.view.frame];
    [self.button_edit_end setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.button_edit_end addTarget:self action:@selector(button_edit_end_tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_edit_end setHidden:YES];
    [self.view addSubview:self.button_edit_end];
    [self.view bringSubviewToFront:self.textview_comment];
}
- (void)viewWillAppear:(BOOL)animated{
    if ( self.complete_flg == YES ) {
        self.text_name.text = @"";
        self.textview_comment.text = @"";
        for (UIToggleButton *button in self.buttons_sex) {
            if(button.is_on){
                [button toggle];
            }
        }
        for (UIToggleButton *button in self.buttons_genre) {
            if(button.is_on){
                [button toggle];
            }
        }
    }
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

- (void)button_edit_end_tapped:(id)sender{
    
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
- (IBAction)toggle_sex_1_tapped:(id)sender {
    [self toggle_sex_button_tapped:sender];
}

- (IBAction)toggle_sex_2_tapped:(id)sender {
    [self toggle_sex_button_tapped:sender];
}

- (IBAction)toggle_sex_3_tapped:(id)sender {
    [self toggle_sex_button_tapped:sender];
}

- (IBAction)toggle_genre_1_tapped:(id)sender {
    [self toggle_genre_button_tapped:sender];
}

- (IBAction)toggle_genre_2_tapped:(id)sender {
    [self toggle_genre_button_tapped:sender];
}

- (IBAction)toggle_genre_3_tapped:(id)sender {
    [self toggle_genre_button_tapped:sender];
}

- (void)toggle_sex_button_tapped:(id)sender{
    for (UIToggleButton *button in self.buttons_sex) {
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}
- (void)toggle_genre_button_tapped:(id)sender{
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}
@end
