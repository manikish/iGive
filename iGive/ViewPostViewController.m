//
//  ViewPostViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/10/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "ViewPostViewController.h"
#import "RequestContactViewController.h"

@interface ViewPostViewController ()
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
    CLLocation *location = [[CLLocation alloc]initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark  = [placemarks firstObject];
        NSDictionary *addressDictionary = placemark.addressDictionary;
        [self.locationDetailsButton setTitle:[addressDictionary objectForKey:@"Name"] forState:UIControlStateNormal];
    }];
//    PFUser *donor = [self.post objectForKey:@"user"];
//    if ([[[PFUser currentUser] objectId]isEqualToString:[donor objectId]]) {
//        self.requestContactButton.enabled = NO;
//    }
//    else
//    {
//        self.requestContactButton.enabled = YES;
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)locationDetails:(id)sender {
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
