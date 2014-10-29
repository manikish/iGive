//
//  PostingTableViewCell.h
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/4/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface PostingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
