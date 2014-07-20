//
//  NewsFeedViewController.m
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "PullToRefresh.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@interface NewsFeedViewController () {
  UIImage *locationIcon;
  UIImage *heartButtonIcon;
  UIImage *commentButtonIcon;
}


@end

@implementation NewsFeedViewController

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

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
  self.tableView.contentInset = inset;
  
  self.ptr = [[PullToRefresh alloc] initWithNumberOfDots:5];
  self.ptr.delegate = self;
  [self.view addSubview:self.ptr];
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (objects) {
      self.photos = objects;
      [self.tableView reloadData];
    }
  }];
  
  [self.tableView setAllowsSelection:NO];
  
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
  return [self.photos count]; //number of items
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
  return 385;
}

//for each header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PFObject *photo = [self.photos objectAtIndex:section];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
  
  UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
  
  //setup avatar
    FBProfilePictureView *avatarView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
    avatarView.profileID = [[photo objectForKey:@"user"] objectForKey:@"fbId"];
    
//  UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
//  avatarView.image = [UIImage imageNamed:@"tempnewsavatar.png"];
  [view addSubview:avatarView];
  
  //setup avatar name
  UILabel *avatarName = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 300, 50)];
  [avatarName setTextColor:descColor];
  [avatarName setBackgroundColor:[UIColor clearColor]];
  [avatarName setFont:[UIFont fontWithName:@"Avenir" size:16]];
  
    avatarName.text = [[photo objectForKey:@"user"] objectForKey:@"fbName"];//@"startstar";
  avatarName.lineBreakMode = NSLineBreakByWordWrapping;
  avatarName.numberOfLines = 0;
  [view addSubview:avatarName];
  
  // setup tags
  UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 300, 50)];
  [tags setTextColor:descColor];
  [tags setBackgroundColor:[UIColor clearColor]];
  [tags setFont:[UIFont fontWithName:@"Avenir-Light" size:10]];
  
    tags.text = [photo objectForKey:@"caption"];//@"I love Foxy hehe.";
  tags.lineBreakMode = NSLineBreakByWordWrapping;
  tags.numberOfLines = 0;
  [view addSubview:tags];
  
  view.backgroundColor = [UIColor whiteColor];
  view.alpha = .94f;
  
  return view;
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PFObject *photo = [self.photos objectAtIndex:indexPath.section];
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
  }
  cell.backgroundColor = [UIColor clearColor];
  
    PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    imageView.image =[UIImage imageNamed:@"tempsingleimage.png"];
    imageView.file = [photo objectForKey:@"image"];
    [imageView loadInBackground];
//  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//  imageView.image = [UIImage imageNamed:@"tempsingleimage.png"];
  [cell addSubview:imageView];
  
  UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
  
  // setup location icon
  UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 345, 11, 17)];
  locationIconView.image = locationIcon;
  [cell addSubview:locationIconView];
  
  // setup comment button
  UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
  
  commentButton.frame = CGRectMake(self.view.frame.size.width - 90, 345, 32.5, 22);
  [commentButton addTarget:self action:@selector(commentTouched) forControlEvents:UIControlEventTouchUpInside];
  [cell addSubview:commentButton];
  [commentButton setImage:commentButtonIcon forState:UIControlStateNormal];
  commentButton.contentMode = UIViewContentModeScaleToFill;
  
  // setup heart button
  UIButton *heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [commentButton setTitle:@"Heart" forState:UIControlStateNormal];
  
  heartButton.frame = CGRectMake(self.view.frame.size.width - 40, 345, 32.5, 22);
  [heartButton addTarget:self action:@selector(heartTouched) forControlEvents:UIControlEventTouchUpInside];
  [cell addSubview:heartButton];
  [heartButton setImage:heartButtonIcon forState:UIControlStateNormal];
  heartButton.contentMode = UIViewContentModeScaleToFill;
  
  //setup Location label
  UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(29, 330, 200, 50)];
  [desc setTextColor:descColor];
  [desc setBackgroundColor:[UIColor clearColor]];
  [desc setFont:[UIFont fontWithName:@"Avenir" size:11]];
  
    desc.text = [photo objectForKey:@"locName"];//@"Mountain View, CA";
  desc.lineBreakMode = NSLineBreakByWordWrapping;
  desc.numberOfLines = 0;
  [cell addSubview:desc];
  
  return cell;
}


@end
