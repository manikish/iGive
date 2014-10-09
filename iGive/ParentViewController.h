//
//  ParentViewController.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/2/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ParentViewController : UIViewController<SWRevealViewControllerDelegate>
- (void)showErrorAlertView:(NSString *)error;

@end
