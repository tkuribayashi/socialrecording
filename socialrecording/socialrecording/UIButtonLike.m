//
//  UIButtonLike.m
//  socialrecording
//
//  Created by 丹後 偉也 on 2013/12/21.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import "UIButtonLike.h"
#import "RetrieveJson.h"

@implementation UIButtonLike

- (void)setInitWithVoiceID:(NSString *)voice_id SyncLabel:(UILabel *)sync_label{
    self.voice_id = voice_id;
    self.sync_label = sync_label;
    self.like_flag = YES;
    [self setBackgroundImage:[UIImage imageNamed:@"iine_buttom.png"] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor clearColor]];
    [self addTarget:self action:@selector(button_tapped:forEvent:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)button_tapped:(id)sender forEvent:(UIEvent *)event{
    NSLog(@"like_flag: %d",self.like_flag);
    
    if (self.like_flag){
        NSLog(@"like num: %@",self.voice_id);
        
        
        RetrieveJson *json = [[RetrieveJson alloc]init];
        BOOL result = [json accessServer:[NSString stringWithFormat:@"voice/%@/vote/",self.voice_id]];
        
        self.like_flag = NO;
        
        NSLog(@"like_flag: %d",self.like_flag);
        
        //いいねタップで表示をインクリメント
        if (result){
            int like = [self.sync_label.text intValue]+ 1;
            [self.sync_label setText:[NSString stringWithFormat:@"%d",like]];
        }
    }
}

@end
