//
//  LocationController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/6/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "LocationController.h"

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
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.delegate locationControllerUpdatedLocation:locations.lastObject];
    
    [self setLocation:locations.lastObject]; // re-set the location every time the manager updates the location
    
}

@end
