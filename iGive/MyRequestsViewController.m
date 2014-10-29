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
    NSArray *postsArray;
    NSArray *requestsArray;
}
@end

@implementation MyRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self fetchPosts];
}

- (void)fetchPosts
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *fetchPosts = [PFQuery queryWithClassName:@"Requests"];
    [fetchPosts whereKey:@"requester" equalTo:[PFUser currentUser]];
    [fetchPosts includeKey:@"requestedPost"];
    [fetchPosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        postsArray = objects;
        [self.tableView reloadData];
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
    cell.userInteractionEnabled = NO;
    cell.requestedLabel.hidden = YES;
    cell.arrowImageView.hidden = YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    [post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [postsArray delete:post];
        [self.tableView reloadData];
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
