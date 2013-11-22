//
//  HttpPost.m
//  socialrecording
//
//  Created by taku on 11/20/13.
//  Copyright (c) 2013 taku. All rights reserved.
//

#import "HttpPost.h"
#import "RetrieveCookie.h"

@implementation HttpPost

- (NSString *)HttpPost:(NSString *)path params:(NSArray *)params{
    NSString *urlString = [NSString stringWithFormat:@"http://49.212.174.30/sociareco/api/%@",path];
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
        
        
        for (NSArray *p in params){
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", p[0]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData: [[NSString stringWithFormat:@"%@",p[1]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSError *error = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(error)
        {
            result = @"failed";
        }
        else
        {
            result = [[NSString alloc] initWithBytes: [returnData bytes] length:[returnData length] encoding: NSNonLossyASCIIStringEncoding];
        }
        returnData = nil;
        boundary = nil;
        contentType = nil;
        body = nil;
    }
    @catch (NSException * exception)
    {
        NSLog(@"pushLoader in ViewController :Caught %@ : %@",[exception name],[exception reason]);
        
        return @"failed";
    }
    @finally
    {
        urlString = nil;
        return result;
    }

    
}

@end
