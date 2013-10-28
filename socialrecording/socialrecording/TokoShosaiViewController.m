//
//  TokoShosaiViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "TokoShosaiViewController.h"

@interface TokoShosaiViewController ()

@end

@implementation TokoShosaiViewController

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
    [self.label_genre setText:@"（ジャンル）"];
    self.voice_data = [@[@"test1",@"test2",@"test3",@"test4"] mutableCopy];
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
        //音データをDLして再生
        
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
    NSString *name = self.voice_data[indexPath.row];
    NSString *iine = self.voice_data[indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:[NSString stringWithFormat:@"%@さんのボイス",name]];
    
    UIButton *button = (UIButton *)[cell viewWithTag:3];
    [button setTitle:[NSString stringWithFormat:@"%@さんの詳細",name] forState:UIControlStateNormal];
    
    label = (UILabel *)[cell viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"いいね%@件",iine]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
