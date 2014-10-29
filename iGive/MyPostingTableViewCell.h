//
//  MyPostingTableViewCell.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/27/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyPostingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet PFImageView *thumbnail;

@end
