//
//  ProfileViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface ProfileViewController () {
  UIImage *locationIcon;
  UIImage *heartButtonIcon;
  UIImage *commentButtonIcon;
}

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.bgColor = [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
    self.videos = [[NSMutableArray alloc] init];
    [self setupScrollView];
    [self setupHeader];
    [self setupTable];
    
    locationIcon = [UIImage imageNamed:@"locationicon.png"];
    heartButtonIcon = [UIImage imageNamed:@"heartbutton.png"];
    commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
    
    UIBarButtonItem *rbb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsicon.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(refreshView)];
  }
  return self;
}

- (void)setupHeader
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.videosTable.frame.size.width, 164)];
  self.profileSnippetView = view;
  self.fbProfilePic = [[FBProfilePictureView alloc] init];
  FBRequest *request = [FBRequest requestForMe];
  [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      NSDictionary *userData = (NSDictionary *)result;
      
      if (![[PFUser currentUser] objectForKey:@"fbId"]) {
        [[PFUser currentUser] setObject:userData[@"id"] forKey:@"fbId"];
        [[PFUser currentUser] save];
      }
      self.userid = userData[@"id"];
      NSString *username = userData[@"name"];
      
      self.fbProfilePic.profileID = self.userid;
      //setup name label
      UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
      UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(108, 10, 300, 50)];
      
      
      [name setTextColor:nameColor];
      [name setBackgroundColor:[UIColor clearColor]];
      [name setFont:[UIFont fontWithName:@"Avenir" size:22]];
      
      name.text = username; //@"loopyz";
      [self.profileSnippetView addSubview:name];
      [self addProfile];
    }
  }];
  
  // setup description
  UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
  
  UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(108, 38, 180, 50)];
  [description setTextColor:descriptionColor];
  [description setBackgroundColor:[UIColor clearColor]];
  [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
  description.text = @"I really like pizza. And travel.";
  
  [self.scrollView addSubview:description];
  
  // setup website
  UIColor *websiteColor = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
  UILabel *website = [[UILabel alloc] initWithFrame:CGRectMake(108, 60, 150, 50)];
  [website setTextColor:websiteColor];
  [website setBackgroundColor:[UIColor clearColor]];
  [website setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
  website.text = @"http://www.lucy.ws";
  
  [self.scrollView addSubview:website];
  
  
  //setup score, offers, and pending label
  UIColor *tinyLabelColor = [UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1.0f];
  
  UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 150, 50)];
  [score setTextColor:tinyLabelColor];
  [score setBackgroundColor:[UIColor clearColor]];
  [score setFont:[UIFont fontWithName:@"Avenir" size:13]];
  score.text = @"Posts";
  
  UILabel *offers = [[UILabel alloc] initWithFrame:CGRectMake(150, 120, 150, 50)];
  [offers setTextColor:tinyLabelColor];
  [offers setBackgroundColor:[UIColor clearColor]];
  [offers setFont:[UIFont fontWithName:@"Avenir" size:13]];
  offers.text = @"Followers";
  
  UILabel *pending = [[UILabel alloc] initWithFrame:CGRectMake(250, 120, 150, 50)];
  [pending setTextColor:tinyLabelColor];
  [pending setBackgroundColor:[UIColor clearColor]];
  [pending setFont:[UIFont fontWithName:@"Avenir" size:13]];
  pending.text = @"Following";
  
  UILabel *numScore = [[UILabel alloc] initWithFrame:CGRectMake(45, 100, 40, 50)];
  [numScore setTextColor:[UIColor colorWithRed:68/255.0f green:203/255.0f blue:154/255.0f alpha:1.0f]];
  [numScore setBackgroundColor:[UIColor clearColor]];
  numScore.textAlignment = NSTextAlignmentCenter;
  [numScore setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numScore.text = @"123";
  
  UILabel *numoffers = [[UILabel alloc] initWithFrame:CGRectMake(165, 100, 25, 50)];
  [numoffers setTextColor:[UIColor colorWithRed:105/255.0f green:32/255.0f blue:213/255.0f alpha:1.0f]];
  [numoffers setBackgroundColor:[UIColor clearColor]];
  numoffers.textAlignment = NSTextAlignmentCenter;
  [numoffers setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numoffers.text = @"8";
  
  UILabel *numPending = [[UILabel alloc] initWithFrame:CGRectMake(263, 100, 32, 50)];
  [numPending setTextColor:[UIColor colorWithRed:206/255.0f green:34/255.0f blue:155/255.0f alpha:1.0f]];
  [numPending setBackgroundColor:[UIColor clearColor]];
  numPending.textAlignment = NSTextAlignmentCenter;
  [numPending setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numPending.text = @"2";
  
  [view addSubview:score];
  [view addSubview:offers];
  [view addSubview:pending];
  
  [view addSubview:numScore];
  [view addSubview:numoffers];
  [view addSubview:numPending];
  
  
  
  view.backgroundColor = [UIColor whiteColor];
  
  [self.scrollView addSubview:view];
}

- (void)addProfile
{
  
  self.fbProfilePic.backgroundColor = [UIColor blackColor];
  self.fbProfilePic.frame = CGRectMake(17, 23, 71, 71);
  
  //makes it into circle
  float width = self.fbProfilePic.bounds.size.width;
  self.fbProfilePic.layer.cornerRadius = width/2;
  
  [self.profileSnippetView addSubview:self.fbProfilePic];
  
}

- (void)setupTable
{
  CGRect tableViewRect = CGRectMake(0, 164, SCREEN_WIDTH, 540);
  
  self.videosTable = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
  self.videosTable.delegate = self;
  self.videosTable.dataSource = self;
  self.videosTable.backgroundColor = [UIColor clearColor];
  [self.videosTable setAllowsSelection:NO];
  [self.scrollView addSubview:self.videosTable];
}


- (void)setupScrollView
{
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); //scroll view occupies full parent view!
  //specify CGRect bounds in place of self.view.bounds to make it as a portion of parent view!
  
  self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 870);   //scroll view size
  
  self.scrollView.showsVerticalScrollIndicator = NO;    // to hide scroll indicators!
  
  self.scrollView.showsHorizontalScrollIndicator = YES; //by default, it shows!
  
  self.scrollView.scrollEnabled = YES;                 //say "NO" to disable scroll
  
  
  [self.view addSubview:self.scrollView];               //adding to parent view!
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  
  //    // Do any additional setup after loading the view.
  //    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
  //    if ([PFUser currentUser]) {
  //        [query whereKey:@"creator" equalTo:[PFUser currentUser]];
  //    }
  //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
  //        if (objects) {
  //            self.videos = objects;
  //            [self.videosTable reloadData];
  //        }
  //    }];
}

- (void)refreshView
{
  PFQuery *query = [PFQuery queryWithClassName:@"Video"];
  if ([PFUser currentUser]) {
    [query whereKey:@"creator" equalTo:[PFUser currentUser]];
  }
  [query orderByDescending:@"createdAt"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (objects) {
      self.videos = objects;
      [self.videosTable reloadData];
    }
  }];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1; //number of alphabet letters + recent
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  NSUInteger vcount = [self.videos count];
//  self.videosTable.frame = CGRectMake(0, 130, SCREEN_WIDTH, vcount * 335);
//  self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 245 + (vcount * 335));
//  return vcount;
  
  return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 335;
}


//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
  }
  
  cell.backgroundColor = self.bgColor;
//  PFObject *object = self.videos[indexPath.row];
//  PFFile *videoFile = [object objectForKey:@"file"];
//  NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
//  self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 280) contentURL:fileUrl];
//  [cell addSubview:self.player];
  //[self.player play];
  //MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:fileUrl];
  //[self presentMoviePlayerViewControllerAnimated:movie];
  
  UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 295, 11, 17)];
  locationIconView.image = locationIcon;
  [cell addSubview:locationIconView];
  
  // setup comment button
  UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
  
  commentButton.frame = CGRectMake(self.view.frame.size.width - 90, 295, 32.5, 22);
  [commentButton addTarget:self action:@selector(commentTouched) forControlEvents:UIControlEventTouchUpInside];
  [cell addSubview:commentButton];
  [commentButton setImage:commentButtonIcon forState:UIControlStateNormal];
  commentButton.contentMode = UIViewContentModeScaleToFill;
  
  // setup heart button
  UIButton *heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [commentButton setTitle:@"Heart" forState:UIControlStateNormal];
  
  heartButton.frame = CGRectMake(self.view.frame.size.width - 40, 295, 32.5, 22);
  [heartButton addTarget:self action:@selector(heartTouched) forControlEvents:UIControlEventTouchUpInside];
  [cell addSubview:heartButton];
  [heartButton setImage:heartButtonIcon forState:UIControlStateNormal];
  heartButton.contentMode = UIViewContentModeScaleToFill;
  
  //setup Location label
  UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
  UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(26, 280, 200, 50)];
  [desc setTextColor:descColor];
  [desc setBackgroundColor:[UIColor clearColor]];
  [desc setFont:[UIFont fontWithName:@"Avenir" size:11]];
  
  desc.text = @"Mountain View, CA";
  desc.lineBreakMode = NSLineBreakByWordWrapping;
  desc.numberOfLines = 0;
  [cell addSubview:desc];
  
  return cell;
}

- (void)commentTouched
{
  
}

- (void)heartTouched
{
  
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // blah
}


@end
