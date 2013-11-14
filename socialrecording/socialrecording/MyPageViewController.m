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

@interface MyPageViewController ()

@end

@implementation MyPageViewController

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
    
    self.playing_number = -1;
    self.playing_image = [UIImage imageNamed:@"first.png"];
    self.not_playing_image = [UIImage imageNamed:@"second.png"];
    
    //Comment:ここのdataの部分に、それぞれのデータを入れて下さい。
    //データ追加も想定して、データクラスはNSMutableArray,NSMutableDirectionaryが望ましいです。
    
    //マイリストなどの情報はuser情報で得られる
    RetrieveJson *json = [[RetrieveJson alloc] init];
    NSString *param = @"user/0/";
    
    NSMutableDictionary *userdata = [json retrieveJsonDictionary:param];
    if ([userdata count] == 0){//ユーザデータがない場合はどうする？？？
        self.contents = @[
                      @{@"title":@"お気に入り投稿", @"cell_id":@"MypageTokoCell", @"data":@[@"data1",@"data2",@"data3"]},
                      @{@"title":@"お気に入りボイス", @"cell_id":@"VoiceCell", @"data":@[@"data1",@"data2",@"data3",@"data4"]},
                      @{@"title":@"お気に入り声優", @"cell_id":@"SeiyuCell", @"data":@[@"data1",@"data2",@"data3"]}
                      ];
    } else {
        self.contents = @[ @{@"title":@"お気に入り投稿", @"cell_id":@"MypageTokoCell", @"data":userdata[@"OdaiMylist"]},
                           @{@"title":@"お気に入りボイス", @"cell_id":@"VoiceCell", @"data":userdata[@"VoiceMylist"]},
                           @{@"title":@"お気に入り声優", @"cell_id":@"SeiyuCell", @"data":userdata[@"UserMylist"]}
                           ];

    }
                     
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
        [self.scroll_content addSubview:table];
    }
    self.scroll_content.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    for (UIView *view in self.scroll_content.subviews) {
        [view setFrame:CGRectMake(view.tag*self.scroll_content.frame.size.width, 0, self.scroll_content.frame.size.width, self.scroll_content.frame.size.height)];
    }
    
    [self.scroll_title setContentSize:CGSizeMake(130*[self.contents count]+20, 50)];
    [self.scroll_content setContentSize:CGSizeMake(self.scroll_content.frame.size.width*[self.contents count], self.scroll_content.frame.size.height)];
    
    
}

- (void)button_title_tapped:(id)sender{
    int i = [sender tag];
    if(self.current_page != i){
        [UIView animateWithDuration:0.2f animations:^{
            self.scroll_content.contentOffset = CGPointMake(i*self.scroll_content.frame.size.width, 0);
        }];
    }
    
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
            //Comment:newpageまわりの実装お願いします。テーブル３個あるので注意。
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
    //Comment:dataを使って、ラベル表示させて下さい。
    //tag==0は１ページ目、つまりお気に入り投稿のテーブルのセルです。
    NSDictionary *data = self.contents[tag][@"data"][indexPath.row];
    if(tag == 0){
        MypageTokoCell *toko_cell = (MypageTokoCell *)cell;
        toko_cell.title_label.text = data[@"name"];
        toko_cell.voice_label.text = [NSString stringWithFormat:@"%@ボイス", data[@"posts"]];
        toko_cell.like_label.text = [NSString stringWithFormat:@"%@いいね", data[@"votes"]];
    }else if(tag == 1){
        NSLog(@"data: %@",data);
        VoiceCell *voice_cell = (VoiceCell *)cell;
        voice_cell.title_label.text = data[@"odainame"];
        voice_cell.like_label.text = [NSString stringWithFormat:@"%@いいね", data[@"votes"]];
        voice_cell.seiyu_label.text = [NSString stringWithFormat:@"声優: %@",data[@"user_id"]];
        [voice_cell.like_button addTarget:self action:@selector(like_button_tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [voice_cell.shosai_button addTarget:self action:@selector(shosai_button_tapped:event:) forControlEvents:UIControlEventTouchUpInside];
    }else if(tag==2){
        SeiyuCell *seiyu_cell = (SeiyuCell *)cell;
        seiyu_cell.name_label.text = @"声優名";
        seiyu_cell.like_label.text = @"いいね";
        seiyu_cell.voice_label.text = @"ボイス";
        seiyu_cell.watch_label.text = @"総視聴数";
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
    
    self.toko_id = self.contents[1][@"data"][indexpath.row][@"id"];
    self.toko_data = NULL;
    [self performSegueWithIdentifier:@"MyPageToTokoShosai" sender:self];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Comment:セル選択した時の動作。それぞれ動作するようにして下さい。
    //tag==0は１ページ目、つまりお気に入り投稿のテーブルです。
    if(tableView.tag == 0){
        self.toko_id = @"1";
        self.toko_data = @{};
        [self performSegueWithIdentifier:@"MyPageToTokoShosai" sender:self];
    }else if(tableView.tag == 1){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *image_view = ((VoiceCell *)cell).playing_image;
        if( indexPath.row == self.playing_number ){
            self.playing_number = -1;
            [image_view setImage:self.not_playing_image];
            [self.player stop];
        }else{
            [SVProgressHUD show];//くるくる
            [self.view setNeedsDisplay];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
            
            if( self.playing_number != -1 ){
                UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.playing_number inSection:0]];
                UIImageView *image_view2 = ((VoiceCell *)cell2).playing_image;
                [image_view2 setImage:self.not_playing_image];
            }
            [image_view setImage:self.playing_image];
            self.playing_number = indexPath.row;
            
            
            //HTTP Request
            //音データをDLして再生　再生が終了した時のイベント関数もどこかに追加して下さい。
            // request
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            
            NSString *filePath = [NSString stringWithFormat:@"%@/Caches/temp.caf",[paths objectAtIndex:0]];
            
            //Comment:ボイスデータから取得
            NSString *reqFilePath = @"";//self.voice_data[indexPath.row][@"vfile"];
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
                
                /* 再生したらviewをインクリメント */
                //Comment:ボイスデータから取得
                NSString *voice_id = @"";//self.voice_data[indexPath.row][@"id"];
                RetrieveJson *json = [[RetrieveJson alloc]init];
                [json accessServer:[NSString stringWithFormat:@"voice/%@/view/",voice_id]];
            } else {
                NSLog(@"failed playing");
            }
            
            [SVProgressHUD dismiss];//くるくる
            
            
        }
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    }else if(tableView .tag == 2){
        self.seiyu_id = @"1";
        [self performSegueWithIdentifier:@"MyPageToSeiyuShosai" sender:self];
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
