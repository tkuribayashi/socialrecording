//
//  MyPageViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/11.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "MyPageViewController.h"
#import "TokoShosaiViewController.h"
#import "SeiyuShosaiViewController.h"
#import "RetrieveJson.h"
#import "HttpPost.h"
#import "RetrieveJson.h"
#import "SVProgressHUD.h"


@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    NSLog(@"%s",__func__);
    // ネットワーク状態が変更された際に通知を受け取る
    reachability  = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    [reachability startNotifier];
    

    [super viewDidLoad];
    
    //ナビゲーションバー、タブバーの変更
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
    self.tabBarController.tabBar.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_color.png"]];
    
    self.playing_number = -1;
    self.playing_image = [UIImage imageNamed:@"saisei_buttom.png"];
    self.not_playing_image = [UIImage imageNamed:@"saisei_buttom.png"];

    self.contents = @[
                      [@{@"title":@"お気に入り投稿", @"cell_id":@"MypageTokoCell", @"data":[[NSDictionary alloc] init]} mutableCopy],
                      [@{@"title":@"お気に入りボイス", @"cell_id":@"VoiceCell", @"data":[[NSDictionary alloc] init]} mutableCopy],
                      [@{@"title":@"お気に入り声優", @"cell_id":@"SeiyuCell", @"data":[[NSDictionary alloc] init]} mutableCopy],
                      [@{@"title":@"自分の投稿", @"cell_id":@"MypageTokoCell", @"data":[[NSDictionary alloc] init]} mutableCopy],
                      [@{@"title":@"自分のボイス", @"cell_id":@"VoiceCellNoSeiyu", @"data":[[NSDictionary alloc] init]} mutableCopy]
                      ];
    
    for (int i = 0; i < [self.contents count]; i++) {
        UIToggleButton *button = [UIToggleButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:self.contents[i][@"title"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(10+i*130, 10, 130, 30)];
        [button setTag:i];
        [button addTarget:self action:@selector(button_title_tapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll_title addSubview:button];
        if(i == 0){
            [button toggle];
        }
    }
    
    for(int i = 0; i < [self.contents count]; i++){
        UITableView *table = [[UITableView alloc] init];
        table.delegate = self;
        table.dataSource = self;
        UINib *nib = [UINib nibWithNibName:self.contents[i][@"cell_id"] bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:self.contents[i][@"cell_id"]];
        [table setRowHeight:100];
        [table setTag:i];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = [UIColor clearColor];
        [self.scroll_content addSubview:table];
    }
    self.scroll_content.delegate = self;
    
    
    UIBarButtonItem *person = [[UIBarButtonItem alloc] initWithTitle:@"人画像" style:UIBarButtonItemStylePlain target:self action:@selector(button_seiyu_tapped:)];
    person.image = [UIImage imageNamed:@"mypage.png"];;
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"編集" style:UIBarButtonItemStylePlain target:self action:@selector(button_edit_tapped:)];
    self.navigationItem.rightBarButtonItems = @[edit, person];
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__func__);

    [super viewWillAppear:animated];
    NSLog(@"WillAppearENDED");
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"DID APPEAR!");
    NSLog(@"%s",__func__);

    [super viewDidAppear:animated];
    
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    /*
     ここで netStatus には
     NotReachable : 接続されていない
     ReachableViaWWAN : 3G接続
     ReachableViaWiFi : Wi-Fi接続
     が入る
     */
    
    for (UIView *view in self.scroll_content.subviews) {
        [view setFrame:CGRectMake(view.tag*self.scroll_content.frame.size.width, 0, self.scroll_content.frame.size.width, self.scroll_content.frame.size.height)];
    }
    
    [self.scroll_title setContentSize:CGSizeMake(130*[self.contents count]+20, 50)];
    [self.scroll_content setContentSize:CGSizeMake(self.scroll_content.frame.size.width*[self.contents count], self.scroll_content.frame.size.height)];
    

    
    if (netStatus == NotReachable) {
        // ここに UIAlertView など、圏外の場合の処理
        UIAlertView *alert =[
                             [UIAlertView alloc]
                             initWithTitle : @"エラー"
                             message : @"ネットワーク接続されていません"
                             delegate : nil
                             cancelButtonTitle : @"OK"
                             otherButtonTitles : nil
                             ];
        [alert show];
        
        NSLog(@"alert");
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];//くるくる
        [self.view setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];

        [self networkConnected]; // ここに正常系の処理を関数で書く
        
        [SVProgressHUD dismiss];
    }
    NSLog(@"here");
}
- (void)networkConnected {
    NSLog(@"%s",__func__);
    //マイリストなどの情報はuser情報で得られる
    RetrieveJson *json = [[RetrieveJson alloc] init];
    NSString *param = @"user/0/";
    
    NSMutableDictionary *userdata = [json retrieveJsonDictionary:param];
    //ユーザデータがない場合はどうする？？？→北口さんが配列サイズ0のユーザデータを返すようにして下さい。
    if ([userdata count] != 0){
        self.contents[0][@"data"] = userdata[@"OdaiMylist"];
        self.contents[1][@"data"] = userdata[@"VoiceMylist"];
        self.contents[2][@"data"] = userdata[@"UserMylist"];
        self.contents[3][@"data"] = userdata[@"Odais"];
        self.contents[4][@"data"] = userdata[@"Voices"];
    }
    
    for (UITableView *table in self.scroll_content.subviews) {
        if( [table isKindOfClass:[UITableView class]]){
            [table reloadData];
        }
    }
    
}

- (void)notifiedNetworkStatus:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    // ネットワーク接続の通知を受け取った場合に、正常系の処理を行う
    if (networkStatus != NotReachable) {
        //[self networkConnected];
    } else if (networkStatus == NotReachable){
        NSLog(@"connection lost");
        //[self viewDidAppear:YES];
    }
}



-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"b");
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"a");
}
- (void)button_seiyu_tapped:(id)sender{
    NSUserDefaults *ui = [NSUserDefaults standardUserDefaults];
    NSNumber *is_seiyu = [ui objectForKey:@"is_seiyu"];
    if([is_seiyu boolValue]){
        [self performSegueWithIdentifier:@"MyPageToEditSeiyu" sender:self];
    }else{
        [self performSegueWithIdentifier:@"MyPageToCreateSeiyu" sender:self];
    }
}
- (void)button_edit_tapped:(id)sender{
    UIBarButtonItem *edit = sender;
    if([edit.title isEqualToString:@"編集"]){
        for (UITableView *table in self.scroll_content.subviews) {
            if( [table isKindOfClass:[UITableView class]]){
                table.editing = YES;
            }
        }
        [edit setTitle:@"完了"];
    }else{
        for (UITableView *table in self.scroll_content.subviews) {
            if( [table isKindOfClass:[UITableView class]]){
                table.editing = NO;
            }
        }
        [edit setTitle:@"編集"];
    }
}

- (void)button_title_tapped:(id)sender{
    NSLog(@"%s",__func__);
    int i = [sender tag];
    if(self.current_page != i){
        [UIView animateWithDuration:0.2f animations:^{
            self.scroll_content.contentOffset = CGPointMake(i*self.scroll_content.frame.size.width, 0);
        }];
    }
    
    NSLog(@"%s",__func__);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.tag == -1){
        CGPoint offset = scrollView.contentOffset;
        int page = (offset.x + 160)/320;
        
        if (self.current_page != page) {
            UIToggleButton *button = (UIToggleButton *)[self.scroll_title viewWithTag:self.current_page ];
            [button toggle];
            self.current_page = page;
            button = (UIToggleButton *)[self.scroll_title viewWithTag:self.current_page ];
            [button toggle];
            if( self.scroll_title.frame.size.width + self.scroll_title.contentOffset.x < button.frame.origin.x+button.frame.size.width + 10){
                [UIView animateWithDuration:0.2f animations:^{
                    CGPoint content_offset = self.scroll_title.contentOffset;
                    content_offset.x += (button.frame.origin.x+button.frame.size.width + 10) - (self.scroll_title.frame.size.width + self.scroll_title.contentOffset.x);
                    self.scroll_title.contentOffset = content_offset;
                }];
            }else if(button.frame.origin.x - 10 < self.scroll_title.contentOffset.x){
                [UIView animateWithDuration:0.2f animations:^{
                    CGPoint content_offset = self.scroll_title.contentOffset;
                    content_offset.x -= (self.scroll_title.contentOffset.x) - (button.frame.origin.x - 10);
                    self.scroll_title.contentOffset = content_offset;
                }];
            }
        }
    }else{
        UITableView *table = (UITableView *)scrollView;
        //テーブルビューのスクロール
        if(table.contentOffset.y >= (table.contentSize.height - table.bounds.size.height + 70)){
            //Comment:newpageまわりの実装お願いします。テーブル5個あるので注意。
            if (true/*newpage*/){
                //HTTP Request
                //Comment:table.tagをもとにデータ追加
                //[self.table_data addObjectsFromArray:ret];
                
                [table reloadData];
            }
        }else if(table.contentOffset.y <= 70){
            //HTTP Request
            //同じ条件下でのデータを更新
            [table reloadData];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contents[tableView.tag][@"data"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier;
    cellIdentifier = self.contents[tableView.tag][@"cell_id"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Update Cell
    [self updateCell:cell atIndexPath:indexPath tag:tableView.tag];
    
    return cell;
}
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath tag:(int)tag {
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    /*
     ここで netStatus には
     NotReachable : 接続されていない
     ReachableViaWWAN : 3G接続
     ReachableViaWiFi : Wi-Fi接続
     が入る
     */
    
    
    if (netStatus == NotReachable) {
        // ここに UIAlertView など、圏外の場合の処理
    } else {
        
        //Comment:dataを使って、ラベル表示させて下さい。
        //tag==0は１ページ目、つまりお気に入り投稿のテーブルのセルです。
        NSDictionary *data = self.contents[tag][@"data"][indexPath.row];
        if(tag == 0 ||  tag == 3){
            MypageTokoCell *toko_cell = (MypageTokoCell *)cell;
            NSLog(@"name: %@, %@",toko_cell.title_label,data[@"name"]);
            toko_cell.title_label.text  = data[@"name"];
            toko_cell.voice_label.text = [NSString stringWithFormat:@"%@", data[@"posts"]];
            toko_cell.like_label.text = [NSString stringWithFormat:@"%@", data[@"votes"]];
        }else if(tag == 1){
            VoiceCell *voice_cell = (VoiceCell *)cell;
            [voice_cell.title_label setTitle:data[@"odainame"] forState:UIControlStateNormal];
            voice_cell.like_label.text = [NSString stringWithFormat:@"%@", data[@"votes"]];
            voice_cell.seiyu_label.text = [NSString stringWithFormat:@"%@ さん",data[@"username"]];
            [voice_cell.like_button addTarget:self action:@selector(like_button_tapped:event:) forControlEvents:UIControlEventTouchUpInside];
            [voice_cell.shosai_button addTarget:self action:@selector(shosai_button_tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        }else if(tag==2){
            SeiyuCell *seiyu_cell = (SeiyuCell *)cell;
            seiyu_cell.name_label.text = [NSString stringWithFormat:@"%@", data[@"name"]];
            seiyu_cell.like_label.text = [NSString stringWithFormat:@"%@", data[@"votes"]];
            seiyu_cell.voice_label.text = [NSString stringWithFormat:@"%@", data[@"posts"]];
            seiyu_cell.watch_label.text = [NSString stringWithFormat:@"%@", data[@"views"]];
        }else if(tag == 4){
            VoiceCellNoSeiyu *voice_cell = (VoiceCellNoSeiyu *)cell;
            [voice_cell.title_label setTitle:data[@"odainame"] forState:UIControlStateNormal];
            voice_cell.like_label.text = [NSString stringWithFormat:@"%@", data[@"votes"]];
            [voice_cell.like_button addTarget:self action:@selector(like_button_tapped:event:) forControlEvents:UIControlEventTouchUpInside];
            [voice_cell.shosai_button_myvoice addTarget:self action:@selector(shosai_button_myvoice_tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // データを削除
        NSMutableArray *data = self.contents[tableView.tag][@"data"];
        NSString *id = @"";
        NSLog(@"data?:%@, %d",data[0][@"id"],indexPath.row);
        
        BOOL result_flag = YES;
        
        //HTTP Request
        /* マイリストの編集はPOST */
        if (tableView.tag <= 2){
            HttpPost *p = [[HttpPost alloc] init];
            NSArray *path = @[@"odaimylist/remove/",@"voicemylist/remove/",@"usermylist/remove/"];
            NSArray *n = @[@"odai_id",@"voice_id",@"user_id"];
            id = data[indexPath.row][@"id"];
            NSArray *params = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:n[tableView.tag],id,nil],nil];
            if ([[p HttpPost:path[tableView.tag] params:params] rangeOfString:@"failed"].location != NSNotFound){
                result_flag = NO;
            };
        } else {
        /* 自分の投稿とボイスの編集はGET */
            RetrieveJson *j = [[RetrieveJson alloc] init];
            
            id = data[indexPath.row][@"id"];
            
            NSArray *path = @[[NSString stringWithFormat:@"odai/%@/delete/",id],[NSString stringWithFormat:@"voice/%@/delete/",id]];
            
            if (![j accessServer:path[tableView.tag - 3]]) {
                result_flag = NO;
            }
        }
        
        //成功すれば以下を実行
        if (result_flag){
            [data removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            UIAlertView *alert = [
                                  [UIAlertView alloc]
                                  initWithTitle : @"エラー"
                                  message : @"削除に失敗しました"
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil
                                  ];
            [alert show];

        }
    }
}
-(void)like_button_tapped:(id)sender event:(UIEvent *)event{
    NSIndexPath *indexpath = [self indexPathForControlEvent:event];
    //Comment:いいね送信
    NSString *voice_id = self.contents[1][@"data"][indexpath.row][@"id"];
    NSLog(@"like num: %@",voice_id);
    
    
    RetrieveJson *json = [[RetrieveJson alloc]init];
    [json accessServer:[NSString stringWithFormat:@"voice/%@/vote/",voice_id]];
    
    
    /*
    //いいねタップで表示をインクリメント
    int like = [self.voice_data[indexpath.row][@"votes"] intValue]+1;
    UITableView *tableview = self.table;
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexpath];
    UILabel *label = (UILabel *)[cell viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"いいね%d件",like]];
     */
    
}

/* ボイスマイリスト→投稿詳細タップ時に投稿詳細に飛ぶ */
-(void)shosai_button_tapped:(id)sender event:(UIEvent *)event{
    NSIndexPath *indexpath = [self indexPathForControlEvent:event];
    
    self.toko_id = self.contents[1][@"data"][indexpath.row][@"odai_id"];
    self.toko_data = NULL;
    [self performSegueWithIdentifier:@"MyPageToTokoShosai" sender:self];
}

/* 自分のボイス→投稿詳細タップ時に投稿詳細に飛ぶ */
-(void)shosai_button_myvoice_tapped:(id)sender event:(UIEvent *)event{
    NSIndexPath *indexpath = [self indexPathForControlEvent:event];
    
    self.toko_id = self.contents[4][@"data"][indexpath.row][@"odai_id"];
    self.toko_data = NULL;
    [self performSegueWithIdentifier:@"MyPageToTokoShosai" sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Comment:セル選択した時の動作。それぞれ動作するようにして下さい。
    //tag==0は１ページ目、つまりお気に入り投稿のテーブルです。
    if(tableView.tag == 0){
        self.toko_id = self.contents[tableView.tag][@"data"][indexPath.row][@"id"];
        self.toko_data = NULL;
        [self performSegueWithIdentifier:@"MyPageToTokoShosai" sender:self];
    }else if(tableView.tag == 1 || tableView.tag == 4){
        [SVProgressHUD show];//くるくる
        [self.view setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
        
        //HTTP Request
        //音データをDLして再生　再生が終了した時のイベント関数もどこかに追加して下さい。
        // request
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [NSString stringWithFormat:@"%@/Caches/temp.caf",[paths objectAtIndex:0]];
        
        //Comment:ボイスデータから取得
        NSString *reqFilePath = self.contents[tableView.tag][@"data"][indexPath.row][@"vfile"];
        NSLog(@"%@",reqFilePath);
        
        
        NSError *error = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"http://49.212.174.30/sociareco/api/static/%@",reqFilePath];
        NSLog(@"request url: %@",urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response = nil;
        NSData *data = [
                        NSURLConnection
                        sendSynchronousRequest : request
                        returningResponse : &response
                        error : &error
                        ];
        
        // error
        NSString *error_str = [error localizedDescription];
        if (0<[error_str length]) {
            UIAlertView *alert = [
                                  [UIAlertView alloc]
                                  initWithTitle : @"RequestError"
                                  message : error_str
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil
                                  ];
            [alert show];
        }
        // responseを受け取ったあとの処理
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:[NSData data] attributes:nil];
        NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [file writeData:data];
        
        NSLog(@"path: %@",[paths objectAtIndex:0]);
        
        
        if(fm) {
            NSLog(@"s:%@",filePath);
        } else {
            NSLog(@"f");
        }
        
        
        //NSString *mp3path = [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
        
        NSLog(@"filepath: %@",filePath);
        
        NSURL* mp3url = [NSURL fileURLWithPath:filePath];
        
        NSLog(@"url: %@",[mp3url absoluteString]);
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3url error:&error];
            if ( error != nil )
            {
                NSLog(@"Error %@", [error localizedDescription]);
            }
            NSLog(@"prepare to play");
            if([self.player prepareToPlay]){
                NSLog(@"s");
            } else {
                NSLog(@"f");
            }
            
            NSLog(@"start playing");
            [self.player play];
            
            /* 再生したらviewをインクリメント *//*
                                    //Comment:ボイスデータから取得
                                    NSString *voice_id = self.contents[1][@"data"][indexPath.row][@"id"];
                                    RetrieveJson *json = [[RetrieveJson alloc]init];
                                    [json accessServer:[NSString stringWithFormat:@"voice/%@/view/",voice_id]];*/
        } else {
            NSLog(@"failed playing");
        }
        
        [SVProgressHUD dismiss];//くるくる
        
        
        
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    }else if(tableView .tag == 2){
        self.seiyu_id = self.contents[tableView .tag][@"data"][indexPath.row][@"id"];
        [self performSegueWithIdentifier:@"MyPageToSeiyuShosai" sender:self];
    }else if(tableView .tag == 3){
        //Comment:投稿詳細へ
        self.toko_id = self.contents[tableView .tag][@"data"][indexPath.row][@"id"];
        self.toko_data = NULL;
        [self performSegueWithIdentifier:@"MyPageToTokoShosai" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"MyPageToTokoShosai"]) {
        TokoShosaiViewController *viewController = (TokoShosaiViewController*)[segue destinationViewController];
        viewController.toko_id = self.toko_id;
        viewController.toko_data = self.toko_data;
        NSLog(@"id=%@",self.toko_id);
    }else if([[segue identifier] isEqualToString:@"MyPageToSeiyuShosai"]){
        SeiyuShosaiViewController *viewController = (SeiyuShosaiViewController*)[segue destinationViewController];
        viewController.seiyu_id = self.seiyu_id;
        NSLog(@"id=%@",self.seiyu_id);
    }
}

// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    for (UITableView *table in self.scroll_content.subviews) {
        CGPoint p = [touch locationInView:table];
        NSIndexPath *indexPath = [table indexPathForRowAtPoint:p];
        if(indexPath){
            return indexPath;
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
