//
//  AddTokoViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/28.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "AddTokoViewController.h"
#import "RetrieveJson.h"
#import "RetrieveCookie.h"

@interface AddTokoViewController ()

@end

@implementation AddTokoViewController

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
    self.buttons_genre = @[self.toggle_button_1, self.toggle_button_2, self.toggle_button_3];
    
    self.text_comment.layer.borderWidth = 1;
    self.text_comment.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.text_comment.layer.cornerRadius = 5;
    self.text_comment.delegate = self;
    
    self.button_edit_end = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_edit_end setFrame:self.view.frame];
    [self.button_edit_end setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.button_edit_end addTarget:self action:@selector(button_edit_end_tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_edit_end setHidden:YES];
    [self.view addSubview:self.button_edit_end];
    [self.view bringSubviewToFront:self.text_comment];
}

- (void)viewWillAppear:(BOOL)animated{
    if ( self.flag_complete == YES ) {
        self.text_name.text = @"";
        self.text_comment.text = @"";
        for (UIToggleButton *button in self.buttons_genre) {
            if(button.is_on){
                [button toggle];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)toggle_button_1_tapped:(id)sender {
    [self toggle_button_tapped:sender];
}

- (IBAction)toggle_button_2_tapped:(id)sender {
    [self toggle_button_tapped:sender];
}

- (IBAction)toggle_button_3_tapped:(id)sender {
    [self toggle_button_tapped:sender];
}
- (void)toggle_button_tapped:(id)sender{
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            [button toggle];
        }
    }
    [sender toggle];
}

- (IBAction)text_name_end:(id)sender {
    [self resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.button_edit_end setHidden:NO];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.text_comment.frame;
        frame.origin.y = 85;
        frame.size.height = 200;
        self.text_comment.frame = frame;
    }];
    
    return YES;
}
- (void)button_edit_end_tapped:(id)sender{
    [self.text_comment resignFirstResponder];
    [self.button_edit_end setHidden:YES];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.text_comment.frame;
        frame.origin.y = 245;
        frame.size.height = 128;
        self.text_comment.frame = frame;
    }];
}

- (IBAction)button_add_tapped:(id)sender {
    NSString *name = self.text_name.text;
    NSString *comment = self.text_comment.text;
    int genre = -1;
    int i = 0;
    for (UIToggleButton *button in self.buttons_genre) {
        if(button.is_on){
            genre = i;
        }
        i++;
    }
    
    //未入力チェックよろしく　genreチェック無し=(genre=-1)萌え=0 ものまね=1 早口言葉=2
    
    //HTTP Request
    //新規投稿
    
    if (genre == -1){
        NSLog(@"genre not selected");
        //to do:ジャンル設定しろの旨のアラートを出すように
    } else {
        NSString *urlString = @"http://49.212.174.30/sociareco/api/odai/create/"; // You can give your url here for uploading
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        
        @try
        {
            RetrieveCookie *rc = [[RetrieveCookie alloc]init];
            
            /* cookie処理 */
            NSString *cookie = [rc getcsrftoken];
            
            if(cookie==nil){
                cookie = [rc setcookie];
            }
            /* cookie処理ここまで */
            
            
            NSLog(@"cookie: %@",cookie);
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            [request addValue:cookie forHTTPHeaderField:@"X-CSRFToken"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData: [@"hogehoge" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData: [[NSString stringWithFormat:@"%@",name] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData: [[NSString stringWithFormat:@"%@",comment] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"tag_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData: [[NSString stringWithFormat:@"%d",genre] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            
            NSError *error = nil;
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
            UIAlertView *alert = nil;
            if(error)
            {
                alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Error in Uploading the odai" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            else
            {
                NSLog(@"Success %@",returnString);
                alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Odai get uploaded" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            }
            [alert show];
            //[alert release];
            alert = nil;
            //[returnString release];
            returnString = nil;
            boundary = nil;
            contentType = nil;
            body = nil;
        }
        @catch (NSException * exception)
        {
            NSLog(@"pushLoader in ViewController :Caught %@ : %@",[exception name],[exception reason]);
        }
        @finally
        {
            urlString = nil;
        }
        
        
        self.flag_complete = YES;
        [self performSegueWithIdentifier:@"AddTokoToCompleteAddToko" sender:self];
    }
}

@end
