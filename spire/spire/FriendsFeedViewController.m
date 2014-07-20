//
//  FriendsFeedViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "FriendsFeedViewController.h"
#import "PullToRefresh.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@interface FriendsFeedViewController ()
{
  UIImage *locationIcon;
  UIImage *heartButtonIcon;
  UIImage *commentButtonIcon;
}

@end

@implementation FriendsFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    locationIcon = [UIImage imageNamed:@"locationicon.png"];
    heartButtonIcon = [UIImage imageNamed:@"heartbutton.png"];
    commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return self;
}

- (NSString *)getAction
{
    NSArray* types = @[@"commented on your photo.", @"followed you.", @"accepted your friend request."];
    
    return types[arc4random() % [types count]];
}

- (NSString *)getPerson
{
    NSArray* types = @[@"andrewhuang", @"charlotte", @"keithmiller", @"lucyguo", @"nivejayasekar", @"vivianma"];
    
    return types[arc4random() % [types count]];
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
  return 20; //number of items
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
    NSString *username = [self getPerson];
    NSString *action = [self getAction];
  //setup avatar
  UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
  avatarView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", username]];
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
