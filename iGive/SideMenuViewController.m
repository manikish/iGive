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
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
            cell.textLabel.text = @"My Postings";
            cell.imageView.image = [UIImage imageNamed:@"Postings.png"];
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
            [self performSegueWithIdentifier:@"queue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"friendsList" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"privateParty" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"aboutUs" sender:self];
            break;
        case 5:
            [PFUser logOut];
            [self performSegueWithIdentifier:@"SideMenu_Login" sender:self];
            break;
        default:
            break;
    }
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