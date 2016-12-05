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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;

@property (strong, nonatomic) CLLocationManager *locationManager;

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
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566, -122.351096);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    
    [self.mapView setRegion:region animated:YES];
    
}




@end
