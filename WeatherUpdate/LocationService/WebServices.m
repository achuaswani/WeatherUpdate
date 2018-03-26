//
//  WebServices.m
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import "WebServices.h"
#import "WeatherData.h"
@implementation WebServices
WeatherData *wd;
-(void) webserviceCall: (cmpltionblck)completion {
    wd = [WeatherData sharedInstance];
    //[wd updateURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString* urlString = [wd URLString];
    NSLog(@"[wd URLString] %@",urlString);

    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"updateVariable %@", json);

            [wd updateVariable: json];
            completion(true);
        });
    }];
    
    [dataTask resume];
}
@end
