//
//  HomeViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/3/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD.h>

#import "HomeViewController.h"
#import "PostingTableViewCell.h"
#import "ViewPostViewController.h"

@interface HomeViewController ()
{
    SWRevealViewController *revealVC;
    NSArray *postsArray;
    PFObject *viewPost;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPosts];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self setupSideMenuButton];
}

- (void)setupSideMenuButton
{
    revealVC = [self revealViewController];
    revealVC.delegate = self;
    [revealVC tapGestureRecognizer];
    UIBarButtonItem *sideMenuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu.png"] style:UIBarButtonItemStylePlain target:revealVC action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = sideMenuButton;
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPosts
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *fetchPosts = [PFQuery queryWithClassName:@"Posts"];
    [fetchPosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        postsArray = objects;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];

//    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
//        PFQuery *fetchPosts = [PFQuery queryWithClassName:@"Posts"];
//        [fetchPosts whereKey:@"geoLocation" nearGeoPoint:geoPoint withinMiles:100.0];
//        [fetchPosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            postsArray = objects;
//            [self.tableView reloadData];
//            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        }];
//    }];
    
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
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:[post objectForKey:@"title"]];
    PFFile *imageFile = [post objectForKey:@"imageFile"];
    [cell.postThumbnail setFile:imageFile];
    [cell.postThumbnail loadInBackground];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    viewPost = [postsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Postings_ViewPost" sender:self];
}

- (IBAction)give:(id)sender {
    [self performSegueWithIdentifier:@"Home_Donate" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Postings_ViewPost"]) {
        ViewPostViewController *viewPostVC = [segue destinationViewController];
        viewPostVC.post = viewPost;
    }
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
