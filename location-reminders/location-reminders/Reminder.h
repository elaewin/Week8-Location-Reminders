//
//  Reminder.h
//  location-reminders
//
//  Created by Erica Winberry on 12/7/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <Parse/Parse.h>

@interface Reminder : PFObject <PFSubclassing>

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSNumber *radius; // radius around a geopoint
@property(strong, nonatomic) PFGeoPoint *location;

@end
