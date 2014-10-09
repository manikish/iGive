//
//  HomeViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/3/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "HomeViewController.h"
#import "PostingTableViewCell.h"

@interface HomeViewController ()
{
    SWRevealViewController *revealVC;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:NO];
    self.navigationController.navigationBarHidden = NO;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostingTableViewCell *cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }

    return cell;
}
- (IBAction)give:(id)sender {
    [self performSegueWithIdentifier:@"Home_Donate" sender:self];
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
