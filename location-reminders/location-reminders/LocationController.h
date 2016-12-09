//
//  LocationController.h
//  location-reminders
//
//  Created by Erica Winberry on 12/6/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"
@import CoreLocation;
@import MapKit;

// define protocol here because is very simple & obvious to anyone else looking at the code
// (vs. in new file)
@protocol LocationControllerDelegate <NSObject>

@required // Make this method (and any others, later) required.

-(void)locationControllerUpdatedLocation:(CLLocation *)location;

@end

@interface LocationController : NSObject

@property(strong, nonatomic) CLLocationManager *manager;
@property(strong, nonatomic) CLLocation *location;
@property(strong, nonatomic) NSMutableArray *locationsArray;

@property(weak, nonatomic) id<LocationControllerDelegate> delegate;

+(instancetype) sharedController;

-(MKPointAnnotation *)createAnnotationWithLatitude:(float)latitude andLongitude:(float)longitude andTitle:(NSString *)title;

-(void)createNotificationForRegion:(CLRegion *)region withName:(NSString *)reminderName andBody:(NSString *)body;

-(MKCircle *)beginMonitoringCircularRegion:(Reminder *)reminder;

-(UIColor *)getRandomColor;

@end
