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



//This method is to get current location
-(void)getCurrentLocation: (finshedblck)completion{
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
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSString *cityname = @"";
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         cityname = placemark.locality;
         
            [weatherData setLocation: coordinate.latitude withLongi: coordinate.longitude withLocation: cityname];
         
            [webservice webserviceCall:^(BOOL finished) {
                if(finished){
                    completion(true);
                }
            }];
         }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
   
}

//This method is to get latitude longitude from zip or city
-(void)getCordinatesFromZip:(NSString*)zipOrCity completioncallback: (responseblock)completion{
    
    WeatherData *weatherData = [WeatherData sharedInstance];
    CLGeocoder* gc = [[CLGeocoder alloc] init];
    [gc geocodeAddressString:zipOrCity completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count]>0)
         {
             // get the first one
             CLPlacemark* mark = (CLPlacemark*)[placemarks objectAtIndex:0];
             float lat = mark.location.coordinate.latitude;
             float lng = mark.location.coordinate.longitude;
             
            [weatherData setLocation:lat withLongi:lng withLocation:[NSString stringWithFormat:@"%@",mark.locality]];
            NSDictionary *dict = @{@"latitude":[NSString stringWithFormat:@"%.2f",lat] ,@"longitude":[NSString stringWithFormat:@"%.2f",lng]};
            completion(dict);
         }
     }];
}
@end
