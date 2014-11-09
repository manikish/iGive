//
//  MyRequestsViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/28/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//
#import <Parse/Parse.h>
#import <MBProgressHUD.h>
#import "PostingTableViewCell.h"
#import "MyRequestsViewController.h"

@interface MyRequestsViewController ()
{
    NSMutableArray *postsArray;
    NSArray *requestsArray;
}
@end

@implementation MyRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    postsArray = [[NSMutableArray alloc]init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"My Requests";
    [self fetchPosts];
}

- (void)fetchPosts
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *fetchPosts = [PFQuery queryWithClassName:@"Requests"];
    [fetchPosts whereKey:@"requester" equalTo:[PFUser currentUser]];
    [fetchPosts includeKey:@"requestedPost"];
    [fetchPosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]>0) {
            postsArray = [[NSMutableArray alloc]initWithArray:objects];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else{
            UILabel *noPostsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+100.0, self.view.frame.size.width, 21.0)];
            [noPostsLabel setText:@"You have not requested any item"];
            noPostsLabel.textAlignment = NSTextAlignmentCenter;
            noPostsLabel.textColor = [UIColor blackColor];
            [self.view addSubview:noPostsLabel];
            self.tableView.hidden = YES;
            [self.view bringSubviewToFront:noPostsLabel];
        }
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [postsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostingTableViewCell *cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    PFObject *post = [[[postsArray objectAtIndex:indexPath.row] valueForKey:@"requestedPost"]fetchIfNeeded];
    [cell.titleLabel setText:[post objectForKey:@"title"]];
    PFFile *imageFile = [post objectForKey:@"imageFile"];
    [cell.postThumbnail setFile:imageFile];
    [cell.postThumbnail loadInBackground];
    cell.requestedLabel.hidden = YES;
    cell.arrowImageView.hidden = YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    [post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [postsArray removeObject:post];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
