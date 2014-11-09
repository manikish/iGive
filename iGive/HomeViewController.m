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
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.giveButton.layer.cornerRadius = self.giveButton.frame.size.width/2.0;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshOfferings) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Offerings";
    self.navigationController.navigationBarHidden = NO;
    [self fetchPosts];
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

- (void)refreshOfferings {
    [self fetchPosts];
}

- (void)fetchPosts
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        PFQuery *fetchPosts = [PFQuery queryWithClassName:@"Posts"];
        [fetchPosts whereKey:@"geoLocation" nearGeoPoint:geoPoint withinMiles:100.0];
        [fetchPosts setLimit:100.0];
        [fetchPosts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ([objects count] >0) {
                postsArray = objects;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                UILabel *noPostsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+100.0, self.view.frame.size.width, 21.0)];
                [noPostsLabel setText:@"No one posted yet. Post One"];
                noPostsLabel.textAlignment = NSTextAlignmentCenter;
                noPostsLabel.textColor = [UIColor blackColor];
                [self.view addSubview:noPostsLabel];
                self.tableView.hidden = YES;
                [self.view bringSubviewToFront:noPostsLabel];
            }
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
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
    PFObject *post = [postsArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:[post objectForKey:@"title"]];
    PFFile *imageFile = [post objectForKey:@"imageFile"];
    [cell.postThumbnail setFile:imageFile];
    [cell.postThumbnail loadInBackground];
    if ([[post objectForKey:@"isRequested"]boolValue]) {
        cell.userInteractionEnabled = NO;
        cell.requestedLabel.hidden = NO;
        cell.arrowImageView.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    viewPost = [postsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Postings_ViewPost" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

@end
