//
//  PostingTableViewCell.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/4/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "PostingTableViewCell.h"

@implementation PostingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.requestedLabel.layer.cornerRadius = 15.0;
}
@end
