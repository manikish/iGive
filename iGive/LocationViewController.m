//
//  LocationViewController.m
//  iGive
//
//  Created by Mani Kishore Chitrala on 10/8/14.
//  Copyright (c) 2014 Mani Kishore Chitrala. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"

static NSString *kCellIdentifier = @"cellIdentifier";

@interface LocationViewController ()
{
    NSArray *places;
}
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mkMapView;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationItem.hidesBackButton = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchLocations)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:searchButton,nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)searchLocations
{
    self.searchDisplayController.searchBar.hidden = NO;
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    MKMapItem *mapItem = [places objectAtIndex:indexPath.row];
    cell.textLabel.text = mapItem.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mkMapView setRegion:self.boundingRegion];
    
    NSIndexPath *selectedItem = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
    MKMapItem *mapItem = [places objectAtIndex:selectedItem.row];

    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
    annotation.coordinate = mapItem.placemark.location.coordinate;
    annotation.title = mapItem.name;
    annotation.url = mapItem.url;
    [self.mkMapView addAnnotation:annotation];
    
    [self.mkMapView selectAnnotation:[self.mkMapView.annotations objectAtIndex:0] animated:YES];
    
    self.mkMapView.centerCoordinate = mapItem.placemark.coordinate;
    [self.searchDisplayController setActive:NO];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    {
        if (self.localSearch.searching)
        {
            [self.localSearch cancel];
        }
        
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = self.userLocation.latitude;
        newRegion.center.longitude = self.userLocation.longitude;
        
        newRegion.span.latitudeDelta = 0.112872;
        newRegion.span.longitudeDelta = 0.109863;
        
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        
        request.naturalLanguageQuery = searchString;
        request.region = newRegion;
        
        MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
        {
            if (error != nil)
            {
                NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                                message:errorStr
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                places = [response mapItems];
                self.boundingRegion = response.boundingRegion;
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        };
        
        if (self.localSearch != nil)
        {
            self.localSearch = nil;
        }
        self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        
        [self.localSearch startWithCompletionHandler:completionHandler];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    return YES;
}


#pragma mark - UISearchBar Delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView  {
//    tableView.frame = CGRectMake(self.searchDisplayController.searchBar.frame.origin.x, self.searchDisplayController.searchBar.frame.origin.y-20.0,self.searchDisplayController.searchBar.frame.size.width, 176.0);
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.hidden = YES;
    [self.searchDisplayController setActive:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchDisplayController setActive:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // remember for later the user's current location
    self.userLocation = newLocation.coordinate;
    
    [manager stopUpdatingLocation]; // we only want one update
    
    manager.delegate = nil;         // we might be called again here, even though we
    // called "stopUpdatingLocation", remove us as the delegate to be sure
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
