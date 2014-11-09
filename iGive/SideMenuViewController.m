//
//  ViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 9/30/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "SideMenuViewController.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"

@interface SideMenuViewController ()
{
    SWRevealViewController *revealVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled   = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHome) name:@"showHome" object:nil];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Home";
            cell.imageView.image = [UIImage imageNamed:@"Home.png"];
            break;
        case 1:
            cell.textLabel.text = @"My Offerings";
            cell.imageView.image = [UIImage imageNamed:@"heart.png"];
            break;
        case 2:
            cell.textLabel.text = @"My Requests";
            cell.imageView.image = [UIImage imageNamed:@"Postings.png"];
            break;
        case 3:
            cell.textLabel.text = @"Contact Us";
            cell.imageView.image = [UIImage imageNamed:@"Contact.png"];
            break;
        case 4:
            cell.textLabel.text = @"Help";
            cell.imageView.image = [UIImage imageNamed:@"Help.png"];
            break;
        case 5:
            cell.textLabel.text = @"Logout";
            cell.imageView.image = [UIImage imageNamed:@"Logout.png"];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"SideMenu_Home" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"SideMenu_MyPostings" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"SideMenu_MyRequests" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"SideMenu_ContactUs" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"SideMenu_Help" sender:self];
            break;
        case 5:
            [PFUser logOut];
            [self performSegueWithIdentifier:@"SideMenu_Login" sender:self];
            break;
        default:
            break;
    }
}

- (void)showHome
{
    [self performSegueWithIdentifier:@"SideMenu_Home" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}



@end
