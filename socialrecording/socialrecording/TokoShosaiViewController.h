//
//  TokoShosaiViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TokoShosaiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UITextView *text_comment;
@property (weak, nonatomic) IBOutlet UILabel *label_genre;
@property (weak, nonatomic) IBOutlet UIButton *button_record;
@property (weak, nonatomic) IBOutlet UITableView *table;





@property (nonatomic, copy) NSDictionary *toko_data;
@property (nonatomic) NSMutableArray *voice_data;
@property (nonatomic) BOOL flg_load_record;
@end
