//
//  PlaceAnnotation.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/9/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, retain) NSURL *url;

@end
