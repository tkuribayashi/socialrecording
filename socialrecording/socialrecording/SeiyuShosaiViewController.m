//
//  SeiyuShosaiViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/03.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "SeiyuShosaiViewController.h"
#import "TokoShosaiViewController.h"

@interface SeiyuShosaiViewController ()

@end

@implementation SeiyuShosaiViewController

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
    self.playing_number = -1;
    self.playing_image = [UIImage imageNamed:@"first.png"];
    self.not_playing_image = [UIImage imageNamed:@"second.png"];
    
    //Comment:self.seiyu_idを用いてデータ取得して、セットして下さい。
    [self.label_name setText:@"声優名"];
    [self.label_good setText:[NSString stringWithFormat:@"いいね%d件",10]];
    [self.label_voice setText:[NSString stringWithFormat:@"ボイス%d個",10]];
    [self.label_watch setText:[NSString stringWithFormat:@"再生数%d回",10]];
    [self.label_good_rank setText:[NSString stringWithFormat:@"%d位",3]];
    [self.label_voice_rank setText:[NSString stringWithFormat:@"%d位",3]];
    [self.label_watch_rank setText:[NSString stringWithFormat:@"%d位",3]];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    //Comment:声優のボイスデータを入れて下さい。投稿詳細画面と違い、それぞれの投稿名、投稿ID等も必要です。
    self.voice_data = [@[@"test1",@"test2",@"test3",@"test4",@"test5"] mutableCopy];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
        //音データをDLして再生　再生が終了した時のイベント関数もどこかに追加して下さい。        // request
        //Comment:上記の動作を実現して下さい。
        
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
        //HTTP Request
        //更なるデータを追加
        [self.table reloadData];
    }else if(self.table.contentOffset.y <= 70){
        //HTTP Request
        //データを更新
        [self.table reloadData];
    }
}


/* いいねボタンタップ */
- (IBAction)iine_button_tapped:(id)sender forEvent:(UIEvent *)event {
    //Comment:いいねが出来るようにして下さい。二重いいねが出来ないようにして下さい
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    NSString *voice_id = self.voice_data[indexPath.row][@"id"];
    NSLog(@"like num: %@",voice_id);
    
    RetrieveJson *json = [[RetrieveJson alloc]init];
    [json accessServer:[NSString stringWithFormat:@"voice/%@/vote/",voice_id]];
}

- (IBAction)button_toko_tapped:(id)sender forEvent:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    //Comment:投稿IDと投稿データをセットして下さい
    self.toko_id = self.voice_data[indexPath.row][@"user_id"];
    //self.toko_data =
    [self performSegueWithIdentifier:@"SeiyuShosaiToTokoShosai" sender:self];
}
// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    return indexPath;
}

-(void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    //Comment:セリフタイトルといいねの個数をセットして下さい
    NSString *title = self.voice_data[indexPath.row][@"username"];//セリフタイトル
    NSString *iine = self.voice_data[indexPath.row][@"votes"];//いいねの個数
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:title];
    
    label = (UILabel *)[cell viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"いいね%@件",iine]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SeiyuShosaiToTokoShosai"]) {
        TokoShosaiViewController *viewController = (TokoShosaiViewController*)[segue destinationViewController];
        viewController.toko_id = self.toko_id;
        viewController.toko_data = self.toko_data;
        NSLog(@"id=%@",self.toko_id);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
