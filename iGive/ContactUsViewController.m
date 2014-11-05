//
//  ContactUsViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 11/3/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <MBProgressHUD.h>
#import <Parse/Parse.h>
#import "ContactUsViewController.h"

@interface ContactUsViewController ()
{
    SWRevealViewController *revealVC;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Contact Us";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupSideMenuButton];
    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - Keyboard Handling

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+kbSize.height)];

    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (self.activeTextField != nil) {
        if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
            [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
        }
    }else
    {
        if (!CGRectContainsPoint(aRect, self.messageTextView.frame.origin) ) {
            [self.scrollView scrollRectToVisible:self.messageTextView.frame animated:YES];
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-kbSize.height)];
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    if(textField == self.nameTextField){
        self.nameTextField.placeholder = @"";
    }
    else if (textField == self.emailTextField){
        self.emailTextField.placeholder = @"";
    }
    else if (textField == self.phoneNumberTextField){
        self.phoneNumberTextField.placeholder = @"";
    }
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    if (textField == self.emailTextField)
    {
        [self.phoneNumberTextField becomeFirstResponder];
    }
    if (textField == self.phoneNumberTextField) {
        [self.phoneNumberTextField resignFirstResponder];
        return YES;
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

#pragma mark - TextView Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text hasPrefix:@"  Please enter your message"]) {
        _messageTextView.text = @"";
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_messageTextView.text.length == 0){
        _messageTextView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self.nameTextField becomeFirstResponder];
        if(_messageTextView.text.length == 0){
            _messageTextView.text = @"  Please enter your message";
            [_messageTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if(_messageTextView.text.length == 0){
        _messageTextView.text = @"  Please enter your message";
    }
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.bgView endEditing:YES];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)submit:(id)sender {
    if (self.nameTextField.text.length != 0 && ![self.nameTextField.text isEqualToString:@"Name"]) {
        if ([self validateEmailWithString:self.emailTextField.text]) {
            if (self.messageTextView.text.length !=0 && ![self.messageTextView.text hasPrefix:@"  Please enter your message"]) {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                PFObject *object = [PFObject objectWithClassName:@"Help"];
                object[@"name"] = self.nameTextField.text;
                object[@"email"] = self.emailTextField.text;
                if (self.phoneNumberTextField.text.length != 0) {
                    object[@"phoneNumber"] = self.phoneNumberTextField.text;
                }
                object[@"message"] = self.messageTextView.text;
                [object saveEventually];
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"showHome" object:nil];
            }
            else
            {
                UIAlertView *messageAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter a message" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                messageAlertView.tag = 0;
                [messageAlertView show];
            }
        }
        else
        {
            UIAlertView *emailAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter a valid email id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            emailAlertView.tag = 1;
            [emailAlertView show];
        }
    }
    else
    {
        UIAlertView *nameAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter your name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        nameAlertView.tag = 2;
        [nameAlertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 0:
            [self.messageTextView becomeFirstResponder];
            break;
        case 1:
            [self.emailTextField becomeFirstResponder];
            break;
        case 2:
            [self.nameTextField becomeFirstResponder];
            break;
        default:
            break;
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
