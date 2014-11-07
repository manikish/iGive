//
//  MyPostingsViewController.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/27/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "ParentViewController.h"

@interface MyPostingsViewController : ParentViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
