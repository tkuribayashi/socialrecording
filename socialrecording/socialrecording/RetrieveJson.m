//
//  RetrieveJson.m
//  socialrecording
//
//  Created by taku on 2013/10/16.
//  Copyright (c) 2013年 taku. All rights reserved.
//
//
//"http://49.212.174.30/sociareco/api/"に続くパス、パラメータを引数に渡してください！
//JSONをNSMutableArrayで返します！
//

#import "RetrieveJson.h"

@implementation RetrieveJson

/* JSONを返すAPIにアクセス */
- (NSMutableArray *)retrieveJson:(NSString *)param{
	NSLog(@"%s %@", __func__, param);
    // 引数からURLを生成
    NSString *url = [NSString stringWithFormat:@"http://49.212.174.30/sociareco/api/%@", param];
    NSLog(@"%@",url);
    //URLからリクエストを生成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    NSLog(@"request ready");
    //結果をNSDataで受け取る
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSLog(@"received json");
    //NSStringに変換(クオテーション処理)
    NSString *jsonstring = [[[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding: NSNonLossyASCIIStringEncoding] stringByReplacingOccurrencesOfString: @"&quot;" withString: @"\""];
    NSLog(@"%@", jsonstring);
    //NSDataに戻す
    data = [jsonstring dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSError * error;
    //JSONをパース
    json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
    //NSLog(@"%@",json);
    
    return json;
}

/* JSONを返さないAPI(vote, view etc.)にアクセス */
- (void)accessServer:(NSString *)param{NSLog(@"%s", __func__);
    // 引数からURLを生成
    NSString *url = [NSString stringWithFormat:@"http://49.212.174.30/sociareco/api/%@", param];
    
    //URLからリクエストを生成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    
    //結果をNSDataで受け取る
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];

    //NSStringに変換(クオテーション処理)
    NSString *jsonstring = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding: NSNonLossyASCIIStringEncoding];
    NSLog(@"%@", jsonstring);

}


@end