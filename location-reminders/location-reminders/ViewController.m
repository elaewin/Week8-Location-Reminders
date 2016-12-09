//
//  ViewController.m
//  location-reminders
//
//  Created by Erica Winberry on 12/5/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

@import MapKit;
@import Parse;
@import ParseUI;

#import "ViewController.h"
#import "DetailViewController.h"
#import "LocationController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "Reminder.h"


@interface ViewController () <LocationControllerDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *setAnotherLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *setLastLocationButton;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (!error) {
//            // how to return to main queue in obj-c:
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                NSLog(@"%@", objects);
//            }];
//        }
//    }];

    // Get reminders from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    
    __weak typeof(self) bruce = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        __strong typeof(bruce) hulk = bruce;
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu reminders.", (unsigned long)objects.count);
            
            // Do something with the found objects
            for (Reminder *reminder in objects) {
                NSLog(@"%@", reminder.objectId);
                
                MKCircle *circle = [[LocationController sharedController] beginMonitoringCircularRegion:reminder];
                [hulk.mapView addOverlay:circle];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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
    
    // add a notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderCreatedNotificationFired) name:@"ReminderCreated" object:nil];
    
    [self login];
}

-(void)dealloc {
    // can't call dealloc's super when overriding: exception to usual rule.
    
    // remove self as observer, so it doesn't cause a crash.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReminderCreated" object:nil];
}

//selector for notification
-(void)reminderCreatedNotificationFired {
    NSLog(@"Reminder was created. Log fired from %@", self);
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
            
            // assign completion for DetailViewControllerCompletion here (this is a block)
            __weak typeof(self) bruce = self;
            
            detailVC.completion = ^(MKCircle *circle) {
                __strong typeof(bruce) hulk = bruce;
                
                [hulk.mapView removeAnnotation:annotationView.annotation];
                [hulk.mapView addOverlay:circle];
                
            };
        }
        
    }
}

-(void)createAnnotations {
    
    [self.mapView addAnnotations:[[LocationController sharedController] locationsArray]];
    
//    for (MKPointAnnotation *location in [[LocationController sharedController] locationsArray]) {
//        
//        [self.mapView addAnnotation:location];
//    }
    
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

// MARK: LocationControllerDelegate Methods

-(void)locationControllerUpdatedLocation:(CLLocation *)location {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0); // 500.0 = meters centered on coordinate.
    
    [self.mapView setRegion:region];
}



// MARK: MKMapViewDelegate Methods

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
    annotationView.pinTintColor = [[LocationController sharedController] getRandomColor];
    
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    
    // in this method is where we will call a function that will assign random pin color. Want to change pin tint color.
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithOverlay:overlay];
    
    // format the overlay
    renderer.fillColor = [[LocationController sharedController] getRandomColor];
    renderer.strokeColor = [renderer.fillColor colorWithAlphaComponent:0.25];
    renderer.alpha = 0.5;
    
    return renderer;
}

// MARK: PARSE UI

-(void)login {
    if (![PFUser currentUser]) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        
        // become delegate for both ParseUI login and signup VCs
        loginVC.delegate = self;
        loginVC.signUpController.delegate = self;
        
        [self presentViewController:loginVC animated:YES completion:nil];
        
    } else {
        [self setupAdditionalUI];
    }
}

-(void)setupAdditionalUI {
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutPressed)];
    
    self.navigationItem.leftBarButtonItem = signOutButton;
}

-(void)signOutPressed {
    [PFUser logOut];
    NSLog(@"Current user signed out.");
    [self login];
}

// MARK: ParseUI Delegate Methods

-(void)logInViewController:(LoginViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

-(void)logInViewControllerDidCancelLogIn:(LoginViewController *)logInController {
    [self login];
}



@end









