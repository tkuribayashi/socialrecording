//
//  RetrieveJson.h
//  socialrecording
//
//  Created by taku on 2013/10/16.
//  Copyright (c) 2013年 taku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetrieveJson : NSObject{
    NSMutableArray *json;
    NSMutableDictionary *jsonD;
}

- (NSMutableArray *)retrieveJson:(NSString *)param;
- (NSMutableDictionary *)retrieveJsonDictionary:(NSString *)param;
- (void)accessServer:(NSString *)param;


@end
