//
//  TokoViewController.h
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/17.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleView.h"
#import "UIToggleButton.h"
#import "MypageTokoCell.h"
//import Reachability class
#import "Reachability.h"

// declare Reachability, you no longer have a singleton but manage instances
Reachability* reachability;
@interface TokoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate>{
    NSString *_toko_id;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navigate_title;

- (IBAction)search_button_tapped:(id)sender;
- (IBAction)sort_button_tapped:(id)sender;
- (IBAction)genre_button_tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIToggleButton *search_button;
@property (weak, nonatomic) IBOutlet UIToggleButton *sort_button;
@property (weak, nonatomic) IBOutlet UIToggleButton *genre_button;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray *table_data;

@property (nonatomic) UIToggleView *search_view;
@property (nonatomic) UISearchBar *search_bar;
@property (nonatomic) UIToggleButton *search_odai_button;
@property (nonatomic) UIToggleButton *search_tag_button;
@property (nonatomic) UIToggleButton *search_seiyu_button;

@property (nonatomic) UIToggleView *sort_view;

@property (nonatomic) UIToggleView *genre_view;


@property (nonatomic) BOOL flg_load_record;

@property (nonatomic) UIView *view_load;
@property (nonatomic, copy) NSDictionary *toko_data;

/* 引っ張って更新 */
@property(nonatomic) UIRefreshControl *refreshControl;


@end
