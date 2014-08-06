//
//  VenueTableViewController.m
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "VenueTableViewController.h"

@interface VenueTableViewController ()

@end

@implementation VenueTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (id)initWithGeoPoint:(PFGeoPoint *)geoPoint andCallback:(DictCallback)callback
{
    self = [super init];
    if (self) {
        self.venues = @[];
        self.callback = callback;
        self.navigationItem.title = @"Select location";

        [Util getFoursquareVenuesNearGeoPoint:geoPoint withCallback:^(NSArray *locs) {
            if ([locs count] == 0) {
                [self dismissViewControllerAnimated:YES completion:^(){
                    // TODO: What to do if there are no locations? Currently using Medium as fallback data
                    NSDictionary *venue = @{@"name": @"Medium"};
                    self.callback(venue);
                }];
                return;
            }
            // sort venues by distance away
            self.venues = [locs sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *d1, NSDictionary *d2) {
                
                return [d1[@"location"][@"distance"] compare:d2[@"location"][@"distance"]];
                
            }];
            [self.tableView reloadData];
        }];

    }
    return self;
}

- (BOOL)prefersStatusBarHidden {return YES;}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissMenu)];
    self.navigationItem.leftBarButtonItem = backButton;
    //[self.tableView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 320 + 39;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //TODO: Figure out sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.venues count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 320 + 39)];
    
    // TODO: ADD APPLE MAPS
    //height and width of screen.
    UIImageView *map = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    map.image = [UIImage imageNamed:@"googlemap.png"];
    [view addSubview:map];
    
    // foursquare attribution
    UIImageView *foursquare = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 320, 39)];
    foursquare.image = [UIImage imageNamed:@"foursquare.png"];
    [view addSubview:foursquare];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];//forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* venue = [self.venues objectAtIndex:indexPath.row];
    
    cell.textLabel.text = venue[@"name"];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSString *addr = ([venue[@"location"][@"formattedAddress"] count] == 0) ? @"" : venue[@"location"][@"formattedAddress"][0];
    
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ (%@ m)", addr, venue[@"location"][@"distance"]]];
    // TODO: add icon
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"We selected something from the menu!");
    NSDictionary* venue = [self.venues objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^(){
        self.callback(venue);
    }];
}
- (void)dismissMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
