//
//  TokoViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/17.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "TokoViewController.h"
#import "RetrieveJson.h"
#import "TokoShosaiViewController.h"

@interface TokoViewController ()

@end

@implementation TokoViewController {
    RetrieveJson *json;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    ////////////////////サーチビュー////////////////////
    //////////////////////////////////////////////////
    self.search_view = [[UIToggleView alloc] initWithFrame:CGRectMake(0, 94, 320, 74) sync_toggle_button:self.search_button];
    [self.view addSubview:self.search_view];

    self.search_odai_button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
    [self.search_odai_button setFrame:CGRectMake(0, 0, 106, 30)];
    [self.search_odai_button setTitle:@"お題" forState:UIControlStateNormal];
    [self.search_odai_button setTag:0];
    [self.search_odai_button addTarget:self action:@selector(search_select_button_tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.search_view addSubview:self.search_odai_button];
    [self.search_odai_button toggle];
    
    self.search_tag_button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
    [self.search_tag_button setFrame:CGRectMake(106, 0, 107, 30)];
    [self.search_tag_button setTitle:@"タグ" forState:UIControlStateNormal];
    [self.search_odai_button setTag:1];
    [self.search_tag_button addTarget:self action:@selector(search_select_button_tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.search_view addSubview:self.search_tag_button];
    
    self.search_seiyu_button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
    [self.search_seiyu_button setFrame:CGRectMake(213, 0, 107, 30)];
    [self.search_seiyu_button setTitle:@"声優" forState:UIControlStateNormal];
    [self.search_odai_button setTag:2];
    [self.search_seiyu_button addTarget:self action:@selector(search_select_button_tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.search_view addSubview:self.search_seiyu_button];
    
    self.search_bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, 320, 44)];
    [self.search_bar setDelegate:self];
    [self.search_view addSubview:self.search_bar];
    
    //////////////////////////////////////////////////
    ////////////////////ソートビュー////////////////////
    //////////////////////////////////////////////////
    self.sort_view = [[UIToggleView alloc] initWithFrame:CGRectMake(0, 94, 320, 150) sync_toggle_button:self.sort_button];
    [self.view addSubview:self.sort_view];
    
    NSArray *sort_button_titles = @[@"新しい投稿順",@"古い投稿順",@"いいねが多い順",@"いいねが少ない順",@"再生数が多い順",@"再生数が少ない順",@"ボイスが多い順",@"ボイスが少ない順",@"新しいボイス順",@"古いボイス順"];
    int button_height = 30;
    for (int i = 0; i < [sort_button_titles count]; i++) {
        NSString *title = sort_button_titles[i];
        CGRect button_frame =CGRectMake(160*(i%2), button_height * (i / 2), 160, button_height);
        UIToggleButton *button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        [button setFrame:button_frame];
        [button addTarget:self action:@selector(sort_select_button_tapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        if(i == 0){
            [button toggle];
        }
        [self.sort_view addSubview:button];
    }
    //////////////////////////////////////////////////
    ////////////////////ジャンルビュー////////////////////
    //////////////////////////////////////////////////
    self.genre_view = [[UIToggleView alloc] initWithFrame:CGRectMake(0, 94, 320, 60)sync_toggle_button:self.genre_button];
    [self.view addSubview:self.genre_view];
    
    NSArray *genre_button_titles = @[@"指定無し",@"萌え",@"モノマネ",@"早口言葉"];
    int genre_button_height = 30;
    for (int i = 0; i < [genre_button_titles count]; i++) {
        NSString *title = genre_button_titles[i];
        CGRect button_frame =CGRectMake(160*(i%2), genre_button_height * (i / 2), 160, genre_button_height);
        UIToggleButton *button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        [button setFrame:button_frame];
        [button addTarget:self action:@selector(genre_select_button_tapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        if(i == 0){
            [button toggle];
        }
        [self.genre_view addSubview:button];
    }
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self set_load_statusWithOn:YES];
    //HTTP Request
    //self.table_data = [@[@"aa",@"bb",@"cc",@"dd",@"ee",@"ff",@"gg",@"hh"] mutableCopy];
    
	json = [[RetrieveJson alloc]init];
    
    NSString *param = @"odai/search/?sort=0&page=0";//初期は新着ボイス順、ジャンル指定無しで表示
    
    //APIアクセスでJSONを取得
    self.table_data = [json retrieveJson:param];/*
    NSMutableArray *temp = [NSMutableArray array];
    for(NSMutableDictionary *dict in data){
        //self.table_data = [[dict valueForKeyPath:@"comment"] mutableCopy];
        [temp addObject:[dict valueForKeyPath:@"comment"]];
        //NSLog(@"%@",[dict valueForKeyPath:@"comment"]);
    }
    for(NSString *s  in temp){
        NSLog(@"here¥n%@",s);
    }
    self.table_data = [temp mutableCopy];*/
    //self.table_data = [@[@{@"name": @"aa",@"comment":@"aa",@"votes":@"10"}] mutableCopy];
    NSLog(@"data retrieval and display done");
    
    [self set_load_statusWithOn:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search_button_tapped:(id)sender {
    [self.search_bar resignFirstResponder];
    [UIToggleView animationSelectWithSelectView:self.search_view downview:self.table_view callback:^{}];
}

- (IBAction)sort_button_tapped:(id)sender {
    [self.search_bar resignFirstResponder];
    [UIToggleView animationSelectWithSelectView:self.sort_view downview:self.table_view callback:^{}];
}

- (IBAction)genre_button_tapped:(id)sender {
    [self.search_bar resignFirstResponder];
    [UIToggleView animationSelectWithSelectView:self.genre_view downview:self.table_view callback:^{}];
}
-(void)search_select_button_tapped:(id)sender{
    if(self.search_view.is_animating == YES ||
       self.sort_view  .is_animating == YES ||
       self.genre_view .is_animating == YES){
        return;
    }
    
    UIView *view = self.search_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.class == [UIToggleButton class] && button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    int search_target = 0;
    UIView *view = self.search_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.class == [UIToggleButton class] && button.is_on){
            search_target = button.tag;
        }
    }
    [self set_load_statusWithOn:YES];
    
    int sort = [self getSort];
    int genre = [self getGenre];
    
    //HTTP Request
    //searchBar.textとsearch_target(0=お題,1=タグ,2=声優)検索ワードに合わせて更新 sort, genreも用いる？
    [self.table reloadData];
    [self set_load_statusWithOn:NO];
    
    
    [searchBar resignFirstResponder];
}
-(void)sort_select_button_tapped:(id)sender{
    if(self.search_view.is_animating == YES ||
       self.sort_view  .is_animating == YES ||
       self.genre_view .is_animating == YES){
        return;
    }
    
    UIView *view = self.sort_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
    
    [self sort_button_tapped:self.sort_button];
    
    int sort = [self getSort];
    int genre = [self getGenre];
    
    [self set_load_statusWithOn:YES];
    //HTTP Request
    //更新　sort、genre変数を用いる
    [self.table reloadData];
    [self set_load_statusWithOn:NO];
}

-(void)genre_select_button_tapped:(id)sender{
    if(self.search_view.is_animating == YES ||
       self.sort_view  .is_animating == YES ||
       self.genre_view .is_animating == YES){
        return;
    }
    
    UIView *view = self.genre_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
    
    UIToggleButton *v = sender;
    [self.navigate_title setTitle:[NSString stringWithFormat:@"投稿一覧(%@)",  v.titleLabel.text]];
    
    [self genre_button_tapped:self.genre_button];
    
    int sort = [self getSort];
    int genre = [self getGenre];
    
    [self set_load_statusWithOn:YES];
    //HTTP Request
    //更新　sort、genre変数を用いる
    [self.table reloadData];
    [self set_load_statusWithOn:NO];
}
-(int)getSort{
    UIView *view = self.sort_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.is_on){
            return button.tag;
        }
    }
    return 0;
}
-(int)getGenre{
    UIView *view = self.genre_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.is_on){
            return button.tag;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.table_data count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"toko_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Update Cell
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.toko_data = self.table_data[indexPath.row];
    [self performSegueWithIdentifier:@"TokoToShosai" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"TokoToShosai"]) {
        TokoShosaiViewController *viewController = (TokoShosaiViewController*)[segue destinationViewController];
        viewController.toko_data = self.toko_data;
    }
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIToggleView *view in self.view.subviews) {
        if([view isKindOfClass:[UIToggleView class]] && view.is_hidden == NO){
            [UIView animateWithDuration:0.0f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                             } completion:^(BOOL finished) {
                                 CGRect table_frame = self.table_view.frame;
                                 table_frame.origin.y += view.frame.size.height;
                                 self.table_view.frame = table_frame;
                             }];
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height + 70)){
        if(!self.flg_load_record){
            [self set_load_statusWithOn:YES];
            //HTTP Request
            //同じ条件下での更なるデータを追加
            [self.table reloadData];
            [self set_load_statusWithOn:NO];
        }
    }else if(self.table.contentOffset.y <= 70){
        if(!self.flg_load_record){
            [self set_load_statusWithOn:YES];
            //HTTP Request
            //同じ条件下でのデータを更新
            [self.table reloadData];
            [self set_load_statusWithOn:NO];
        }
        
    }
}
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.table_data[indexPath.row][@"name"];
    NSString *iine = [NSString stringWithFormat:@"いいね %@件" , self.table_data[indexPath.row][@"votes"]];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:title];
    
    label = (UILabel *)[cell viewWithTag:2];
    [label setText:iine];
}
- (void)set_load_statusWithOn:(BOOL)on{
    self.flg_load_record = on;
    if(!self.view_load){
        self.view_load = [[UIView alloc] initWithFrame: self.view.frame];
        [self.view_load setBackgroundColor:[UIColor grayColor]];
        [self.view_load setAlpha:0.7f];
        [self.view addSubview:self.view_load];
        
        UIActivityIndicatorView  *indicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator setFrame: self.view.frame];
        [indicator startAnimating];
        [self.view_load addSubview:indicator];
    }
    if(self.flg_load_record){
        //ボタンが押せないようView表示
        self.view_load.hidden = NO;
    }else{
        //View非表示
        self.view_load.hidden = YES;
    }
}
@end
