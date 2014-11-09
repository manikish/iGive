//
//  RequestContactViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/10/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <MBProgressHUD.h>
#import "RequestContactViewController.h"
#import "HomeViewController.h"


@interface RequestContactViewController ()
{
    NSString *name,*phoneNumber,*emailId;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
@end

@implementation RequestContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    name = [userDefaults objectForKey:@"name"];
    if (name == nil) {
        name = [[PFUser currentUser]objectForKey:@"fbUsername"];
    }
    [self.nameTextField setText:name];
    
    phoneNumber = [userDefaults objectForKey:@"phoneNumber"];
    if (phoneNumber != nil) {
        [self.phoneNumberTextField setText:phoneNumber];
    }
    
    emailId = [userDefaults objectForKey:@"emailId"];
    if (emailId!=nil) {
        [self.emailIdTextField setText:emailId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        name = textField.text;
    }
    else if (textField == self.emailIdTextField)
    {
        emailId = textField.text;
    }
    else
    {
        phoneNumber = textField.text;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.emailIdTextField becomeFirstResponder];
    }
    else if (textField == self.emailIdTextField)
    {
        [self.phoneNumberTextField becomeFirstResponder];
    }
    else
    {
    [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)request:(id)sender {
    if (name.length > 0) {
        if ([self validateEmailWithString:emailId]) {
            if (phoneNumber.length>0) {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                PFObject *request = [PFObject objectWithClassName:@"Requests"];
                [request setObject:name forKey:@"requesterName"];
                [request setObject:phoneNumber forKey:@"requesterPhoneNumber"];
                [request setObject:emailId forKey:@"requesterEmailId"];
                [request setObject:self.post forKey:@"requestedPost"];
                [request setObject:[PFUser currentUser] forKey:@"requester"];
                [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    if (succeeded) {
                        for (UIViewController *viewController in self.navigationController.viewControllers) {
                            if ([viewController isKindOfClass:[HomeViewController class]]) {
                                [self.navigationController popToViewController:viewController animated:YES];
                            }
                        }
                        
                        PFQuery *query = [PFInstallation query];
                        [query whereKey:@"user" equalTo:[self.post objectForKey:@"user"]];
                        PFPush *push = [[PFPush alloc] init];
                        [push setQuery:query];
                        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSString stringWithFormat:@"%@ has requested your item with name %@ on iGive",name,[self.post objectForKey:@"title"]], @"alert",
                                              @"Increment",@"badge",
                                              @"",@"sound",
                                              nil];
                        [push setData:data];
                        [push sendPushInBackground];

                        [self.post setObject:@YES forKey:@"isRequested"];
                        [self.post saveInBackground];
                        [self updateUserDefaults];
                    }
                }];
            }
            else {
                [[[UIAlertView alloc]initWithTitle:nil message:@"Please enter your mobile number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:nil message:@"Please enter a valid E-mail address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else {
        [[[UIAlertView alloc]initWithTitle:nil message:@"Please enter your name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (void)updateUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [userDefaults removePersistentDomainForName:appDomain];
    
    [userDefaults setObject:phoneNumber forKey:@"phoneNumber"];
    [userDefaults setObject:name forKey:@"name"];
    [userDefaults setObject:emailId forKey:@"emailId"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
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
