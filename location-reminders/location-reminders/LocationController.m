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

-(NSMutableArray *)generateLocations {
    
    NSMutableArray *seedLocations = [[NSMutableArray alloc]init];
    
    NSDictionary *fremontTroll = @{@"latitude": @47.6510, @"longitude": @-122.3473, @"name": @"Fremont Troll"};
    NSDictionary *spaceNeedle = @{@"latitude": @47.6205, @"longitude": @-122.3493, @"name": @"Space Needle"};
    NSDictionary *suzzallo = @{@"latitude": @47.6557, @"longitude": @-122.3100, @"name": @"Suzzallo Library"};
    NSDictionary *smithTower = @{@"latitude": @47.6019, @"longitude": @-122.3339, @"name": @"Smith Tower"};
    NSDictionary *volunteerPark = @{@"latitude": @47.6321, @"longitude": @-122.3179, @"name": @"Volunteer Park Conservatory"};
    
    [seedLocations addObject:fremontTroll];
    [seedLocations addObject:spaceNeedle];
    [seedLocations addObject:suzzallo];
    [seedLocations addObject:smithTower];
    [seedLocations addObject:volunteerPark];
    
    return seedLocations;
}

-(void)addLocationWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude andTitle:(NSString *)title {
    
    NSDictionary *newLocation = @{@"latitude": latitude, @"longitude": longitude, @"title": title};
    
    [self.annotationsArray addObject:newLocation];
    
}

-(void)createPins:(NSMutableArray *)annotationsArray {
    
}


@end
