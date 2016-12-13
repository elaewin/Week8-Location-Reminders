//
//  LocationController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/6/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "LocationController.h"
#import "Reminder.h"
#import "ErrorDomainInformation.h"
@import NotificationCenter;
@import UserNotifications;

@interface LocationController () <CLLocationManagerDelegate>

@end

@implementation LocationController

+(instancetype) sharedController {
    
    static LocationController *sharedController;
    
    static dispatch_once_t onceToken; // Get the singleton code snippet from Xcode!
    dispatch_once(&onceToken, ^{
        sharedController = [[LocationController alloc]init];
    });
    
    return sharedController;
}

-(instancetype)init {
    self = [super init];
    
    if (self) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 100; // distance in meters.
        
        [_manager requestAlwaysAuthorization]; // in a full app, better to request this at a specific point when needed, and not up front (as we're doing here.)
        
        _locationsArray = [[NSMutableArray alloc]initWithArray: [self generateLocations]];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.delegate locationControllerUpdatedLocation:locations.lastObject];
    
    [self setLocation:locations.lastObject]; // re-set the location every time the manager updates the location
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started monitoring region for: %@", region);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"User DID ENTER REGION (%@). No bug!", region);
}

-(MKPointAnnotation *)createAnnotationWithLatitude:(float)latitude andLongitude:(float)longitude andTitle:(NSString *)title {
    
    CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKPointAnnotation *newLocation = [[MKPointAnnotation alloc]init];
    newLocation.title = title;
    newLocation.coordinate = newCoordinate;
    
    return newLocation;
}

-(NSMutableArray *)generateLocations {
    
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    
    MKPointAnnotation *fremontTroll = [self createAnnotationWithLatitude:47.6510 andLongitude:-122.3473 andTitle:@"Fremont Troll"];
    MKPointAnnotation *spaceNeedle = [self createAnnotationWithLatitude:47.6205 andLongitude:-122.3493 andTitle:@"Space Needle"];
    MKPointAnnotation *suzzallo = [self createAnnotationWithLatitude:47.6557 andLongitude:-122.3100 andTitle:@"Suzzallo Library"];
    MKPointAnnotation *smithTower = [self createAnnotationWithLatitude:47.6019 andLongitude:-122.3339 andTitle:@"Smith Tower"];
    MKPointAnnotation *volunteerPark = [self createAnnotationWithLatitude:47.632 andLongitude:-122.316 andTitle:@"Volunteer Park Conservatory"];
    
    [locations addObject:fremontTroll];
    [locations addObject:spaceNeedle];
    [locations addObject:suzzallo];
    [locations addObject:smithTower];
    [locations addObject:volunteerPark];
    
    return locations;
}

// Error handling
-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"ERROR: %@", error.localizedDescription);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error.localizedDescription);
}

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error.localizedDescription);
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited Region!");
}

// MARK: Notifications

-(UIColor *)getRandomColor {
    NSArray *colors = @[[UIColor blueColor], [UIColor brownColor], [UIColor cyanColor], [UIColor greenColor], [UIColor lightGrayColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor redColor], [UIColor yellowColor]];
    
    int index = arc4random_uniform((uint32_t)colors.count);
    
    return colors[index];
}

-(void)createNotificationForRegion:(CLRegion *)region withName:(NSString *)reminderName andBody:(NSString *)body {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"Location Reminder";
    content.subtitle = reminderName;
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];
    
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:reminderName content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            
            NSDictionary *errorDictionary = @{@"Description": @"User Notification Creation Error", NSLocalizedDescriptionKey: @"Failed to add location alert to UNNotificationCenter."};
            
            NSError *addNotificationError = [NSError errorWithDomain:locationRemindersErrorDomain code:UserNotificationCreationFailure userInfo:errorDictionary];
            
            NSLog(@"Error: %@ - %@", addNotificationError, addNotificationError.localizedDescription);
        } else {
            NSLog(@"No error adding notification.");
        }
    }];
}

-(MKCircle *)beginMonitoringCircularRegion:(Reminder *)reminder {
    // This creates the CLLocationCoordinate2D struct
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        
        CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:coordinate radius:reminder.radius.floatValue identifier:reminder.title];
        
        [self.manager startMonitoringForRegion:region];
        
        [self createNotificationForRegion:region withName:reminder.title andBody:reminder.body];
    }
    
    MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:reminder.radius.floatValue];
    
    return newCircle;
}

@end
