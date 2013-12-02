//
//  SeiyuShosaiViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/03.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "SeiyuShosaiViewController.h"
#import "TokoShosaiViewController.h"
#import "RetrieveJson.h"
#import "HttpPost.h"
#import "PlayVoice.h"

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_color.png"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.playing_number = -1;
    self.playing_image = [UIImage imageNamed:@"saisei_buttom.png"];
    self.not_playing_image = [UIImage imageNamed:@"saisei_buttom.png"];
    
    //ユーザの詳細を取得する
    RetrieveJson *json = [[RetrieveJson alloc] init];
    NSString *param = [NSString stringWithFormat:@"user/%@/",self.seiyu_id];
    NSMutableDictionary *user = [json retrieveJsonDictionary:param];
    
    //取得したユーザ詳細を表示部にセットする
    [self.label_name setText:[NSString stringWithFormat:@"%@",user[@"name"]]];
    [self.label_good setText:[NSString stringWithFormat:@"%@",user[@"votes"]]];
    [self.label_voice setText:[NSString stringWithFormat:@"%@",user[@"posts"]]];
    [self.label_watch setText:[NSString stringWithFormat:@"%@",user[@"views"]]];
    [self.label_good_rank setText:[NSString stringWithFormat:@"%@位",user[@"voterank"]]];
    [self.label_voice_rank setText:[NSString stringWithFormat:@"%@位",user[@"postrank"]]];
    [self.label_watch_rank setText:[NSString stringWithFormat:@"%@位",user[@"viewrank"]]];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.voice_data = user[@"Voices"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.voice_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    [SVProgressHUD show];//くるくる
    [self.view setNeedsDisplay];
    
    /* play voice */
    
    PlayVoice *p = [[PlayVoice alloc] init];
    
    [p playVoice:self.voice_data :indexPath];
    

    [SVProgressHUD dismiss];//くるくる
    
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
    self.toko_id = self.voice_data[indexPath.row][@"odai_id"];
    self.toko_data = NULL;
    
    [self performSegueWithIdentifier:@"SeiyuShosaiToTokoShosai" sender:self];
}

- (IBAction)button_favo_tapped:(id)sender {
    //声優お気に入り登録

    HttpPost *p = [[HttpPost alloc] init];
    
    NSString *path = @"usermylist/add/";
    NSArray *params = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"user_id",self.seiyu_id,nil],nil];
    
    
    if ([[p HttpPost:path params:params]rangeOfString:@"failed"].location != NSNotFound){
        UIAlertView *alert = [
                              [UIAlertView alloc]
                              initWithTitle : @"エラー"
                              message : @"登録に失敗しました"
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil
                              ];
        [alert show];
    }else {
        UIAlertView *alert = [
                              [UIAlertView alloc]
                              initWithTitle : @"成功"
                              message : @"お気に入り声優に登録されました！"
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil
                              ];
        [alert show];
    }


}
// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    return indexPath;
}

-(void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{    NSString *title = self.voice_data[indexPath.row][@"odainame"];//セリフタイトル
    NSString *iine = self.voice_data[indexPath.row][@"votes"];//いいねの個数
    
    UIButton *button = (UIButton *)[cell viewWithTag:2];
    [button setTitle:title forState:UIControlStateNormal];
    
    UILabel *label = (UILabel *)[cell viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"%@",iine]];
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
