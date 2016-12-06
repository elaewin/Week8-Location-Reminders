//
//  LocationController.h
//  location-reminders
//
//  Created by Erica Winberry on 12/6/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

// define protocol here because is very simple & obvious to anyone else looking at the code
// (vs. in new file)
@protocol LocationControllerDelegate <NSObject>

@required // Make this method (and any others, later) required.

-(void)locationControllerUpdatedLocation:(CLLocation *)location;

@end

@interface LocationController : NSObject

@property(strong, nonatomic) CLLocationManager *manager;
@property(strong, nonatomic) CLLocation *location;
@property(strong, nonatomic) NSMutableArray *annotationsArray;

@property(weak, nonatomic) id<LocationControllerDelegate> delegate;

+(instancetype) sharedController;

-(void)addLocationWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude andTitle:(NSString *)name;
-(void)createPins:(NSMutableArray *)annotationsArray;

@end
