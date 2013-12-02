//
//  playVoice.m
//  socialrecording
//
//  Created by taku on 12/2/13.
//  Copyright (c) 2013 taku. All rights reserved.
//

#import "playVoice.h"
#import "RetrieveJson.h"

@implementation playVoice


-(void) playVoice:(NSMutableArray *)voice_data :(NSIndexPath *)indexPath{
    //HTTP Request
    // request
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Caches/temp.caf",[paths objectAtIndex:0]];
    
    NSString *reqFilePath = voice_data[indexPath.row][@"vfile"];
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
        NSString *voice_id = voice_data[indexPath.row][@"id"];
        RetrieveJson *json = [[RetrieveJson alloc]init];
        [json accessServer:[NSString stringWithFormat:@"voice/%@/view/",voice_id]];
    } else {
        NSLog(@"failed playing");
    }
}


@end
