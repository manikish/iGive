//
//  ViewPostViewController.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/10/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParentViewController.h"

@interface ViewPostViewController : ParentViewController

@property (strong, nonatomic) PFObject *post;

@end
