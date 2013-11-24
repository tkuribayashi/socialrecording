//
//  AddTokoViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/28.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"

@interface AddTokoViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UITextField *text_name;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_button_1;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_button_2;
@property (weak, nonatomic) IBOutlet UIToggleButton *toggle_button_3;
@property (copy, nonatomic) NSArray *buttons_genre;
- (IBAction)toggle_button_1_tapped:(id)sender;
- (IBAction)toggle_button_2_tapped:(id)sender;
- (IBAction)toggle_button_3_tapped:(id)sender;
- (IBAction)button_add_tapped:(id)sender;
- (IBAction)text_name_end:(id)sender;
@property (nonatomic) UIButton *button_edit_end;
@property (weak, nonatomic) IBOutlet UILabel *label_comment;
@property (weak, nonatomic) IBOutlet UITextView *text_comment;
@property (nonatomic)BOOL flag_complete;
@end
