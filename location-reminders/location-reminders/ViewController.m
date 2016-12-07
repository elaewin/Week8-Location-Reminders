//
//  ViewController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/5/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#import "LocationController.h"

@import MapKit;
@import Parse;

@interface ViewController () <LocationControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;

@property (weak, nonatomic) IBOutlet UIButton *setAnotherLocationButton;

@property (weak, nonatomic) IBOutlet UIButton *setLastLocationButton;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];

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
    
    [[LocationController sharedController] setDelegate:self];
    self.mapView.delegate = self;
    
    [self.mapView setShowsUserLocation:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self createAnnotations];
    
    [[[LocationController sharedController] manager] startUpdatingLocation];
    
}

-(void)requestPermissions {
    
    //This line is the same as: self.locationManager = [[CLLocationManager alloc]init];
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [self.locationManager requestWhenInUseAuthorization];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            
            DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
            
            detailVC.annotationTitle = annotationView.annotation.title;
            detailVC.coordinate = annotationView.annotation.coordinate;
        }
        
    }
}

-(void)createAnnotations {
    
    for (MKPointAnnotation *location in [[LocationController sharedController] locationsArray]) {
        
        [self.mapView addAnnotation:location];
    }
    
}

-(IBAction)setLocationPressed:(id)sender {
    
    // CLLocationCoordinate2D = struct, so no * for pointer needed on coordinate variable.
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6095, -122.3256);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000);
    
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

// drop new point when long pressed on map.
- (IBAction)mapLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) { // start when determ. to be long press.
        CGPoint touchPoint = [sender locationInView:self.mapView];
        
        // get coords for when user actually touched
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newMapPoint = [[MKPointAnnotation alloc]init];
        newMapPoint.title = @"New Location!";
        newMapPoint.coordinate = touchMapCoordinate;
        
        [self.mapView addAnnotation:newMapPoint];
    }
}

-(UIColor *)getRandomColor {
    NSArray *colors = @[[UIColor blueColor], [UIColor brownColor], [UIColor cyanColor], [UIColor greenColor], [UIColor lightGrayColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor redColor], [UIColor yellowColor]];
    
    int index = arc4random_uniform(10);
    
    return colors[index];
}

// MARK: Location Controller Delegate Methods

-(void)locationControllerUpdatedLocation:(CLLocation *)location {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0); // 500.0 = meters centered on coordinate.
    
    [self.mapView setRegion:region];
}

// MARK: MKMapView Delegate Methods

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES; // have to do this so drop animates.
    annotationView.pinTintColor = [self getRandomColor];
    
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    // in this method is where we will call a function that will assign random pin color. Want to change pin tint color.
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
    
}


@end
