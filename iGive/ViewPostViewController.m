//
//  ViewPostViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/10/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "ViewPostViewController.h"
#import "RequestContactViewController.h"

@interface ViewPostViewController ()
{
    CLLocation *location;
    NSString *locationName;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationDetailsButton;
@property (weak, nonatomic) IBOutlet UIButton *requestContactButton;

@end

@implementation ViewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:[self.post objectForKey:@"title"]];
    [self.postImageView setFile:[self.post objectForKey:@"imageFile"]];
    [self.postImageView loadInBackground];
    
    PFGeoPoint *geoPoint = [self.post objectForKey:@"geoLocation"];
    location = [[CLLocation alloc]initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark  = [placemarks firstObject];
        NSDictionary *addressDictionary = placemark.addressDictionary;
        locationName = [addressDictionary objectForKey:@"Name"];
        [self.locationDetailsButton setTitle:locationName forState:UIControlStateNormal];
    }];
    PFUser *donor = [self.post objectForKey:@"user"];
    if ([[[PFUser currentUser] objectId]isEqualToString:[donor objectId]]) {
        self.requestContactButton.enabled = NO;
    }
    else
    {
        self.requestContactButton.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationDetails:(id)sender {
    MKMapItem *item = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:location.coordinate addressDictionary:nil]];
    item.name = locationName;
    [item openInMapsWithLaunchOptions:[NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey, nil]];
}
- (IBAction)requestContact:(id)sender {
    [self performSegueWithIdentifier:@"ViewPost_Request" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewPost_Request"]) {
        RequestContactViewController *reqConVC = [segue destinationViewController];
        reqConVC.post = self.post;
    }
}


@end
