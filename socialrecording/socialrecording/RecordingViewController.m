//
//  RecordingViewController.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/10/25.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "RecordingViewController.h"
#import "RetrieveCookie.h"
#import "SVProgressHUD.h"

@interface RecordingViewController ()

@end

@implementation RecordingViewController {
    BOOL recorded;
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
	// Do any additional setup after loading the view.
    self.recImage.hidden = true;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.label_name setText:self.toko_name];
    
    recorded = NO;
}
- (void)viewDidAppear:(BOOL)animated{
    if(self.flag_end){
        self.flag_end = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableDictionary *)setAudioRecorder
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    return settings;
}

-(void)recordFile
{
    // Prepare recording(Audio session)
    NSError *error = nil;
    self.session = [AVAudioSession sharedInstance];
    
    if ( session.inputAvailable )   // for iOS6 [session inputIsAvailable]  iOS5
    {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    }
    
    if ( error != nil )
    {
        NSLog(@"Error when preparing audio session :%@", [error localizedDescription]);
        return;
    }
    [session setActive:YES error:&error];
    if ( error != nil )
    {
        NSLog(@"Error when enabling audio session :%@", [error localizedDescription]);
        return;
    }
    
    // File Path
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    // recorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:&error];
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self setAudioRecorder] error:&error];
    
    //recorder.meteringEnabled = YES;
    if ( error != nil )
    {
        NSLog(@"Error when preparing audio recorder :%@", [error localizedDescription]);
        return;
    }
    [recorder record];
    
}


-(void)stopRecord
{
    if ( self.recorder != nil && self.recorder.isRecording )
    {
        [recorder stop];
        self.recorder = nil;
    }
    recorded = YES;
}

-(void)playRecord
{
    if (!recorded) {
        UIAlertView *alert =[
                             [UIAlertView alloc]
                             initWithTitle : @"エラー"
                             message : @"録音してください"
                             delegate : nil
                             cancelButtonTitle : @"OK"
                             otherButtonTitles : nil
                             ];
        [alert show];
        return;
    }
    
    NSError *error = nil;
    
    // File Path
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
    {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if ( error != nil )
        {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        [self.player prepareToPlay];
        [self.player play];
    }
}

- (IBAction)button_record_tapped:(id)sender {
    if ( self.recorder != nil && self.recorder.isRecording )
    {
        [self stopRecord];
        self.recImage.hidden = true;
        //[self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    else
    {
        self.recImage.hidden = false;
        [self recordFile];
        //[self.recordButton setTitle:@"..." forState:UIControlStateNormal];
    }
}

- (IBAction)button_play_tapped:(id)sender {
    [self playRecord];
}

- (IBAction)button_send_tapped:(id)sender {
    if (!recorded) {
        UIAlertView *alert =[
                             [UIAlertView alloc]
                             initWithTitle : @"エラー"
                             message : @"録音してください"
                             delegate : nil
                             cancelButtonTitle : @"OK"
                             otherButtonTitles : nil
                             ];
        [alert show];
        return;
    }

    [SVProgressHUD show];//くるくる
    [self.view setNeedsDisplay];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];


    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *pathURL = [NSURL fileURLWithPath:filePath];//File Url of the recorded audio
    NSData *voiceData = [[NSData alloc]initWithContentsOfURL:pathURL];
    NSString *urlString = @"http://49.212.174.30/sociareco/api/voice/create/"; // You can give your url here for uploading
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
        
        //パラメータはContent-Dispositionに入れる(らしい)
        NSString *param = [NSString stringWithFormat:@"token=%@&odai_id=%@",@"dummy",self.toko_id];
        
        NSLog(@"param: %@",param);
        NSLog(@"toko_id: %@", self.toko_id);
        
        
        NSMutableData *body = [NSMutableData data];
        /*[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData: [@"hogehoge" dataUsingEncoding:NSUTF8StringEncoding]];*/
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"odai_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData: [[NSString stringWithFormat:@"%@",self.toko_id] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"voice.caf\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:voiceData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];

        [request setHTTPBody:body];
        
        NSError *error = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
        UIAlertView *alert = nil;
        if(error || [returnString rangeOfString:@"failed"].length>0)
        {
            alert = [[UIAlertView alloc]initWithTitle:@"エラー" message:@"登録できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            NSLog(@"Success %@",returnString);
            alert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"ボイスが登録されました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            //投稿が成功すれば投稿完了画面へ
            //→行かないことにしました。
            self.flag_end = YES;
            //[self performSegueWithIdentifier:@"RecordingToCompleteRecording" sender:self];
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
        //[voiceData release];
        voiceData = nil;
        pathURL = nil;
        urlString = nil;
    }
    [SVProgressHUD dismiss];//くるくる
}
@end
