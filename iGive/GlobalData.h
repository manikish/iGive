//
//  GlobalData.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/2/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GlobalData : NSObject
+ (GlobalData *)sharedGlobalData;
@property (atomic, strong) PFGeoPoint *selectedLocationGeoPoint;

@end
