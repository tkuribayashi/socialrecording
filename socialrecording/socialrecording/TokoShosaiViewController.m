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

@interface TokoShosaiViewController ()

@end

@implementation TokoShosaiViewController

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
    [self.label_name setText:self.toko_data[@"name"]];
    [self.text_comment setText:self.toko_data[@"comment"]];
    
    self.playing_number = -1;
    
    self.table.dataSource = self;
    self.table.delegate = self;
    self.not_playing_image = [UIImage imageNamed:@"first"];
    self.playing_image = [UIImage imageNamed:@"second"];
    
    //HTTP Request
    //ジャンルの取得、ボイス一覧の取得
    NSLog(@"received id = %@",self.toko_id);
    
	RetrieveJson *json = [[RetrieveJson alloc]init];
    NSString *param = [NSString stringWithFormat:@"odai/%@/",self.toko_id];
    
    NSMutableDictionary *toko_shosai = [json retrieveJsonDictionary:param];
    //[self.label_genre setText:@"（ジャンル）"];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    UIImageView *image_view = (UIImageView *)[cell viewWithTag:2];
    if( indexPath.row == self.playing_number ){
        self.playing_number = -1;
        [image_view setImage:self.not_playing_image];
    }else{
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

        NSString *filePath = [NSString stringWithFormat:@"%@/Caches/temp.mp3",[paths objectAtIndex:0]];
        
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
        } else {
            NSLog(@"failed playing");
        }

        
        
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
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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
    if ([[segue identifier] isEqualToString:@"Shosai"]) {
        RecordingViewController *viewController = (RecordingViewController*)[segue destinationViewController];
        viewController.toko_id = _toko_id;
        NSLog(@"id=%@",_toko_id);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_recording_tapped:(id)sender {
}
@end
