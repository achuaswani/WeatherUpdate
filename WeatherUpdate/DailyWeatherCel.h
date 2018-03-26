//
//  DailyWeatherCel.h
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyWeatherCel : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellWeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblday;
@property (weak, nonatomic) IBOutlet UILabel *lblhigh;
@property (weak, nonatomic) IBOutlet UILabel *lbllow;
@end
