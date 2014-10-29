//
//  RequesterDetailsViewController.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/28/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "ParentViewController.h"

@interface RequesterDetailsViewController : ParentViewController<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) PFObject *requesterPost;
@end
