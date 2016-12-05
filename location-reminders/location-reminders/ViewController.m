//
//  ViewController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/5/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "ViewController.h"

@import Parse;

@import MapKit;

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;

@property (weak, nonatomic) IBOutlet UIButton *setAnotherLocationButton;

@property (weak, nonatomic) IBOutlet UIButton *setLastLocationButton;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    // PFObject = base class obj for Parse
    //     Testing to make sure the server is working
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    
//    testObject[@"foo"] = @"bar";
//    
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//            return;
//        }
//        
//        if (succeeded) {
//            NSLog(@"Successfully saved testObject");
//        }
//    }];

    //Test to make sure querying works
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            // how to return to main queue in obj-c:
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"%@", objects);
            }];
        }
    }];

    [self requestPermissions];
    [self.mapView setShowsUserLocation:YES];
    
}

-(void)requestPermissions {
    
    //This line is the same as: self.locationManager = [[CLLocationManager alloc]init];
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [self.locationManager requestWhenInUseAuthorization];
    
}

-(IBAction)setLocationPressed:(id)sender {
    
    // CLLocationCoordinate2D = struct, so no * for pointer needed on coordinate variable.
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-23.4423, 151.9148);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 700, 700);
    
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)setAnotherLocationPressed:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6510, -122.3473);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
    
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)setFinalLocationPressed:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(51.5074, -0.1278);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    
    [self.mapView setRegion:region animated:YES];
    
}


@end
