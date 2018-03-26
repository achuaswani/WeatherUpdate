//
//  WeatherData.h
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject
{
    NSString* scale;
    NSString *latitude;
    NSString *longitude;
    NSString *adressFromLatLong;
    NSString *URLString;
    NSString *baseKey;
    NSString *BASE_URL;
}
@property (nonatomic, strong) NSString* scale;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong)NSString *adressFromLatLong;
@property (nonatomic, strong) NSString *BASE_URL;
@property (nonatomic, strong) NSString *baseKey;
@property( nonatomic,strong) NSString *URLString;
@property(nonatomic, strong) NSString *currentTemprature;
@property(nonatomic, strong) NSString *currentPrecipType;
@property(nonatomic, strong) NSString *currentTime;
@property(nonatomic, strong) NSString *currentHumidity;
@property(nonatomic, strong) NSString *currentPressure;
@property(nonatomic, strong) NSString *currentWeatherIcon;
@property(nonatomic, assign) NSUserDefaults *currentTableData;
-(void)updateVariable: (NSDictionary*)jsonResponse;
-(void)setLocation:(float)latitude withLongi:(float)longi withLocation:(NSString*)location;
-(void)updateURL;
-(NSString *) getCurrentDateFromUTC: (NSString *)epochTime withdatereq: (BOOL)dateReq;
+ (id)sharedInstance;
@end
