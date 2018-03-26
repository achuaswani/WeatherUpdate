//
//  LocationManager.h
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject <CLLocationManagerDelegate>
typedef void(^finshedblck)(BOOL);
typedef void(^responseblock)(NSDictionary*);

-(void)getCurrentLocation: (finshedblck)completion;
- (NSString*) getAddressFromLatLon:(CLLocation *)bestLocation;
-(void)getCordinatesFromZip:(NSString*)zipOrCit completioncallback: (responseblock)completion;
@end

