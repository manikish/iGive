//
//  HelpViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 11/3/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *helpWebView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Help";
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:htmlFile];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.helpWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
