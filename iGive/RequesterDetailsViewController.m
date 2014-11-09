//
//  RequesterDetailsViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/28/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "RequesterDetailsViewController.h"

@interface RequesterDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation RequesterDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.callButton setTitle:[self.requesterPost valueForKey:@"requesterPhoneNumber"] forState:UIControlStateNormal];
    [self.emailButton setTitle:[self.requesterPost valueForKey:@"requesterEmailId"] forState:UIControlStateNormal];
    [self.nameLabel setText:[self.requesterPost valueForKey:@"requesterName"]];
    self.navigationController.navigationItem.hidesBackButton = NO;
    self.title = @"Contact Info";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)email:(id)sender {
    NSString *emailTitle = @"iGive Donor Response";
    
    NSArray *toRecipents = [NSArray arrayWithObject:[self.requesterPost valueForKey:@"requesterEmailId"]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setToRecipients:toRecipents];
    [self presentViewController:mc animated:YES completion:NULL];
}
- (IBAction)call:(id)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[self.requesterPost valueForKey:@"requesterPhoneNumber"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *mailAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Email didn't succeed. Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [mailAlert show];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
