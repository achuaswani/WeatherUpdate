//
//  LocationManager.m
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import "LocationManager.h"
#import "WebServices.h"
#import "WeatherData.h"
@implementation LocationManager
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
WebServices *webservice;



- (NSString*) getAddressFromLatLon:(CLLocation *)bestLocation
{
    NSString *cityNm = @"";
    NSLog(@"best loctn %f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);
         
     }];
    return cityNm;
}
-(void)getCurrentLocation: (finshedblck)completion{
    NSLog(@"getCurrent");
    WeatherData *weatherData = [WeatherData sharedInstance];

    locationManager = [[CLLocationManager alloc] init];
    webservice = [[WebServices alloc]init];

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
     locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f,longitude:%f",coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",str);
    NSString *cityname = [self getAddressFromLatLon: location];
    [weatherData setLocation: coordinate.latitude withLongi: coordinate.longitude withLocation: cityname];
    NSLog(@"weatherData: %@ %@", weatherData.longitude, weatherData.latitude );
    
    [webservice webserviceCall:^(BOOL finished) {
        if(finished){
            completion(true);
        }
    }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
   
}
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *location =@"";
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?key=AIzaSyAMOz1RvTye415PD-Y39J4jBIpOvelEc0Q&sensor=false&address=%@", esc_addr];
    NSLog(@"req%@",req);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"strresult:, %@",result);
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
            if ([scanner scanUpToString:@"\"long_name\" :" intoString:nil] && [scanner scanString:@"\"long_name\" :" intoString:nil]) {
                [scanner scanUpToCharactersFromSet:@"long_name" intoString:&location];

            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"location: %@",location);
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}

-(void)getCordinatesFromZip:(NSString*)zipOrCity completioncallback: (responseblock)completion{
    
    CLLocationCoordinate2D center= [self getLocationFromAddressString:zipOrCity];
    WeatherData *weatherData = [WeatherData sharedInstance];
    

    [weatherData setLocation:center.latitude withLongi:center.longitude withLocation:zipOrCity];
    //[weatherData setAdressFromLatLong:zipOrCity];
    NSDictionary *dict = @{@"latitude":[NSString stringWithFormat:@"%.2f",center.latitude] ,@"longitude":[NSString stringWithFormat:@"%.2f",center.longitude]};
    completion(dict);
}
@end
