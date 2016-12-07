//
//  DetailViewController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/6/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Annotation With Title: %@ - Lat: %.3f, Long: %.3f",
          self.annotationTitle,
          self.coordinate.latitude,
          self.coordinate.longitude);
}


- (IBAction)saveReminderPressed:(UIButton *)sender {
    
    // placeholder data (replace w/text field input in homework)
    NSString *reminderTitle = @"New Reminder";
    NSNumber *radius = [NSNumber numberWithFloat:100.0];
    
    Reminder *newReminder = [Reminder object];
    newReminder.title = reminderTitle;
    newReminder.radius = radius;
    
    PFGeoPoint *reminderPoint = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    newReminder.location = reminderPoint;
    
    // send a notification that a reminder was saved.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderCreated" object:nil];
    
    if (self.completion) {
        MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue];
        self.completion(newCircle);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end











