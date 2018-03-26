//
//  WebServices.h
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"
@interface WebServices : NSObject
typedef void(^cmpltionblck)(BOOL);

-(void) webserviceCall: (cmpltionblck)completion;

@end
