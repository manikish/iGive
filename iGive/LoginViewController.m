//
//  LoginViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/1/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "LoginViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>

#import <MBProgressHUD.h>

@interface LoginViewController ()
{
    SWRevealViewController *revealVC;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[PFUser currentUser]refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            [PFUser logOut];
        }
        else if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            [self performSegueWithIdentifier:@"loginToHome" sender:self];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupSideMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginWithFacebook:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObject:@"user_friends"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Facebook login cancelled" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:error.fberrorUserMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        }
        else
        {
            [self saveUserDetails];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

- (void)saveUserDetails
{
    if ([PFUser currentUser].isNew) {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                NSString *facebookId = [result objectForKey:@"id"];
                [[PFUser currentUser] setObject:facebookId forKey:@"fbId"];
                [[PFUser currentUser] setObject:[result objectForKey:@"name"] forKey:@"fbUsername"];
                NSString *profilePictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookId];
                [[PFUser currentUser] setObject:profilePictureURL forKey:@"fbProfilePicURL"];
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [[PFInstallation currentInstallation]setObject:[PFUser currentUser] forKey:@"user"];
                    [[PFInstallation currentInstallation]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            
                        }
                    }];
                }];
            }
            else [self showErrorAlertView:error.localizedDescription];
        }];
    }
    else
    {
        [[PFInstallation currentInstallation]setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self performSegueWithIdentifier:@"loginToHome" sender:self];
            }
            else
            {
                [self showErrorAlertView:error.localizedDescription];
            }
        }];
        
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
