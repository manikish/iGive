//
//  MyPostingsViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/27/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <MBProgressHUD.h>
#import <Parse/Parse.h>

#import "MyPostingsViewController.h"
#import "MyPostingTableViewCell.h"
#import "RequesterDetailsViewController.h"

@interface MyPostingsViewController ()
{
    NSMutableArray *postsArray;
    NSArray *requestsArray;
    PFObject *requesterPost;
}
@end

@implementation MyPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"My Postings";
    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPosts
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *fetchPosts = [PFQuery queryWithClassName:@"Posts"];
    [fetchPosts whereKey:@"user" equalTo:[PFUser currentUser]];
    [fetchPosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]>0) {
            postsArray = [[NSMutableArray alloc]initWithArray:objects];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else{
            UILabel *noPostsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+100.0, self.view.frame.size.width, 21.0)];
            [noPostsLabel setText:@"You have not posted yet"];
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
    MyPostingTableViewCell *cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPostingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    [cell.title setText:[post objectForKey:@"title"]];
    PFFile *imageFile = [post objectForKey:@"imageFile"];
    [cell.thumbnail setFile:imageFile];
    [cell.thumbnail loadInBackground];
    if (![[post objectForKey:@"isRequested"]boolValue]) {
        cell.userInteractionEnabled = YES;
        cell.arrowImage.hidden = NO;
    }
    PFQuery *fetchRequest = [PFQuery queryWithClassName:@"Requests"];
    [fetchRequest whereKey:@"requestedPost" equalTo:post];
    [fetchRequest findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]!=0) {
            PFObject *request = [objects lastObject];
            [cell.subTitle setText:[NSString stringWithFormat:@"%@ has requested",[request valueForKey:@"requesterName"]]];
        }
        else{
            cell.subTitle.hidden = YES;
        }
    }];

    if ([[post objectForKey:@"isRequested"]boolValue]) {
        cell.arrowImage.hidden = NO;
    }
    else{
        cell.arrowImage.hidden = YES;
    }
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    if (![[post objectForKey:@"isRequested"]boolValue]) {
        return nil;
    }
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFQuery *fetchRequest = [PFQuery queryWithClassName:@"Requests"];
    [fetchRequest whereKey:@"requestedPost" equalTo:[postsArray objectAtIndex:indexPath.row]];
    [fetchRequest findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        requesterPost = [objects lastObject];
        [self performSegueWithIdentifier:@"MyPostings_RequesterDetails" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    PFQuery *fetchRequest = [PFQuery queryWithClassName:@"Requests"];
    [fetchRequest whereKey:@"requestedPost" equalTo:post];
    [fetchRequest findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [PFObject deleteAllInBackground:objects];
        [post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [postsArray removeObject:post];
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    RequesterDetailsViewController *requesterDetailsVC = [segue destinationViewController];
    requesterDetailsVC.requesterPost = requesterPost;
}


@end
