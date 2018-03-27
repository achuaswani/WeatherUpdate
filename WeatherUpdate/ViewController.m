
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

//Change the scale "si" is celsius and "us" is farenheit
-(IBAction) changeScale:(id) sender{
    // get current scale data from model
    WeatherData *weatherDat = [WeatherData sharedInstance];
    NSLog(@"self.weatherDat%@",[weatherDat scale]);
    // This button behaves like switch
    if([[weatherDat scale] isEqualToString:@"us"]){
        [weatherDat setScale:@"si"];
        self.lblCurrentTempScale.text = @"Celsius";
    }else{
        [weatherDat setScale:@"us"];
        self.lblCurrentTempScale.text = @"Farenheit";
    }
    //Call webservice after getting the required scale
    ws = [[WebServices alloc]init];
    [weatherDat updateURL];
    [ws webserviceCall:^(BOOL finished) {
        if(finished){
            // update view with updated values
            [self updateUI];
        }
    }];

}


//Uodate Entire UI with latest values on demand
-(void)updateUI{
    WeatherData *weatherDat = [WeatherData sharedInstance];
    tableData = [[[weatherDat currentTableData] objectForKey:@"response"] mutableCopy];
    [self.tblView reloadData];
    [self.lblSummary setText:[weatherDat currentSummary]];
    [self.lblTemperatureNow setText:[weatherDat currentTemprature]];
    [self.lblTempType setText:[weatherDat currentPrecipType]];
    [self.lblCurrentDay setText: [weatherDat currentTime]];
    [self.lblHighTemp setText:[NSString stringWithFormat:@"Humidity: %@",[weatherDat currentHumidity]]];
    [self.lblLowTemp setText:[NSString stringWithFormat:@"Feels Like: %@",[weatherDat currentFeelsLike]]];
    NSLog(@"[weatherDat currentWeatherIcon], %@",[weatherDat currentWeatherIcon]);
    UIImage *weatherImage = [self getWeatherIcon:[weatherDat currentWeatherIcon] withflg:true];
    [self.weatherIcon setImage:weatherImage];
    self.lblCityName.text =  [weatherDat adressFromLatLong];
}

//This function determines which icon needs to show for weather forecast
-(UIImage *)getWeatherIcon: (NSString*)weatherIcontxt withflg: (BOOL)flg {
    UIImage *weatherImage = [UIImage imageNamed:@"clear-day.png"];
    NSLog(@"weatherIconstr %@",weatherIcontxt);
    if( [weatherIcontxt isEqualToString: @"cloudy"]){
        weatherImage = [UIImage imageNamed:@"rainbg.png"];
        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"bg.png"]];
        }
    }else if([weatherIcontxt isEqualToString: @"clear-day"]){
        weatherImage = [UIImage imageNamed:@"clear-day.png"];
        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"bg.png"]];
        }
    }else if([weatherIcontxt isEqualToString:@"clear-night"]){
        weatherImage = [UIImage imageNamed:@"clear-night.png"];
        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"rainbg.png"]];
        }
    }else if([weatherIcontxt isEqualToString:@"rain"]){
        weatherImage = [UIImage imageNamed:@"rain.png"];

        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"rainbg.png"]];
        }
    }else if([weatherIcontxt isEqualToString:@"snow"]){
        weatherImage = [UIImage imageNamed:@"snow.png"];
    }else if([weatherIcontxt isEqualToString:@"sleet"]){
        weatherImage = [UIImage imageNamed:@"sleet.png"];
    }else if([weatherIcontxt isEqualToString:@"wind"]){
        weatherImage = [UIImage imageNamed:@"wind.png"];
    }else if([weatherIcontxt isEqualToString:@"fog"]){
        
        weatherImage = [UIImage imageNamed:@"fog.png"];
        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"rainbg.png"]];
        }
    }else if([weatherIcontxt isEqualToString:@"partly-cloudy-day"]){
        weatherImage = [UIImage imageNamed:@"partly-cloudy-day.png"];
        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"bg.png"]];
        }
    }else if([weatherIcontxt isEqualToString:@"partly-cloudy-night"]){
        weatherImage = [UIImage imageNamed:@"partly-cloudy-night.png"];
        NSLog(@"rain--- %i",flg);

        if(flg){
            [self.imgView setImage:[UIImage imageNamed:@"rainbg.png"]];
        }
    }
    return weatherImage;
}


// On load
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"load");
    WeatherData *weatherDat= [WeatherData sharedInstance];
    //Default scale as "us"
    [weatherDat setScale:@"us"];
    self.lblCurrentTempScale.text = @"Farenheit";

    locationService = [[LocationManager alloc]init];
    //update ui with current location weather
    [locationService getCurrentLocation:^(BOOL finished) {
        if(finished){
            [self updateUI];
        }
    }];
    
    NSLog(@"call %@",weatherDat.scale);
    self.lblCityName.text =  [weatherDat adressFromLatLong];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //Update UI on dismiss after getting search location
    [self updateUI];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //table view row count
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Configure table view cell
    static NSString *simpleTableIdentifier = @"DailyWeatherCel";
    
    DailyWeatherCel *cell = (DailyWeatherCel *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DailyWeatherCel" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //Update cell with weather data for 8 days
    WeatherData *weatherDat = [WeatherData sharedInstance];
    NSDictionary *tblItem = [tableData objectAtIndex:indexPath.row];
    NSString *date = [weatherDat getCurrentDateFromUTC:tblItem[@"time"] withdatereq:true];
    cell.lblday.text = date;
    NSString *weatherIconstr = tblItem[@"icon"];
    NSLog(@"condition: %@", weatherIconstr);
    UIImage *weatherImage = [self getWeatherIcon:weatherIconstr withflg:false];
    cell.cellWeatherIcon.image = weatherImage;
    int temperatureHigh = (int)[tblItem[@"temperatureHigh"] integerValue];
    int temperatureLow = (int)[tblItem[@"temperatureLow"] integerValue];

    cell.lblhigh.text = [NSString stringWithFormat:@"%i",temperatureHigh];
    cell.lbllow.text = [NSString stringWithFormat:@"%i",temperatureLow];
    return cell;
}

@end
