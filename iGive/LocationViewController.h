//
//  LocationViewController.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/8/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "ParentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : ParentViewController<CLLocationManagerDelegate, UISearchBarDelegate,MKMapViewDelegate>

@end
