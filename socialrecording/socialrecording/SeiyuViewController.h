//
//  SeiyuViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/03.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"
#import "UIToggleView.h"
@interface SeiyuViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigate_title;
@property (weak, nonatomic) IBOutlet UIToggleButton *search_button;
@property (weak, nonatomic) IBOutlet UIToggleButton *sort_button;
@property (weak, nonatomic) IBOutlet UIToggleButton *genre_button;
- (IBAction)search_button_tapped:(id)sender;
- (IBAction)sort_button_tapped:(id)sender;
- (IBAction)genre_button_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray *table_data;

@property (nonatomic) UIToggleView *search_view;
@property (nonatomic) UISearchBar *search_bar;

@property (nonatomic) UIToggleView *sort_view;

@property (nonatomic) UIToggleView *genre_view;

@property (nonatomic, copy) NSDictionary *seiyu_data;

/* 引っ張って更新 */
@property(nonatomic) UIRefreshControl *refreshControl;

@end
