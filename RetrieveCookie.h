//
//  RetrieveCookie.h
//  tableview
//
//  Created by 北口 善紀 on 2013/10/31.
//  Copyright (c) 2013年 北口 善紀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetrieveCookie : NSString {
    NSString *retrievecookie;
}

- (NSString *)getcsrftoken;
- (NSString *)setcookie;

@end
