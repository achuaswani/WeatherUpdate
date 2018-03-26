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
            NSLog(@"weatherData: %@ %@", weatherData.longitude, weatherData.latitude );
         
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


-(void)getCordinatesFromZip:(NSString*)zipOrCity completioncallback: (responseblock)completion{
    
    //NSDictionary *center= [self getLocationFromAddressString:zipOrCity];
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
             NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",
                                  mark.thoroughfare,
                                  mark.locality,
                                  mark.subLocality,
                                  mark.administrativeArea,
                                  mark.postalCode,
                                  mark.country];
             NSLog(@"AddressTyyoo---%@",  address);
            [weatherData setLocation:lat withLongi:lng withLocation:[NSString stringWithFormat:@"%@",mark.locality]];
            NSDictionary *dict = @{@"latitude":[NSString stringWithFormat:@"%.2f",lat] ,@"longitude":[NSString stringWithFormat:@"%.2f",lng]};
            completion(dict);
         }
     }];
}
@end
