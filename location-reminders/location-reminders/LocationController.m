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
        
        _locationsArray = [[NSMutableArray alloc]initWithArray: [self generateLocations]];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.delegate locationControllerUpdatedLocation:locations.lastObject];
    
    [self setLocation:locations.lastObject]; // re-set the location every time the manager updates the location
    
}

-(NSMutableArray *)generateLocations {
    
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    
    MKPointAnnotation *fremontTroll = [self createAnnotationWithLatitude:47.6510 andLongitude:-122.3473 andTitle:@"Fremont Troll"];
    MKPointAnnotation *spaceNeedle = [self createAnnotationWithLatitude:47.6205 andLongitude:-122.3493 andTitle:@"Space Needle"];
    MKPointAnnotation *suzzallo = [self createAnnotationWithLatitude:47.6557 andLongitude:-122.3100 andTitle:@"Suzzallo Library"];
    MKPointAnnotation *smithTower = [self createAnnotationWithLatitude:47.6019 andLongitude:-122.3339 andTitle:@"Smith Tower"];
    MKPointAnnotation *volunteerPark = [self createAnnotationWithLatitude:47.6321 andLongitude:-122.3179 andTitle:@"Volunteer Park Conservatory"];
    
    [locations addObject:fremontTroll];
    [locations addObject:spaceNeedle];
    [locations addObject:suzzallo];
    [locations addObject:smithTower];
    [locations addObject:volunteerPark];
    
    return locations;
}

-(MKPointAnnotation *)createAnnotationWithLatitude:(float)latitude andLongitude:(float)longitude andTitle:(NSString *)title {
    
    CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKPointAnnotation *newLocation = [[MKPointAnnotation alloc]init];
    newLocation.title = title;
    newLocation.coordinate = newCoordinate;
    
    return newLocation;
}


@end
