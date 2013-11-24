//
//  CreateSeiyuViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/22.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"
@interface CreateSeiyuViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UITextField *text_name;
- (IBAction)text_name_end:(id)sender;
- (IBAction)text_name_begin:(id)sender;
@property (copy, nonatomic) NSArray *buttons_sex;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_sex_1;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_sex_2;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_sex_3;
@property (copy, nonatomic) NSArray *buttons_genre;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_genre_1;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_genre_2;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_genre_3;
- (IBAction)toggle_sex_1_tapped:(id)sender;
- (IBAction)toggle_sex_2_tapped:(id)sender;
- (IBAction)toggle_sex_3_tapped:(id)sender;
- (IBAction)toggle_genre_1_tapped:(id)sender;
- (IBAction)toggle_genre_2_tapped:(id)sender;
- (IBAction)toggle_genre_3_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label_comment;
@property (weak, nonatomic) IBOutlet UITextView *textview_comment;
- (IBAction)button_ok_tapped:(id)sender;
@property (nonatomic) UIButton *button_edit_end;
@property (nonatomic)BOOL complete_flg;
@property (nonatomic)BOOL delete_flg;
@end
