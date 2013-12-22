//
//  SeiyuViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/03.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "SeiyuViewController.h"
#import "RetrieveJson.h"
#import "SeiyuShosaiViewController.h"
#import "SVProgressHUD.h"
@interface SeiyuViewController ()

//キーボードを外タップで閉じるために追加
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
@end

@implementation SeiyuViewController{
    RetrieveJson *json;
    NSString *querytext;
    NSString *param;

    NSString *gender;
    
    BOOL newpage;
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
    
    //ナビゲーションバー、タブバーの変更
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
    self.tabBarController.tabBar.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_color.png"]];
    
    /* 引っ張って更新 */
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    // 更新アクションを設定
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    
    self.refreshControl = refreshControl;
    
    // UITableView* tableViewにくっつける場合.
    [self.table addSubview:refreshControl];
    /* ここまで */

    //キーボードを外タップで閉じるために追加
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
    
    //////////////////////////////////////////////////
    ////////////////////サーチビュー////////////////////
    //////////////////////////////////////////////////
    self.search_view = [[UIToggleView alloc] initWithFrame:CGRectMake(0, 94, 320, 74) sync_toggle_button:self.search_button];
    [self.view addSubview:self.search_view];
    
    NSArray *search_button_titles = @[@"指定無し", @"男", @"女"];
    int button_height = 30;
    int button_width = self.view.frame.size.width/[search_button_titles count];
    for (int i = 0; i < [search_button_titles count]; i++) {
        NSString *title = search_button_titles[i];
        CGRect button_frame =CGRectMake(button_width*i, 0, button_width, button_height);
        UIToggleButton *button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        [button setFrame:button_frame];
        [button addTarget:self action:@selector(search_select_button_tapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        if(i == 0){
            [button toggle];
        }
        [self.search_view addSubview:button];
    }
    
    self.search_bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, 320, 44)];
    [self.search_bar setDelegate:self];
    [self.search_view addSubview:self.search_bar];
    
    //////////////////////////////////////////////////
    ////////////////////ソートビュー////////////////////
    //////////////////////////////////////////////////
    self.sort_view = [[UIToggleView alloc] initWithFrame:CGRectMake(0, 94, 320, 150) sync_toggle_button:self.sort_button];
    [self.view addSubview:self.sort_view];
    
    NSArray *sort_button_titles = @[@"新しい登録順",@"古い登録順",@"総いいねが多い順",@"総いいねが少ない順",@"ボイスが多い順",@"ボイスが少ない順",@"新しいボイス順",@"古いボイス順",@"総再生数が多い順",@"総再生数が少ない順"];
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
    
    //HTTP Request
	json = [[RetrieveJson alloc]init];
    
    param = @"user/search/?sort=0&page=0";//初期は新着順、ジャンル指定無しで表示
    
    //APIアクセスでJSONを取得
    self.table_data = [json retrieveJson:param];
    
    NSLog(@"data retrieval and display done");
    
}


//キーボードを外タップで閉じるために追加
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.search_bar resignFirstResponder];
}
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        // キーボード表示中のみ有効
        if (self.search_bar.isFirstResponder){
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search_button_tapped:(id)sender {
    [self.search_bar resignFirstResponder];
    [UIToggleView animationSelectWithSelectView:self.search_view downview:self.table callback:^{}];
}

- (IBAction)sort_button_tapped:(id)sender {
    [self.search_bar resignFirstResponder];
    [UIToggleView animationSelectWithSelectView:self.sort_view downview:self.table callback:^{}];
}

- (IBAction)genre_button_tapped:(id)sender {
    [self.search_bar resignFirstResponder];
    [UIToggleView animationSelectWithSelectView:self.genre_view downview:self.table callback:^{}];
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

/* 検索を行うメソッド */
- (void)searchWithQuery{
    //HTTP Request
    //searchBar.textとsearch_target(0=お題,1=タグ,2=声優)検索ワードに合わせて更新 sort, genreも用いる？
    
	json = [[RetrieveJson alloc]init];
    
    /* 並び替えとジャンルの選択状態を取得*/
    int sort = [self getSort];
    int genre = [self getGenre];
    
    //検索クエリがNULLかつジャンル指定がない場合はsortのみ設定
    param = [NSString stringWithFormat:@"user/search/?sort=%d&page=0",sort];
    if (genre !=0){//ジャンル指定がされている場合はcを設定
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&c=%d",genre]];
    }
    if (querytext != NULL){//検索クエリが入力されている場合はqueryを設定
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&query=%@",querytext]];
    }
    
    if (querytext != NULL && gender != NULL){//検索クエリが入力されていてgenderが指定されている場合はgenderを設定
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&gender=%@",gender]];
    }
    //APIアクセスでJSONを取得
    @try {
        self.table_data = [json retrieveJson:param];
    }
    @catch (NSException *exception) {
        NSLog(@"[ERROR]\nexception[%@]", exception);
    }
    
    NSLog(@"data retrieval and display done");}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    int search_target = 0;
    UIView *view = self.search_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.class == [UIToggleButton class] && button.is_on){
            search_target = button.tag;
        }
    }
    
    NSString *gender_select[] ={NULL,@"M",@"F"};
    
    querytext = searchBar.text;
    gender = gender_select[search_target];
    
    [SVProgressHUD show];//くるくる
    [self.view setNeedsDisplay];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    

    [self searchWithQuery];
    
    
    [SVProgressHUD dismiss];

    [self.table reloadData];
    [self search_button_tapped:self.search_button];
    
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
    
    
    //HTTP Request
    //更新　sort、genre変数を用いる
    
    [SVProgressHUD show];//くるくる
    [self.view setNeedsDisplay];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    

    [self searchWithQuery];
    
    
    [SVProgressHUD dismiss];

    [self.table reloadData];
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
    
    //HTTP Request
    
    [SVProgressHUD show];//くるくる
    [self.view setNeedsDisplay];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    

    [self searchWithQuery];
    
    [SVProgressHUD dismiss];

    //APIアクセスでJSONを取得
    self.table_data = [json retrieveJson:param];
    
    NSLog(@"data retrieval and display done");
    
    [self.table reloadData];
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
-(int)getGenre{//genre選択→2:早口言葉、7:モノマネ、8:萌え
    int genre_converter[] = {0,8,7,2};
    
    UIView *view = self.genre_view.subviews[0];
    NSArray *buttons = view.subviews;
    for(UIToggleButton *button in buttons){
        if(button.is_on){
            //ジャンルボタンが選択されていればそれに該当するジャンル番号を返す。指定なしは0。
            return genre_converter[button.tag];
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.table_data count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"seiyu_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Update Cell
    [self updateCell:cell atIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.seiyu_data = self.table_data[indexPath.row];
    [self performSegueWithIdentifier:@"SeiyuToSeiyuShosai" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SeiyuToSeiyuShosai"]) {
        SeiyuShosaiViewController *viewController = (SeiyuShosaiViewController*)[segue destinationViewController];
        viewController.seiyu_id = [self.seiyu_data[@"id"] stringValue];
    }
}
- (void) viewWillAppear:(BOOL)animated {
    newpage = YES;
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
                                 CGRect table_frame = self.table.frame;
                                 table_frame.origin.y += view.frame.size.height;
                                 table_frame.size.height -= view.frame.size.height;
                                 self.table.frame = table_frame;
                             }];
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height + 70)){
        //HTTP Request
        //同じ条件下での更なるデータを追加
        if (newpage){
            //[self set_load_statusWithOn:YES];
            //HTTP Request
            //同じ条件下での更なるデータを追加(pageをインクリメント)
            NSRange range = [param rangeOfString:@"page="];
            int page = [[param substringFromIndex:range.location+range.length] intValue];
            NSLog(@"current page: %d",page);
            param = [param stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"page=%d",page] withString:[NSString stringWithFormat:@"page=%d",page+1]];
            NSMutableArray *ret = [json retrieveJson:param];
            if ([ret count] == 0){//これ以上表示するものがなければnewpageをNOにして、アクセスしないようにする
                NSLog(@"no more entries!");
                newpage = NO;
            }
            [self.table_data addObjectsFromArray:ret];
            
            
            [self.table reloadData];
            //[self set_load_statusWithOn:NO];
        }
    }else if(self.table.contentOffset.y <= 70){
        //HTTP Request
        //同じ条件下でのデータを更新
        [self.table reloadData];
    }
}
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.table_data[indexPath.row][@"name"];
    NSString *iine = [NSString stringWithFormat:@"%@" , self.table_data[indexPath.row][@"votes"]];
    NSString *posts =[NSString stringWithFormat:@"%@" , self.table_data[indexPath.row][@"posts"]];
    NSString *view_num =[NSString stringWithFormat:@"%@" , self.table_data[indexPath.row][@"views"]];
    
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:title];
    
    label = (UILabel *)[cell viewWithTag:2];
    [label setText:iine];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:posts];
    
    label = (UILabel *)[cell viewWithTag:4];
    [label setText:view_num];
    
}


/* 引っ張って更新 */
- (void)onRefresh:(id)sender
{
    // 更新開始
    [self.refreshControl beginRefreshing];
    
    // 更新処理をここに記述
    
    //[self set_load_statusWithOn:YES];
    //HTTP Request
    
    [self searchWithQuery];
    
    //APIアクセスでJSONを取得
    self.table_data = [json retrieveJson:param];
    
    NSLog(@"data retrieval and display done");
    
    [self.table reloadData];
    //[self set_load_statusWithOn:NO];
    
    
    // 更新終了
    [self.refreshControl endRefreshing];
}
/* ここまで */

@end
