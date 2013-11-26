//
//  HttpPost.h
//  socialrecording
//
//  Created by taku on 11/20/13.
//  Copyright (c) 2013 taku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpPost : NSObject {
    NSString *result;
}

- (NSString *)HttpPost:(NSString *)path params:(NSArray *)params;

@end
