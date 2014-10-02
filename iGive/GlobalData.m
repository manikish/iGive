//
//  GlobalData.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/2/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData
+ (GlobalData *)sharedGlobalData
{
    static dispatch_once_t p = 0;
    
    __strong static GlobalData *_sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}
@end
