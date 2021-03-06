//
//  PostViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/3/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MBProgressHUD.h>

#import "PostViewController.h"
#import "GlobalData.h"

@interface PostViewController ()
{
    NSString *offeringTitle;
    UIImage *imageToUpload;
    NSData *imageData;

}
@property (weak, nonatomic) IBOutlet UITextField *offeringTitleTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageUploadButton;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add an Offering";
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self registerForKeyboardNotifications];
    if ([GlobalData sharedGlobalData].selectedLocationGeoPoint!= nil) {
        CLLocation *location = [[CLLocation alloc]initWithLatitude:[GlobalData sharedGlobalData].selectedLocationGeoPoint.latitude longitude:[GlobalData sharedGlobalData].selectedLocationGeoPoint.longitude];
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark  = [placemarks firstObject];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            [self.locationButton setTitle:[addressDictionary objectForKey:@"Name"] forState:UIControlStateNormal];
        }];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - Keyboard Handling

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+kbSize.height)];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-kbSize.height)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.scrollView endEditing:YES];
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _offeringTitleTextField) {
        offeringTitle = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _offeringTitleTextField) {
        offeringTitle = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
        
        self.imagePickerController = imagePickerController;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)uploadImage:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self showImagePicker];
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage, *editedImage;
    editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToUpload = editedImage;
    } else {
        imageToUpload = originalImage;
    }
    imageData = UIImageJPEGRepresentation(imageToUpload, 0.0);
    
    [self.imageUploadButton setBackgroundImage:imageToUpload forState:UIControlStateNormal];
    [self.imageUploadButton setImage:nil forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)getLocationToCollect:(id)sender {
    [self performSegueWithIdentifier:@"Post_Location" sender:self];
}
- (IBAction)post:(id)sender {
    if (offeringTitle.length > 0) {
        if (imageData!= nil) {
            if ([GlobalData sharedGlobalData].selectedLocationGeoPoint != nil) {
                PFObject *post = [PFObject objectWithClassName:@"Posts"];
                [post setObject:offeringTitle forKey:@"title"];
                [post setObject:[PFFile fileWithName:@"image.jpg" data:imageData contentType:@"image/jpeg"] forKey:@"imageFile"];
                [post setObject:[GlobalData sharedGlobalData].selectedLocationGeoPoint forKey:@"geoLocation"];
                [post setObject:[PFUser currentUser] forKey:@"user"];
                [post setObject:@NO forKey:@"isRequested"];
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        [[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                    }
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                }];
            }
            else{
                [[[UIAlertView alloc]initWithTitle:nil message:@"Please pick a location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:nil message:@"Please take a picture" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else{
        [[[UIAlertView alloc]initWithTitle:nil message:@"Please give a title" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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
