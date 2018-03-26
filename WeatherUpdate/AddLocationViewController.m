//
//  AddLocationViewController.m
//  WeatherUpdate
//
//  Created by Aswani on 3/25/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import "AddLocationViewController.h"
#import "LocationManager.h"
#import "WebServices.h"
#import "ViewController.h"
@interface AddLocationViewController () <UISearchControllerDelegate, UISearchBarDelegate>

@end

@implementation AddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (void)willPresentSearchController:(UISearchController *)searchController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        searchController.searchResultsController.view.hidden = NO;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = self.searchController.text;
    NSLog(@"search--%@",searchString);
    if (searchString != nil && ![searchString  isEqual: @""]) {
        LocationManager *locationservice = [[LocationManager alloc]init];
        [locationservice getCordinatesFromZip:searchString completioncallback:^(NSDictionary* finished) {
            NSLog(@"Return");
            WebServices *websrv = [[WebServices alloc]init];
            [websrv webserviceCall:^(BOOL response) {
                if(response){
                    [self dismissViewControllerAnimated:YES completion:nil];

                }
            }];
        }];
    }
}
-(IBAction) currentLocation:(id) sender{
    LocationManager *locationservice = [[LocationManager alloc]init];

    [locationservice getCurrentLocation:^(BOOL finished) {
        if(finished){
            [self dismissViewControllerAnimated:YES completion:nil];

            
        }
    }];
}

@end
