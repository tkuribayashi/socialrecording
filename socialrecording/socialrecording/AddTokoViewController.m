//
//  AddTokoViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/28.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "AddTokoViewController.h"


@interface AddTokoViewController ()

@end

@implementation AddTokoViewController

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
    self.buttons_genre = @[self.toggle_button_1, self.toggle_button_2, self.toggle_button_3];
    self.text_comment = [[UITextView alloc] initWithFrame:CGRectMake(20, 245, 280, 128)];
    self.text_comment.layer.borderWidth = 1;
    self.text_comment.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.text_comment.layer.cornerRadius = 5;
    self.text_comment.delegate = self;
    [self.view addSubview:self.text_comment];
    
    self.button_edit_end = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_edit_end setFrame:self.view.frame];
    [self.button_edit_end setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.button_edit_end addTarget:self action:@selector(button_edit_end_tapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)toggle_button_1_tapped:(id)sender {
    [self toggle_button_tapped:sender];
}

- (IBAction)toggle_button_2_tapped:(id)sender {
    [self toggle_button_tapped:sender];
}

- (IBAction)toggle_button_3_tapped:(id)sender {
    [self toggle_button_tapped:sender];
}
- (void)toggle_button_tapped:(id)sender{
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}

- (IBAction)text_name_end:(id)sender {
    [self resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.view addSubview:self.button_edit_end];
    [self.view bringSubviewToFront:self.text_comment];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.text_comment.frame;
                         frame.origin.y = 85;
                         frame.size.height = 200;
                         self.text_comment.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    return YES;
}
- (void)button_edit_end_tapped:(id)sender{
    [self.text_comment resignFirstResponder];
    [self.button_edit_end removeFromSuperview];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.text_comment.frame;
                         frame.origin.y = 245;
                         frame.size.height = 128;
                         self.text_comment.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)button_add_tapped:(id)sender {
    NSString *name = self.text_name.text;
    NSString *comment = self.text_comment.text;
    int genre = -1;
    int i = 0;
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            genre = i;
        }
        i++;
    }
    
    //未入力チェックよろしく　genreチェック無し=(genre=-1)萌え=0 ものまね=1 早口言葉=2
    
    //HTTP Request
    //新規投稿
    
}

@end
