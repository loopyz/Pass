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
    PFQuery *query = [PFQuery queryWithClassName:kSPPhotoClassKey];
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
    // change image of button
  UIButton *heartButton = (UIButton *)sender;
  heartButton.selected = !heartButton.selected;
  
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
  return 480;
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
  [tags setFont:[UIFont fontWithName:@"Avenir" size:12]];
  
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
      cell.backgroundColor =  [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f];
    
    // setup information view
    UIView *informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 450)];
    informationView.backgroundColor = [UIColor whiteColor];
      PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
      imageView.image =[UIImage imageNamed:@"tempsingleimage.png"];
      imageView.tag = 100;
      [informationView addSubview:imageView];
      
      UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
    
    
      // setup comment icon
//      UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 348, 12, 12)];
//      locationIconView.image = commentIcon;
//      locationIconView.tag = 101;
//      locationIconView.backgroundColor = [UIColor clearColor];
//      [informationView addSubview:locationIconView];
      
      //setup caption label
      UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(15, 320, 200, 50)];
      [desc setTextColor:descColor];
      [desc setBackgroundColor:[UIColor clearColor]];
      [desc setFont:[UIFont fontWithName:@"Avenir" size:17]];
      desc.lineBreakMode = NSLineBreakByWordWrapping;
      desc.numberOfLines = 0;
      desc.tag = 104;
      [informationView addSubview:desc];
    
    // setup separator
    UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(14.75, desc.frame.origin.y + desc.frame.size.height + 25, 291, 3)];
    separator.image = [UIImage imageNamed:@"newsfeedborder.png"];
    separator.tag = 105;
    [informationView addSubview:separator];
    
      //setup likes label
    UIButton *likesButton = [[UIButton alloc] initWithFrame:CGRectMake(9, desc.frame.origin.y + desc.frame.size.height, 55, 20)];
    [likesButton addTarget:self action:@selector(seeLikes:) forControlEvents:UIControlEventTouchUpInside];
    

    [likesButton setTitleColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [likesButton setTitle:@"22 likes" forState:UIControlStateNormal];
    likesButton.tag = 106;
    likesButton.titleLabel.font =[UIFont fontWithName:@"Avenir" size:12];

    
//      UILabel *likes = [[UILabel alloc] initWithFrame:CGRectMake(15, desc.frame.origin.y + desc.frame.size.height - 16, 55, 50)];
//      [likes setTextColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f]];
//      [likes setBackgroundColor:[UIColor clearColor]];
//      [likes setFont:[UIFont fontWithName:@"Avenir" size:12]];
//      likes.numberOfLines = 1;
//      likes.tag = 106;
//    [likesButton addSubview:likes];
    
      [informationView addSubview:likesButton];
    
    //setup comments label
    UIButton *commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(likesButton.frame.origin.x + likesButton.frame.size.width, desc.frame.origin.y + desc.frame.size.height, 100, 20)];
    
    [commentsButton setTitleColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [commentsButton setTitle:@"12 comments" forState:UIControlStateNormal];
    commentsButton.tag = 107;
    commentsButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    [commentsButton addTarget:self action:@selector(commentTouched:) forControlEvents:UIControlEventTouchUpInside];
    [informationView addSubview:commentsButton];
    
    
//    UILabel *comments = [[UILabel alloc] initWithFrame:CGRectMake(likesButton.frame.origin.x + likesButton.frame.size.width, desc.frame.origin.y + desc.frame.size.height - 16, 200, 50)];
//    [comments setTextColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f]];
//    [comments setBackgroundColor:[UIColor clearColor]];
//    [comments setFont:[UIFont fontWithName:@"Avenir" size:12]];
//    comments.numberOfLines = 1;
//    comments.tag = 107;
//    [informationView addSubview:comments];
    
    [cell addSubview:informationView];
    
    // testing shit out
    
    UIButton *heartButton = [[UIButton alloc] init];
    // Hardcode the x value and size for simplicity
    BOOL isLiked = NO;
    heartButton.selected = isLiked ? YES : NO;
    heartButton.frame = CGRectMake(15, separator.frame.origin.y + separator.frame.size.height + 10, 28, 28);
    heartButton.tag = 103;
    [heartButton setImage:[UIImage imageNamed:@"likeButton_unselected.png"] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"likeButton_selected.png"] forState:UIControlStateSelected];
    [heartButton setImage:[UIImage imageNamed:@"likeButton_highlighted.png"] forState:UIControlStateHighlighted];
    [heartButton addTarget:self action:@selector(heartTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:heartButton];
    
    // setup comment button
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
    commentButton.frame = CGRectMake(heartButton.frame.size.height + heartButton.frame.origin.x + 30, separator.frame.origin.y + separator.frame.size.height + 10, 28, 26);
    
    commentButton.tag = 102;
    [informationView addSubview:commentButton];
    [commentButton setImage:commentButtonIcon forState:UIControlStateNormal];
    commentButton.contentMode = UIViewContentModeScaleToFill;
    [commentButton addTarget:self action:@selector(commentTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    // setup share button
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(self.view.frame.size.width - 50, separator.frame.origin.y + separator.frame.size.height + 10, 31, 31);
    
    shareButton.tag = 108;
    [informationView addSubview:shareButton];
    [shareButton setImage:shareButtonIcon forState:UIControlStateNormal];
    shareButton.contentMode = UIViewContentModeScaleToFill;
    [shareButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];

  }
  
    PFImageView *imageView = (PFImageView *)[cell viewWithTag:100];
    imageView.file = [photo objectForKey:@"image"];
    [imageView loadInBackground];

    UILabel *desc = (UILabel *)[cell viewWithTag:104];
    desc.text = [photo objectForKey:@"caption"];//@"Mountain View, CA";
    
    UIButton *likes = (UIButton *)[cell viewWithTag:106];
  [likes setTitle:@"22 likes" forState:UIControlStateNormal];
  
  UIButton *comments = (UIButton *)[cell viewWithTag:107];
  [comments setTitle:@"12 comments" forState:UIControlStateNormal];
  
  
  return cell;
}

- (void)seeLikes:(id)self
{
  NSLog(@"show people who have liked it here");
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    return;
  }
  NSString *message = [moreActions buttonTitleAtIndex:buttonIndex];
}

- (void)moreButtonPressed
{
  [moreActions showFromTabBar:[[self tabBarController] tabBar]];
  
}



@end
