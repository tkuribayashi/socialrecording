//
//  TokoShosaiViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "TokoShosaiViewController.h"
#import "RetrieveJson.h"
#import "RecordingViewController.h"
#import "SeiyuShosaiViewController.h"
#import "SVProgressHUD.h"

@interface TokoShosaiViewController ()

@end

@implementation TokoShosaiViewController {
    NSMutableArray *like_flag;
}

@synthesize session;
@synthesize recorder;
@synthesize player;
@synthesize toko_id = _toko_id;

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

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //HTTP Request
    //ジャンルの取得、ボイス一覧の取得
    NSLog(@"received id = %@",self.toko_id);
    
	RetrieveJson *json = [[RetrieveJson alloc]init];
    NSString *param = [NSString stringWithFormat:@"odai/%@/",self.toko_id];
    
    NSMutableDictionary *toko_shosai = [json retrieveJsonDictionary:param];

    if (self.toko_data == NULL){
        self.toko_data = toko_shosai;
        NSLog(@"name: %@", toko_shosai[@"name"]);
    }
    [self.label_name setText:self.toko_data[@"name"]];
    [self.text_comment setText:self.toko_data[@"comment"]];
    
    self.playing_number = -1;
    
    self.table.dataSource = self;
    self.table.delegate = self;
    self.not_playing_image = [UIImage imageNamed:@"first"];
    self.playing_image = [UIImage imageNamed:@"second"];
    
    NSString *genre = @"no genre";
    NSArray *tags = toko_shosai[@"tags"];
    
    for (NSDictionary *t in tags){
        if(t[@"genre"]){
            genre = t[@"name"];
            break;
        }
    }
    
    [self.label_genre setText:genre];
    
    //self.voice_data = [@[@"test1",@"test2",@"test3",@"test4"] mutableCopy];
    self.voice_data = toko_shosai[@"voices"];
    
    
    //いいね！ができるかどうかのフラグの初期化
    like_flag =[[NSMutableArray alloc] init];
    for (int i=0;i<self.voice_data.count;i++){
        NSNumber *flag = [NSNumber numberWithBool:YES];
        [like_flag addObject:flag];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.voice_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"voice_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Update Cell
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    UIImageView *image_view = (UIImageView *)[cell viewWithTag:2];
    if( indexPath.row == self.playing_number ){
        self.playing_number = -1;
        [image_view setImage:self.not_playing_image];
        [self.player stop];
    }else{
        [SVProgressHUD show];//くるくる
        [self.view setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];

        if( self.playing_number != -1 ){
            UITableViewCell *cell2 = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.playing_number inSection:0]];
            UIImageView *image_view2 = (UIImageView *)[cell2 viewWithTag:2];
            [image_view2 setImage:self.not_playing_image];
        }
        [image_view setImage:self.playing_image];
        self.playing_number = indexPath.row;
        
        
        //HTTP Request
        //音データをDLして再生　再生が終了した時のイベント関数もどこかに追加して下さい。
        // request
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);

        NSString *filePath = [NSString stringWithFormat:@"%@/Caches/temp.caf",[paths objectAtIndex:0]];
        
        NSString *reqFilePath = self.voice_data[indexPath.row][@"vfile"];
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
            NSString *voice_id = self.voice_data[indexPath.row][@"id"];
            RetrieveJson *json = [[RetrieveJson alloc]init];
            [json accessServer:[NSString stringWithFormat:@"voice/%@/view/",voice_id]];
        } else {
            NSLog(@"failed playing");
        }
        
        [SVProgressHUD dismiss];//くるくる
        
        
    }
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height + 70)){
        if(!self.flg_load_record){
            //HTTP Request
            //更なるデータを追加
            [self.table reloadData];
        }
    }else if(self.table.contentOffset.y <= 70){
        if(!self.flg_load_record){
            //HTTP Request
            //データを更新
            [self.table reloadData];
        }
        
    }
}


/* いいねボタンタップ */
- (IBAction)like_button_tapped:(id)sender forEvent:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    NSLog(@"like_flag: %@",like_flag[indexPath.row]);

    if ([like_flag[indexPath.row] boolValue]){
        NSString *voice_id = self.voice_data[indexPath.row][@"id"];
        NSLog(@"like num: %@",voice_id);
        
        
        RetrieveJson *json = [[RetrieveJson alloc]init];
        BOOL *result = [json accessServer:[NSString stringWithFormat:@"voice/%@/vote/",voice_id]];
        
        NSNumber *flag = [[NSNumber alloc] initWithBool:NO];
        
        [like_flag replaceObjectAtIndex:indexPath.row withObject:flag];
        NSLog(@"like_flag: %@ (%@)",like_flag[indexPath.row],flag);
        NSLog(@"%@",like_flag);
        
        //いいねタップで表示をインクリメント
        if (result){
            int like = [self.voice_data[indexPath.row][@"votes"] intValue]+1;
            UITableView *tableview = self.table;
            UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
            UILabel *label = (UILabel *)[cell viewWithTag:4];
            [label setText:[NSString stringWithFormat:@"いいね%d件",like]];
        }
    }
}

- (IBAction)button_seiyu_tapped:(id)sender forEvent:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    self.seiyu_id = self.voice_data[indexPath.row][@"user_id"];
    [self performSegueWithIdentifier:@"TokoShosaiToSeiyuShosai" sender:self];
}

- (IBAction)button_favo_tapped:(id)sender {
    //投稿のお気に入り登録
    
}

- (IBAction)button_voice_favo_tapped:(id)sender forEvent:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    //ボイスのお気に入り登録
    
}
// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    return indexPath;
}


- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row: %d",indexPath.row);
    NSLog(@"id: %d",[self.voice_data[indexPath.row][@"id"] intValue]);
    
    NSString *name = self.voice_data[indexPath.row][@"username"];
    NSString *iine = self.voice_data[indexPath.row][@"votes"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:[NSString stringWithFormat:@"%@さんのボイス",name]];
    
    UIButton *button = (UIButton *)[cell viewWithTag:3];
    [button setTitle:[NSString stringWithFormat:@"%@さんの詳細",name] forState:UIControlStateNormal];
    
    label = (UILabel *)[cell viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"いいね%@件",iine]];
    
}
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"TokoShosaiToRecording"]) {
        RecordingViewController *viewController = (RecordingViewController*)[segue destinationViewController];
        viewController.toko_id = _toko_id;
        viewController.toko_name = self.toko_data[@"name"];
        NSLog(@"id=%@",_toko_id);
    }else if([[segue identifier] isEqualToString:@"TokoShosaiToSeiyuShosai"]){
        SeiyuShosaiViewController *viewController = (SeiyuShosaiViewController*)[segue destinationViewController];
        viewController.seiyu_id = self.seiyu_id;
        NSLog(@"id=%@",self.seiyu_id);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_recording_tapped:(id)sender {
    [self performSegueWithIdentifier:@"TokoShosaiToRecording" sender:self];
}
@end
