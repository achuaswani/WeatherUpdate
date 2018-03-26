//
//  ViewController.h
//  WeatherUpdate
//
//  Created by Aswani on 3/24/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnTemperatureScale;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblTempType;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDay;
@property (weak, nonatomic) IBOutlet UILabel *lblHighTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblLowTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTempScale;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperatureNow;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;



-(void)updateUI;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

