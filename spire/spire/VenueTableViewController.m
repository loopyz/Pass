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

- (id)initWithVenues:(NSArray*)venueItems andCallback:(DictCallback)callback
{
    self = [super init];
    if (self) {
        // sort venues by distance away
        self.venues = [venueItems sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *d1, NSDictionary *d2){
            
            return [d1[@"location"][@"distance"] compare:d2[@"location"][@"distance"]];
            
        }];
        self.callback = callback;
        self.navigationItem.title = @"Select location";
    }
    return self;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
