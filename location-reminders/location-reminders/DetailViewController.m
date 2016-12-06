//
//  DetailViewController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/6/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "DetailViewController.h"

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

@end
