//
//  ParentViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/2/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showErrorAlertView:(NSString *)error
{
    [[[UIAlertView alloc]initWithTitle:@"Network Error" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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
