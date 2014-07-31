//
//  NewsFeedViewController.m
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "PullToRefresh.h"
#import "CommentsViewController.h"
#import "ProfileViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
#import "SettingsViewController.h"

@interface NewsFeedViewController () {
  UIImage *locationIcon;
    UIImage *heartIcon;
    UIImage *commentIcon;
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
      heartIcon = [UIImage imageNamed:@"hearticon.png"];
      commentIcon = [UIImage imageNamed:@"commenticon.png"];
    heartButtonIcon = [UIImage imageNamed:@"heartbutton.png"];
    commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      
      [self initNavBar];
      
  }
  return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)scrollToTop
{
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                            inSection:0]
                        atScrollPosition:UITableViewScrollPositionTop
                                animated:YES];
}

- (void)initNavBar
{
  
    // Logo in the center of navigation bar
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 37.5)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo.png"]];
    titleImageView.frame = CGRectMake(0, 0, titleImageView.frame.size.width/2, titleImageView.frame.size.height/2);
    [logoView addSubview:titleImageView];
    self.navigationItem.titleView = logoView;
    
    
    // Right bar button item to launch the categories selection screen.
    UIBarButtonItem *rbb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsicon.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(settingsTouched)];
    
    rbb.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rbb;
}

- (void)settingsTouched
{
    //blah
    SettingsViewController *ppvc = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:ppvc animated:YES];
}

- (void)updatePhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.photos = objects;
            
            [self.tableView reloadData];
        }
    }];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
  self.tableView.contentInset = inset;
  
//  self.ptr = [[PullToRefresh alloc] initWithNumberOfDots:5];
//  self.ptr.delegate = self;
//  [self.view addSubview:self.ptr];
  
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    
    [self updatePhotos];
  
  [self.tableView setAllowsSelection:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView:)
                                                 name:@"refreshView"
                                               object:nil];
  
}

-(void)refreshView:(NSNotification *) notification{
    if (self == self.navigationController.topViewController)
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
  [self.ptr viewDidScroll:scrollView];
}

- (void)Refresh {
    // make asynchronous?
    [self updatePhotos];
  // Perform here the required actions to refresh the data (call a JSON API for example).
  // Once the data has been updated, call the method isDoneRefreshing:
  
    // [self.ptr isDoneRefreshing];
    
    [self.refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)commentTouched:(id)sender
{
    UIView *commentView = (UIView *)sender;
    UITableViewCell *containingCell = (UITableViewCell *)[[commentView superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:containingCell];
    PFObject *photo = [self.photos objectAtIndex:indexPath.section];
    CommentsViewController *ppvc = [[CommentsViewController alloc] initWithPhoto:photo];
    
    [self.navigationController pushViewController:ppvc animated:YES];
}

- (void)heartTouched:(id)sender
{
    UIView *commentView = (UIView *)sender;
    UITableViewCell *containingCell = (UITableViewCell *)[[commentView superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:containingCell];
    PFObject *photo = [self.photos objectAtIndex:indexPath.section];

    // TODO: toggle styles of heart
    // TODO: add dislike part
    [Util likePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"error liking photo");
        } else {
            NSLog(@"liked photo successfully");
        }
    }];
    
    
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
    // TODO: if this is clicked, then open person's profile
    PFObject *photo = [self.photos objectAtIndex:section];
  UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    [view addTarget:self action:@selector(personTouched:) forControlEvents:UIControlEventTouchUpInside];
    
  
  UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
  
  //setup avatar
                         
    PFImageView *avatarView = [[PFImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
    
    avatarView.image =[UIImage imageNamed:@"tempnewsavatar.png"];
    avatarView.file = [[photo objectForKey:@"user"] objectForKey:@"fbProfilePic"];
    [avatarView loadInBackground];
    avatarView.layer.masksToBounds = YES;
    float width = avatarView.bounds.size.width;
    avatarView.layer.cornerRadius = width/2;
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
  UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(71, 21, 300, 50)];
  [tags setTextColor:descColor];
  [tags setBackgroundColor:[UIColor clearColor]];
  [tags setFont:[UIFont fontWithName:@"Avenir-Light" size:12]];
  
    // tags.text = [photo objectForKey:@"caption"];//@"I love Foxy hehe.";
  tags.lineBreakMode = NSLineBreakByWordWrapping;
  tags.numberOfLines = 0;
  [view addSubview:tags];
    
    // setup location icon
    UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 11/1.5f, 17/1.5f)];
    locationIconView.image = locationIcon;
    locationIconView.tag = 101;
    [view addSubview:locationIconView];
    
    tags.text = [photo objectForKey:@"locName"];
  
  view.backgroundColor = [UIColor clearColor];
    outerView.backgroundColor = [UIColor whiteColor];
    outerView.alpha = .94f;
  
    view.tag = 800 + section;
    [outerView addSubview:view];
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 70, self.tableView.frame.size.width, .6f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [outerView.layer addSublayer:bottomBorder];
  return outerView;
}

- (void)personTouched:(id)sender
{
    UIButton *button = (UIButton *)sender;
    PFUser *user = [[self.photos objectAtIndex:(button.tag - 800)] objectForKey:@"user"];
    
    if ([user.objectId isEqualToString:[[PFUser currentUser] objectId]]) {
        [self.tabBarController setSelectedIndex:4];
    } else {
        ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}
//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PFObject *photo = [self.photos objectAtIndex:indexPath.section];
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
      cell.backgroundColor = [UIColor clearColor];
      PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
      imageView.image =[UIImage imageNamed:@"tempsingleimage.png"];
      imageView.tag = 100;
      [cell addSubview:imageView];
      
      UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
      
      // setup heart icon
      UIImageView *heartIconView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 325, 12, 12)];
      heartIconView.image = heartIcon;
      heartIconView.tag = 105;
      [cell addSubview:heartIconView];
      
      // setup location icon
      UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 348, 12, 12)];
      locationIconView.image = commentIcon;
      locationIconView.tag = 101;
      locationIconView.backgroundColor = [UIColor clearColor];
      [cell addSubview:locationIconView];
      
      
      // setup comment button
      UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
      commentButton.frame = CGRectMake(self.view.frame.size.width - 90, 345, 32.5, 22);

      commentButton.tag = 102;
      [cell addSubview:commentButton];
      [commentButton setImage:commentButtonIcon forState:UIControlStateNormal];
      commentButton.contentMode = UIViewContentModeScaleToFill;
      [commentButton addTarget:self action:@selector(commentTouched:) forControlEvents:UIControlEventTouchUpInside];
      
      // setup heart button
      UIButton *heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [heartButton setTitle:@"Heart" forState:UIControlStateNormal];
      
      heartButton.frame = CGRectMake(self.view.frame.size.width - 40, 345, 32.5, 22);
      [heartButton addTarget:self action:@selector(heartTouched:) forControlEvents:UIControlEventTouchUpInside];
      heartButton.tag = 103;
      [cell addSubview:heartButton];
      [heartButton setImage:heartButtonIcon forState:UIControlStateNormal];
      heartButton.contentMode = UIViewContentModeScaleToFill;
      
      //setup caption label
      UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(32, 330, 200, 50)];
      [desc setTextColor:descColor];
      [desc setBackgroundColor:[UIColor clearColor]];
      [desc setFont:[UIFont fontWithName:@"Avenir" size:11]];
      desc.lineBreakMode = NSLineBreakByWordWrapping;
      desc.numberOfLines = 0;
      desc.tag = 104;
      [cell addSubview:desc];
      
      //setup likes label
      UILabel *likes = [[UILabel alloc] initWithFrame:CGRectMake(32, 307, 200, 50)];
      [likes setTextColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f]];
      [likes setBackgroundColor:[UIColor clearColor]];
      [likes setFont:[UIFont fontWithName:@"Avenir" size:11]];
      likes.numberOfLines = 1;
      likes.tag = 106;
      [cell addSubview:likes];
  }
    
    PFImageView *imageView = (PFImageView *)[cell viewWithTag:100];
    imageView.file = [photo objectForKey:@"image"];
    [imageView loadInBackground];

    UILabel *desc = (UILabel *)[cell viewWithTag:104];
    desc.text = [photo objectForKey:@"caption"];//@"Mountain View, CA";
    
    UILabel *likes = (UILabel *)[cell viewWithTag:106];
    likes.text = @"22 likes";
    
    

  
  return cell;
}


@end
