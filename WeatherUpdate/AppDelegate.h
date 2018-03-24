//
//  AppDelegate.h
//  WeatherUpdate
//
//  Created by Aswani on 3/24/18.
//  Copyright © 2018 Aswani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

