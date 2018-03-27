//
//  WeatherData.m
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData
@synthesize latitude;
@synthesize longitude;
@synthesize scale;
@synthesize adressFromLatLong;
@synthesize URLString;
@synthesize BASE_URL;
@synthesize baseKey;
@synthesize currentTemprature;
@synthesize currentPrecipType;
@synthesize currentTime;
@synthesize currentHumidity;
@synthesize currentWeatherIcon;
@synthesize currentFeelsLike;
@synthesize currentSummary;
+ (id)sharedInstance
{
    static WeatherData *sharedweatherData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // If there isn't already an instance created then alloc init one.
        sharedweatherData = [[self alloc] init];
    });
    // Return the sharedInstance of our class.
    return sharedweatherData;
}
-(NSString *) getCurrentDateFromUTC: (NSString *)epochTime withdatereq:(BOOL)dateReq{
    
    // Convert NSString to NSTimeInterval
    NSTimeInterval seconds = [epochTime doubleValue];
    
    // Create NSDate object
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSLog (@"Epoch time %@ equates to UTC %@", epochTime, epochNSDate);
    
    // se NSDateFormatter to display epochNSDate in local time zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(dateReq){
        [dateFormatter setDateFormat:@"MM/dd"];
    }else{
        [dateFormatter setDateFormat:@"HH"];
    }
    
    NSLog (@"Epoch time %@ equates to %@", epochTime, [dateFormatter stringFromDate:epochNSDate]);
    
    // Display your current time zone
    NSString *currentTimeZone = [[dateFormatter timeZone] abbreviation];
    NSLog (@"(Your local time zone is: %@)", currentTimeZone);
    return [dateFormatter stringFromDate:epochNSDate];
}
-(void)updateVariable: (NSDictionary*)jsonResponse{
    NSDictionary *currentDay = jsonResponse[@"currently"];
    NSLog(@"Response: %@", currentDay[@"summary"]);
    if([currentDay[@"temperature"] description]!=nil){
        int tempratureInt = (int)[currentDay[@"temperature"] integerValue];
        self.currentTemprature = [NSString stringWithFormat:@"%i",tempratureInt];
    }
    if([currentDay[@"summary"] description]!=nil){
        self.currentPrecipType = [currentDay[@"summary"] description];
    }
    if([currentDay[@"time"] description]!=nil){
        self.currentTime = [self getCurrentDateFromUTC:[currentDay[@"time"] description] withdatereq:true];
    }
    if([currentDay[@"humidity"] description]!=nil){
        self.currentHumidity = [currentDay[@"humidity"] description];
    }
    if([currentDay[@"apparentTemperature"] description]!=nil){
        int tempraturefeelsInt = (int)[currentDay[@"apparentTemperature"] integerValue];

        self.currentFeelsLike = [NSString stringWithFormat:@"%i",tempraturefeelsInt];
    }
    if([currentDay[@"icon"]description] !=nil){
        self.currentWeatherIcon = [NSString stringWithFormat:@"%@",currentDay[@"icon"]];
    }
    NSLog(@"condition: %@", self.currentWeatherIcon);
    //self.currentWeatherImage = [self getWeatherIcon:self.currentWeatherIcon:true];
    NSLog(@"jsonResponse%@",jsonResponse[ @"daily"]);
    self.currentTableData = [NSUserDefaults standardUserDefaults];
    NSDictionary *jsonval = [jsonResponse objectForKey:@"daily"];
    NSArray *resultData = [jsonval objectForKey:@"data"];
    self.currentSummary = [jsonval objectForKey:@"summary"];
    [self.currentTableData setObject:resultData  forKey:@"response"];
}
-(void)updateURL{
    self.BASE_URL = @"https://api.darksky.net/forecast";
    self.baseKey = @"b209e1bc8e76e20e7013d9e0def2c2fc";
    NSLog(@"self.scale %@",self.scale);
    if(self.scale == nil){
        self.scale = @"us";
    }
    self.URLString = [NSString stringWithFormat:@"%@/%@/%@,%@?units=%@&exclude=minutely,hourly,alerts,flags", self.BASE_URL, self.baseKey,latitude,longitude,self.scale];
    NSLog(@"updated url: %@",self.URLString);
}
-(void)setLocation: (float)lat withLongi:(float)longi withLocation:(NSString*)location{
    self.longitude = [NSString stringWithFormat:@"%.8f",longi];
    self.latitude = [NSString stringWithFormat:@"%.8f", lat];
    self.adressFromLatLong = location;
    NSLog(@"adressFromLatLong: %@",location);

    [self updateURL];
    
}

@end
