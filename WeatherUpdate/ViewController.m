
//
//  ViewController.m
//  WeatherUpdate
//
//  Created by Aswani on 3/24/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DailyWeatherCel.h"
#import "LocationManager.h"
#import "WebServices.h"
@interface ViewController ()

@end

@implementation ViewController
NSArray *tableData;


LocationManager *locationService;
WebServices *ws;
-(IBAction) changeScale:(id) sender{
    WeatherData *weatherDat = [WeatherData sharedInstance];
    NSLog(@"self.weatherDat%@",[weatherDat scale]);
    if([[weatherDat scale] isEqualToString:@"us"]){
        [weatherDat setScale:@"si"];
        self.lblCurrentTempScale.text = @"Celsius";
    }else{
        [weatherDat setScale:@"us"];
        self.lblCurrentTempScale.text = @"Farenheit";
    }
    ws = [[WebServices alloc]init];
    [weatherDat updateURL];
    [ws webserviceCall:^(BOOL finished) {
        if(finished){
            [self updateUI];
        }
    }];

}



-(void)updateUI{
    WeatherData *weatherDat = [WeatherData sharedInstance];
    [self.lblTemperatureNow setText:[weatherDat currentTemprature]];
    [self.lblTempType setText:[weatherDat currentPrecipType]];
    [self.lblCurrentDay setText: [weatherDat currentTime]];
    [self.lblHighTemp setText:[weatherDat currentHumidity]];
    [self.lblLowTemp setText:[weatherDat currentPressure]];
    
    UIImage *weatherImage = [self getWeatherIcon:[weatherDat currentWeatherIcon] withflg:true];
    [self.weatherIcon setImage:weatherImage];
    tableData = [[[weatherDat currentTableData] objectForKey:@"response"] mutableCopy];
    [self.tblView reloadData];
    


}

-(UIImage *)getWeatherIcon: (NSString*)weatherIcontxt withflg: (BOOL)flg {
    UIImage *weatherImage = [UIImage imageNamed:@"clear-day.png"];
    NSLog(@"weatherIconstr %@",weatherIcontxt);
    if( [weatherIcontxt isEqualToString: @"cloudy"]){
        weatherImage = [UIImage imageNamed:@"cloudy.png"];
//        if(flg){
//            [self.imgView setImage:[UIImage imageNamed:@"bg.png"]];
//        }
    }else if([weatherIcontxt isEqualToString: @"clear-day"]){
        weatherImage = [UIImage imageNamed:@"clear-day.png"];
//        if(flg==false){
//            [self.imgView setImage:[UIImage imageNamed:@"bg.png"]];
//        }
    }else if([weatherIcontxt isEqualToString:@"clear-night"]){
        weatherImage = [UIImage imageNamed:@"clear-night.png"];
//        if(flg){
//            [self.imgView setImage:[UIImage imageNamed:@"nightbg.png"]];
//        }
    }else if([weatherIcontxt isEqualToString:@"rain"]){
        weatherImage = [UIImage imageNamed:@"rain.png"];
        NSLog(@"rain %i",flg);

//        if(flg==false){
//            [self.imgView setImage:[UIImage imageNamed:@"rainybg.png"]];
//        }
    }else if([weatherIcontxt isEqualToString:@"snow"]){
        weatherImage = [UIImage imageNamed:@"snow.png"];
    }else if([weatherIcontxt isEqualToString:@"sleet"]){
        weatherImage = [UIImage imageNamed:@"sleet.png"];
    }else if([weatherIcontxt isEqualToString:@"wind"]){
        weatherImage = [UIImage imageNamed:@"wind.png"];
    }else if([weatherIcontxt isEqualToString:@"fog"]){
        weatherImage = [UIImage imageNamed:@"fog.png"];
    }else if([weatherIcontxt isEqualToString:@"partly-cloudy-day"]){
        weatherImage = [UIImage imageNamed:@"partly-cloudy-day.png"];
    }else if([weatherIcontxt isEqualToString:@"partly-cloudy-night"]){
        weatherImage = [UIImage imageNamed:@"partly-cloudy-night.png"];
    }
    return weatherImage;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"load");
    WeatherData *weatherDat= [WeatherData sharedInstance];
    [weatherDat setScale:@"us"];
    self.lblCurrentTempScale.text = @"Farenheit";

    locationService = [[LocationManager alloc]init];

    [locationService getCurrentLocation:^(BOOL finished) {
        if(finished){
            [self updateUI];
        }
    }];
    
    NSLog(@"call %@",weatherDat.scale);
    [self.lblCurrentDay setText: [weatherDat adressFromLatLong]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self updateUI];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"DailyWeatherCel";
    
    DailyWeatherCel *cell = (DailyWeatherCel *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DailyWeatherCel" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    WeatherData *weatherDat = [WeatherData sharedInstance];
    NSDictionary *tblItem = [tableData objectAtIndex:indexPath.row];
    NSString *date = [weatherDat getCurrentDateFromUTC:tblItem[@"time"] withdatereq:true];
    cell.lblday.text = date;
    NSString *weatherIconstr = tblItem[@"icon"];
    NSLog(@"condition: %@", weatherIconstr);
    UIImage *weatherImage = [self getWeatherIcon:weatherIconstr withflg:false];
    cell.cellWeatherIcon.image = weatherImage;
    cell.lblhigh.text = [NSString stringWithFormat:@"%@",tblItem[@"temperatureHigh"]];
    cell.lbllow.text = [NSString stringWithFormat:@"%@",tblItem[@"temperatureLow"]];
    
    return cell;
    return cell;
}

@end
