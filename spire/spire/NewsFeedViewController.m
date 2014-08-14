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
#import "SPNewsFeedCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
#import "SettingsViewController.h"

@interface NewsFeedViewController ()<UIActionSheetDelegate> {
  UIImage *locationIcon;
    UIImage *heartIcon;
    UIImage *commentIcon;
  UIImage *heartButtonUnactiveIcon;
  UIImage *heartButtonActiveIcon;
  UIImage *commentButtonIcon;
  UIActionSheet *moreActions;
  UIImage *shareButtonIcon;
}


@end

@implementation NewsFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    commentButtonIcon = [UIImage imageNamed:@"newsfeedcommentbutton.png"];
    locationIcon = [UIImage imageNamed:@"locationicon.png"];
      heartIcon = [UIImage imageNamed:@"hearticon.png"];
      commentIcon = [UIImage imageNamed:@"commenticon.png"];
    heartButtonUnactiveIcon = [UIImage imageNamed:@"heartbuttonunactive.png"];
    heartButtonActiveIcon = [UIImage imageNamed:@"heartbuttonactive.png"];
    shareButtonIcon = [UIImage imageNamed:@"newsfeedmoreoptions.png"];
    
    // commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    moreActions = [[UIActionSheet alloc] initWithTitle:@"More Actions" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
      [self initNavBar];
    [self setupMoreActions];
      
  }
  return self;
}

- (void)setupMoreActions
{
  [moreActions addButtonWithTitle:@"Report this post"];
  [moreActions addButtonWithTitle:@"Share post"];
  moreActions.cancelButtonIndex = [moreActions addButtonWithTitle:@"Cancel"];
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
    PFQuery *query = [SPPhoto query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.photos = [[NSMutableArray alloc] initWithArray:objects];
            
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTouched:) name:@"openCommentsForPhoto"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTouched:) name:@"openMoreForPhoto"  object:nil];
  
}

-(void)refreshView:(NSNotification *) notification{
    if (self == self.navigationController.topViewController)
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)cellTouched:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"openCommentsForPhoto"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *photoIndex = [userInfo objectForKey:@"photoIndex"];
        
        SPPhoto *photo = [self.photos objectAtIndex:[photoIndex integerValue]];
        CommentsViewController *ppvc = [[CommentsViewController alloc] initWithPhoto:photo];
        
        [self.navigationController pushViewController:ppvc animated:YES];
    } else if ([[notification name] isEqualToString:@"openMoreForPhoto"]) {
        [moreActions showFromTabBar:[[self tabBarController] tabBar]];
    }
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
  return 480;
}

//for each header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // TODO: if this is clicked, then open person's profile
    SPPhoto *photo = [self.photos objectAtIndex:section];
  UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    [view addTarget:self action:@selector(personTouched:) forControlEvents:UIControlEventTouchUpInside];
    
  
  UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
  
  //setup avatar
    SPUser *avatar = [photo user];
    PFImageView *avatarView = [[PFImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
    avatarView.image =[UIImage imageNamed:@"tempnewsavatar.png"];
    avatarView.file = [avatar fbProfilePic];
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
  
    avatarName.text = [avatar username];
  avatarName.lineBreakMode = NSLineBreakByWordWrapping;
  avatarName.numberOfLines = 0;
  [view addSubview:avatarName];
  
  // setup tags
  UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(71, 21, 300, 50)];
  [tags setTextColor:descColor];
  [tags setBackgroundColor:[UIColor clearColor]];
  [tags setFont:[UIFont fontWithName:@"Avenir" size:12]];
  
  tags.lineBreakMode = NSLineBreakByWordWrapping;
  tags.numberOfLines = 0;
  [view addSubview:tags];
    
    // setup location icon
    UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 11/1.5f, 17/1.5f)];
    locationIconView.image = locationIcon;
    locationIconView.tag = 101;
    [view addSubview:locationIconView];
    
    tags.text = [photo locName];
  
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
    SPUser *user = [[self.photos objectAtIndex:(button.tag - 800)] objectForKey:@"user"];
    
    if ([user.objectId isEqualToString:[[PFUser currentUser] objectId]]) {
        [self.tabBarController setSelectedIndex:4];
    } else {
        ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}
//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPhoto *photo = [self.photos objectAtIndex:indexPath.section];
    [photo setAttributesWithLikers:[[NSArray alloc] init] commenters:[[NSArray alloc] init] likedByCurrentUser:NO];
    
  static NSString *MyIdentifier = @"Cell";
  SPNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
      cell = [[SPNewsFeedCell alloc] initWithPhoto:photo photoIndex:indexPath.section style:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  } else {
    cell.photo = photo;
    cell.photoIndex = [NSNumber numberWithInteger:indexPath.section];
    [cell reloadCell];
  }
  
  return cell;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    return;
  }
  NSString *message = [moreActions buttonTitleAtIndex:buttonIndex];
    NSLog(@"action logged: %@", message);
}



@end
