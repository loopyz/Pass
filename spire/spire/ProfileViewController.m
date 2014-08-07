//
//  ProfileViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "ProfileViewController.h"
#import "PetProfileViewController.h"
#import "SPProfilePetCell.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

static const int kHeaderSize = 210;

@interface ProfileViewController () {
  UIImage *locationIcon;
  UIImage *heartButtonIcon;
  UIImage *commentButtonIcon;
}

@end

@implementation ProfileViewController

- (id)initWithUser:(PFUser *)user
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bgColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
        self.user = user;
        self.navigationItem.title = [user objectForKey:@"username"];
        self.photos = [[NSMutableArray alloc] init];
        [self setupHeader];
        
        locationIcon = [UIImage imageNamed:@"locationicon.png"];
        heartButtonIcon = [UIImage imageNamed:@"heartbutton.png"];
        commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
        
        self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
        
        // TODO: GET FOLLOW BUTTON STATE FROM PARSE. IF FOLLOWING, SAY YES
        self.isFollowing = NO;
    }
    return self;
}

- (void)setupHeader
{
    PFUser *currentUser = self.user;
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kHeaderSize)];
  view.backgroundColor = [UIColor whiteColor];
  self.profileSnippetView = view;
  self.fbProfilePic = [[FBProfilePictureView alloc] init];

      
    self.fbProfilePic.profileID = [currentUser objectForKey:@"fbId"];
    //setup name label
    UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(108, 10, 300, 50)];
      
      
    [name setTextColor:nameColor];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"Avenir" size:22]];
      
    name.text = [currentUser objectForKey:@"username"]; //@"loopyz";
    [self.profileSnippetView addSubview:name];
    [self addProfile];

  
  // setup description
  UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
  
  UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(108, 38, 180, 50)];
  [description setTextColor:descriptionColor];
  [description setBackgroundColor:[UIColor clearColor]];
  [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    description.text = [currentUser objectForKey:@"description"];//@"I really like pizza. And travel.";
  
  [self.profileSnippetView addSubview:description];
  
  // setup website
  UIColor *websiteColor = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
  UILabel *website = [[UILabel alloc] initWithFrame:CGRectMake(108, 60, 150, 50)];
  [website setTextColor:websiteColor];
  [website setBackgroundColor:[UIColor clearColor]];
  [website setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    website.text = [currentUser objectForKey:@"website"]; //@"http://www.lucy.ws";
  
  [self.profileSnippetView addSubview:website];
  
  
  //setup score, offers, and pending label
  UIColor *tinyLabelColor = [UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1.0f];
  
  UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(40, 120, 150, 50)];
  [score setTextColor:tinyLabelColor];
  [score setBackgroundColor:[UIColor clearColor]];
  [score setFont:[UIFont fontWithName:@"Avenir" size:13]];
  score.text = @"Posts";
  
  UILabel *offers = [[UILabel alloc] initWithFrame:CGRectMake(140, 120, 150, 50)];
  [offers setTextColor:tinyLabelColor];
  [offers setBackgroundColor:[UIColor clearColor]];
  [offers setFont:[UIFont fontWithName:@"Avenir" size:13]];
  offers.text = @"Followers";
  
    UILabel *pending = [[UILabel alloc] initWithFrame:CGRectMake(240, 120, 150, 50)];
    [pending setTextColor:tinyLabelColor];
    [pending setBackgroundColor:[UIColor clearColor]];
    [pending setFont:[UIFont fontWithName:@"Avenir" size:13]];
    pending.text = @"Following";
  
  
  UILabel *numScore = [[UILabel alloc] initWithFrame:CGRectMake(35, 100, 40, 50)];
  [numScore setTextColor:[UIColor colorWithRed:68/255.0f green:203/255.0f blue:154/255.0f alpha:1.0f]];
  [numScore setBackgroundColor:[UIColor clearColor]];
  numScore.textAlignment = NSTextAlignmentCenter;
  [numScore setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numScore.text = @"123";
    self.numScoresLabel = numScore;
  
  UILabel *numoffers = [[UILabel alloc] initWithFrame:CGRectMake(155, 100, 25, 50)];
  [numoffers setTextColor:[UIColor colorWithRed:105/255.0f green:32/255.0f blue:213/255.0f alpha:1.0f]];
  [numoffers setBackgroundColor:[UIColor clearColor]];
  numoffers.textAlignment = NSTextAlignmentCenter;
  [numoffers setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numoffers.text = @"8";
  
  UILabel *numPending = [[UILabel alloc] initWithFrame:CGRectMake(253, 100, 32, 50)];
  [numPending setTextColor:[UIColor colorWithRed:206/255.0f green:34/255.0f blue:155/255.0f alpha:1.0f]];
  [numPending setBackgroundColor:[UIColor clearColor]];
  numPending.textAlignment = NSTextAlignmentCenter;
  [numPending setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numPending.text = @"2";
  
  [self.profileSnippetView addSubview:score];
  [self.profileSnippetView addSubview:offers];
  [self.profileSnippetView addSubview:pending];
  
  [self.profileSnippetView addSubview:numScore];
  [self.profileSnippetView addSubview:numoffers];
  [self.profileSnippetView addSubview:numPending];
  
    self.followButton = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2 - 281/2, 160, 281, 35)];
    
    // TODO: CHECK IF YOU ARE ON YOUR OWN PROFILE. IF SO, SHOW editprofilebutton.png and have it go to another selector that leads to settings.
    
    [self.followButton addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage;
    if (self.isFollowing) {
        btnImage = [UIImage imageNamed:@"followingbutton.pnrg"];
    }
    else {
        btnImage = [UIImage imageNamed:@"followbutton.png"];
    }
    [self.followButton setImage:btnImage forState:UIControlStateNormal];
    self.followButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.profileSnippetView addSubview:self.followButton];
  
    self.profileSnippetView.backgroundColor = [UIColor whiteColor];

}

- (void)followUser: (id) sender
{
    
    UIImage *btnImage;
    
    if (self.isFollowing) {
        self.isFollowing = NO;
        btnImage = [UIImage imageNamed:@"followbutton.png"];
    }
    else {
        self.isFollowing = YES;
        btnImage = [UIImage imageNamed:@"followingbutton.png"];
    }
    
    [self.followButton setImage:btnImage forState:UIControlStateNormal];
    
    [Util followUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"yay, followed");
        } else {
            NSLog(@"booh. no followed");
        }
    }];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
    // [self.ptr viewDidScroll:scrollView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
  self.tableView.contentInset = inset;
    
//    self.ptr = [[PullToRefresh alloc] initWithNumberOfDots:5];
//    self.ptr.delegate = self;
//    [self.view addSubview:self.ptr];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    
    [self Refresh];

  // Do any additional setup after loading the view.
}

- (void)refreshView
{
    PFQuery *countquery = [PFQuery queryWithClassName:kSPPhotoClassKey];
    [countquery whereKey:@"user" equalTo:self.user];
    [countquery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.numScoresLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:kSPPhotoClassKey];
    [query includeKey:@"pet"];
    [query whereKey:@"user" equalTo:self.user];
    [query whereKeyExists:@"first"]; // neccessary?
    [query whereKey:@"first" equalTo:@1];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = [[NSMutableArray alloc] init];
            [self.photos addObjectsFromArray:objects];

            [self.tableView reloadData];
        }
    }];
}

- (void)Refresh {
    [self refreshView];
    
    // Perform here the required actions to refresh the data (call a JSON API for example).
    // Once the data has been updated, call the method isDoneRefreshing:
    // [self.ptr isDoneRefreshing];
    
    [self.refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
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
  return [self.photos count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) return kHeaderSize;
  return 130;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }
    return indexPath;
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell;
  if (indexPath.row != 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
    
    if (cell == nil) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Header"];
        }
        else {
            PFObject *pet = [[self.photos objectAtIndex:(indexPath.row-1)] objectForKey:@"pet"];
            cell = [[SPProfilePetCell alloc] initWithPet:pet style:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 0;
        cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor whiteColor];
            [cell addSubview:self.profileSnippetView];
        }
    }
  
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
  if (indexPath.row == 0) {
    
  }//do not nothing
  else {
    NSLog(@"opening pet profile");
    PFObject *pet = [[self.photos objectAtIndex:(indexPath.row-1)] objectForKey:@"pet"];
    PetProfileViewController *ppvc = [[PetProfileViewController alloc] initWithNibName:nil bundle:nil];
      ppvc.petId = [pet objectId];
    [self.navigationController pushViewController:ppvc animated:YES];
  }
}


@end
