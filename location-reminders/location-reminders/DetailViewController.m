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

@import UserNotifications;

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
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    __weak typeof(self) bruce = self;
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        __strong typeof(bruce) hulk = bruce;
        
        if (error) {
            NSLog(@"Error saving reminder: %@", error.localizedDescription);
        } else {
            NSLog(@"Success saving new reminder to Parse: %i", succeeded);
            
            
//            Send a notification that a reminder was saved.
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderCreated" object:nil];
            
            if (hulk.completion) {
                
                // set up region monitoring
                if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                    
                    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:hulk.coordinate radius:radius.floatValue identifier:reminderTitle];
                    
                    [[LocationController sharedController].manager startMonitoringForRegion:region];
                }
                
                // draw circle on map.
                MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:hulk.coordinate radius:radius.floatValue];
                hulk.completion(newCircle);
                
                [hulk.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}




@end











