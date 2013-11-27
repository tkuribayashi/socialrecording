//
//  RetrieveCookie.m
//  tableview
//
//  Created by 北口 善紀 on 2013/10/31.
//  Copyright (c) 2013年 北口 善紀. All rights reserved.
//

#import "RetrieveCookie.h"

@implementation RetrieveCookie

//csrfトークンの値を取得
//POSTリクエストの際には、csrfmiddlewaretokenという属性にcsrfトークンの値を設定すればよい
- (NSString *)getcsrftoken {
    
    NSHTTPCookieStorage *storage = [ NSHTTPCookieStorage sharedHTTPCookieStorage ];
    NSArray *cookies = [ storage cookiesForURL:[ NSURL URLWithString : @"http://49.212.174.30" ] ];
    
    // Cookie処理ループ
    for (NSHTTPCookie *cookie in cookies) {
        // 目的のCookieが見つかったら値を返す
        if ([ cookie.name isEqualToString: @"csrftoken" ]) {
            NSString *csrftoken = cookie.value;
            NSLog(@"csrftoken=%@", csrftoken);
            return csrftoken;
        }
    }
    
    return nil;
}

//リクエストに必要なクッキーを取得
- (NSString *)setcookie {
    
    // リクエストを作成し、送信します
    NSString *urlString = [NSString stringWithFormat:@"http://49.212.174.30/sociareco/api/login/?token=%@",[self getUUID]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request  queue:[[NSOperationQueue alloc] init]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // 受け取ったレスポンスから、Cookieを取得します。
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
        
        // 受け取ったCookieのうち必要なものは、
        // 保存しておくと今後使う時に便利です。
        for (int i = 0; i < cookies.count; i++) {
            NSHTTPCookie *cookie = [cookies objectAtIndex:i];
            NSLog(@"cookie: name=%@, value=%@", cookie.name, cookie.value);
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }];
    
    return self.getcsrftoken; //csrfトークンの値を返す
}

-(NSString*)getUUID{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *my_token = @"test";(NSString *)[ud objectForKey:@"my_token"];
    if (my_token) {
        return my_token;
    }else{
        //create a new UUID
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        //get the string representation of the UUID
        NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
        [ud setObject:uuidString forKey:@"my_token"];
        [ud synchronize];
        CFRelease(uuidObj);
        return uuidString;
    }
}
@end
