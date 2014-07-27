//
//  SPNotificationsViewController.m
//  spire
//
//  Created by Niveditha Jayasekar on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPNotificationsViewController.h"
#import "PullToRefresh.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@interface SPNotificationsViewController ()
{
    UIImage *locationIcon;
    UIImage *heartButtonIcon;
    UIImage *commentButtonIcon;
}

@end

@implementation SPNotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        locationIcon = [UIImage imageNamed:@"locationicon.png"];
        heartButtonIcon = [UIImage imageNamed:@"heartbutton.png"];
        commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
        
        self.notifications = [[NSArray alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return self;
}

- (PFQuery *)queryForNotifications
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:@"fromUser"];
    [query includeKey:@"fromUser"];
    //[query includeKey:@"photo"]; // todo?
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // todo: add caching
    
    return query;
}

- (NSString *)getAction:(NSString *)type
{
    if ([type isEqualToString:@"comment"]) {
        return @"commented on your photo.";
    } else if ([type isEqualToString:@"like"]){
        return @"liked your photo.";
    } else {
        return @"took some action.";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
    
    self.ptr = [[PullToRefresh alloc] initWithNumberOfDots:5];
    self.ptr.delegate = self;
    [self.view addSubview:self.ptr];
    
    [self.tableView setAllowsSelection:NO];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *notificationsQuery = [self queryForNotifications];
    [notificationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"can't load notifications from parse.");
        } else {
            NSLog(@"success loading notifications.");
            self.notifications = objects;
            [self.tableView reloadData];
        }
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    [self.ptr viewDidScroll:scrollView];
}

- (void)Refresh {
    // Perform here the required actions to refresh the data (call a JSON API for example).
    // Once the data has been updated, call the method isDoneRefreshing:
    [self.ptr isDoneRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger *numNotifications = [self.notifications count];
    
    if (numNotifications > 0) {
        return numNotifications;//number of items
    } else {
        return 1; // empty case
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 5;
}

//for each header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    
    UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
    
    // get data
    if (self.notifications.count == 0) { // empty case
        UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 300, 50)];
        [tags setTextColor:descColor];
        [tags setBackgroundColor:[UIColor clearColor]];
        [tags setFont:[UIFont fontWithName:@"Avenir-Light" size:10]];
        
        tags.text = @"No new notifications!"; // some empty notifications tag
        tags.lineBreakMode = NSLineBreakByWordWrapping;
        tags.numberOfLines = 0;
        [view addSubview:tags];
        
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = .94f;
        
        return view;
    }

    PFObject *notification = [self.notifications objectAtIndex:section];
    PFUser *user = [notification objectForKey:@"fromUser"];
    NSString *username = [user objectForKey:@"username"];
    NSString *action = [self getAction:[notification objectForKey:@"type"]];
    //setup avatar
    PFImageView *avatarView = [[PFImageView alloc] initWithFrame:CGRectMake(10,20,40,40)];
    avatarView.image = [UIImage imageNamed:@"lucyguo.png"];
    avatarView.file = [user objectForKey:@"fbProfilePic"];
    [view addSubview:avatarView];
    
    //setup avatar name
    UILabel *avatarName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 300, 50)];
    [avatarName setTextColor:descColor];
    [avatarName setBackgroundColor:[UIColor clearColor]];
    [avatarName setFont:[UIFont fontWithName:@"Avenir" size:16]];
    
    avatarName.text = username;//@"lucyguo";
    avatarName.lineBreakMode = NSLineBreakByWordWrapping;
    avatarName.numberOfLines = 0;
    [view addSubview:avatarName];
    
    // setup tags
    UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 300, 50)];
    [tags setTextColor:descColor];
    [tags setBackgroundColor:[UIColor clearColor]];
    [tags setFont:[UIFont fontWithName:@"Avenir-Light" size:10]];
    
    tags.text = action;//@"Surfing with da fox.";
    tags.lineBreakMode = NSLineBreakByWordWrapping;
    tags.numberOfLines = 0;
    [view addSubview:tags];
    
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = .94f;
    
    return view;
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
