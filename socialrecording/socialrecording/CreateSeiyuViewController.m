//
//  CreateSeiyuViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/11/22.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "CreateSeiyuViewController.h"
#import "CompleteSeiyuViewController.h"
#import "RetrieveJson.h"
#import "HttpPost.h"

@interface CreateSeiyuViewController ()

@end

@implementation CreateSeiyuViewController

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
	// Do any additional setup after loading the view.
    self.buttons_sex = @[self.toggle_sex_1, self.toggle_sex_2, self.toggle_sex_3];
    self.buttons_genre = @[self.toggle_genre_1, self.toggle_genre_2, self.toggle_genre_3];
    
    self.textview_comment.layer.borderWidth = 1;
    self.textview_comment.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.textview_comment.layer.cornerRadius = 5;
    self.textview_comment.delegate = self;
    
    self.button_edit_end = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_edit_end setFrame:self.view.frame];
    [self.button_edit_end setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.button_edit_end addTarget:self action:@selector(button_edit_end_tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_edit_end setHidden:YES];
    [self.view addSubview:self.button_edit_end];
    [self.view bringSubviewToFront:self.label_name];
    [self.view bringSubviewToFront:self.text_name];
    [self.view bringSubviewToFront:self.label_comment];
    [self.view bringSubviewToFront:self.textview_comment];
    
    
    //HTTP Request
    //マイリストなどの情報はuser情報で得られる
    RetrieveJson *json = [[RetrieveJson alloc] init];
    NSString *param = @"user/0/";
    
    NSMutableDictionary *userdata = [json retrieveJsonDictionary:param];
    
    //声優登録住みか？登録住みなら
    if ([userdata[@"seiyu_flg"] boolValue]){
        [self.navigationItem setTitle:@"声優情報編集"];
        self.text_name.text = userdata[@"name"];
        self.textview_comment.text = userdata[@"comment"];
        
        [self.buttons_sex[[userdata[@"gender"] intValue]] toggle];
        
        
        NSDictionary *genre_converter = @{@8:@0,@7:@1,@2:@2};
        int selectedtag = [genre_converter[userdata[@"tags"][0][@"id"]] intValue];
        NSLog(@"tag: %d",selectedtag);
        [self.buttons_genre[selectedtag] toggle];
        /*
         UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"削除" style:UIBarButtonItemStylePlain target:self action:@selector(button_delete_tapped:)];
         self.navigationItem.rightBarButtonItem = delete;
         */
    } else {
        [self.navigationItem setTitle:@"声優情報編集"];
        //Comment:既にある情報を入れてあげて下さい。
        self.text_name.text = @"声優名";
        self.textview_comment.text = @"コメント";
        [self.buttons_sex[0] toggle];
        [self.buttons_genre[0] toggle];
        /*UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"削除" style:UIBarButtonItemStylePlain target:self action:@selector(button_delete_tapped:)];
         self.navigationItem.rightBarButtonItem = delete;*/
    }

    
}
- (void)viewWillAppear:(BOOL)animated{
}
/*
- (void)button_delete_tapped:(id)sender{
    //本当に削除しますか？ってきいて下さい
    // １行で書くタイプ（複数ボタンタイプ）
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:@"本当に削除しますか？"
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
}*/
// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            //HTTP Request
            
            
            
            //声優情報削除成功したら以下実行
            self.complete_flg = true;
            self.delete_flg = true;
            [self performSegueWithIdentifier:@"CreateSeiyuToCompleteSeiyu" sender:self];
            
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.complete_flg){
        self.complete_flg = false;
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.complete_flg = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_ok_tapped:(id)sender {
    NSString *name = self.text_name.text;
    NSString *comment = self.textview_comment.text;
    int sex = -1;
    int genre = -1;
    int i = 0;
    
    //sexチェック無し=(sex=-1)男=0 女=1 その他=2
    for (UIToggleButton *button in self.buttons_sex) {
        if(button.is_on){
            sex = i;
        }
        i++;
    }
    
    i = 0;
    //genreチェック無し=(genre=-1)萌え=0→8 ものまね=1→7 早口言葉=2→2
    int genre_converter[] = {8,7,2};
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            genre = genre_converter[i];
        }
        i++;
    }
    
    //HTTP Request
    HttpPost *post = [[HttpPost alloc] init];
    NSString *path = @"user/edit/";
    
   /*
    NSMutableArray *params = [[NSMutableArray alloc ] initWithObjects: [[NSMutableArray alloc] initWithObjects:@"comment",comment, nil],[[NSMutableArray alloc] initWithObjects:@"gender",sex, nil],[[NSMutableArray alloc] initWithObjects:@"tag_id",genre, nil],nil];
    */
    NSArray *params = @[
                               [@[@"comment",comment] mutableCopy],
                               [@[@"name",name] mutableCopy],
                               [@[@"gender",[NSString stringWithFormat:@"%d",sex]] mutableCopy],
                               [@[@"tag_id",[NSString stringWithFormat:@"%d",genre]] mutableCopy],
                               ];

    
    NSString *result = [post HttpPost:path params:params];
    
    NSLog(@"result: %@", result);
    
    //声優登録成功したら以下実行
    if ([result rangeOfString:@"failed"].location == NSNotFound){
        //[self performSegueWithIdentifier:@"CreateSeiyuToCompleteSeiyu" sender:self];
        
        //成功の旨のアラート
        UIAlertView *alert =[
                             [UIAlertView alloc]
                             initWithTitle : @"成功"
                             message : @"声優情報を更新しました"
                             delegate : nil
                             cancelButtonTitle : @"OK"
                             otherButtonTitles : nil
                             ];
        [alert show];

        
        self.complete_flg = true;
    } else {
        //失敗の旨のアラート
        UIAlertView *alert =[
                             [UIAlertView alloc]
                             initWithTitle : @"エラー"
                             message : @"声優名が他の人と重複しています"
                             delegate : nil
                             cancelButtonTitle : @"OK"
                             otherButtonTitles : nil
                             ];
        [alert show];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CreateSeiyuToCompleteSeiyu"]) {
        CompleteSeiyuViewController *viewController = (CompleteSeiyuViewController*)[segue destinationViewController];
        if(self.delete_flg){
            viewController.message = @"声優情報を削除しました。";
            self.delete_flg = false;
        }else{
            if([self.navigationItem.title isEqualToString:@"声優登録"]){
                viewController.message = @"声優登録が完了しました。";
            }else{
                viewController.message = @"声優情報を更新しました。";
            }
        }
    }
}

- (IBAction)toggle_sex_1_tapped:(id)sender {
    [self toggle_sex_button_tapped:sender];
}

- (IBAction)toggle_sex_2_tapped:(id)sender {
    [self toggle_sex_button_tapped:sender];
}

- (IBAction)toggle_sex_3_tapped:(id)sender {
    [self toggle_sex_button_tapped:sender];
}

- (IBAction)toggle_genre_1_tapped:(id)sender {
    [self toggle_genre_button_tapped:sender];
}

- (IBAction)toggle_genre_2_tapped:(id)sender {
    [self toggle_genre_button_tapped:sender];
}

- (IBAction)toggle_genre_3_tapped:(id)sender {
    [self toggle_genre_button_tapped:sender];
}

- (void)toggle_sex_button_tapped:(id)sender{
    for (UIToggleButton *button in self.buttons_sex) {
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}
- (void)toggle_genre_button_tapped:(id)sender{
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}

- (IBAction)text_name_begin:(id)sender {
    [self.button_edit_end setHidden:NO];
    [self.label_comment setHidden:YES];
    [self.textview_comment setHidden:YES];
}
- (IBAction)text_name_end:(id)sender {
    [self.button_edit_end setHidden:YES];
    [self.label_comment setHidden:NO];
    [self.textview_comment setHidden:NO];
    [self resignFirstResponder];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.button_edit_end setHidden:NO];
    [self.label_name setHidden:YES];
    [self.text_name setHidden:YES];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.textview_comment.frame;
        frame.origin.y -= 50;
        frame.size.height += 100;
        self.textview_comment.frame = frame;
        frame = self.label_comment.frame;
        frame.origin.y -= 50;
        self.label_comment.frame = frame;
    }];
    
    return YES;
}
- (void)button_edit_end_tapped:(id)sender{
    [self.button_edit_end setHidden:YES];
    if(self.label_comment.hidden){
        [self.text_name endEditing:YES];
        //[self resignFirstResponder];
        [self.label_comment setHidden:NO];
        [self.textview_comment setHidden:NO];
    }else{
        [self.textview_comment resignFirstResponder];
        [self.label_name setHidden:NO];
        [self.text_name setHidden:NO];
        
        [UIView animateWithDuration:0.2f animations:^{
            CGRect frame = self.textview_comment.frame;
            frame.origin.y += 50;
            frame.size.height -= 100;
            self.textview_comment.frame = frame;
            frame = self.label_comment.frame;
            frame.origin.y += 50;
            self.label_comment.frame = frame;
        }];
    }
}
@end
