//
//  FindPetViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "FindPetViewController.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainSreen] bounds].size.width)

@interface FindPetViewController ()

@property (strong, nonatomic) NSArray *headerBig;
@property (strong, nonatomic) NSArray *headerDetail;

@end

@implementation FindPetViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      UIColor * color = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
      self.tableView.backgroundColor = color;
      self.headerBig = @[@"Here", @"A walk away", @"A drive away"];
      self.headerDetail = @[@"500 feet", @"1.0 miles away", @"5.0 miles away"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
  self.tableView.contentInset = inset;
  [self.tableView setAllowsSelection:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3; //number of items
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 130;
}

//for each header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
  
  UIColor *color = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
  
  // setup tags
  UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
  [tags setTextColor:color];
  [tags setBackgroundColor:[UIColor clearColor]];
  [tags setFont:[UIFont fontWithName:@"Avenir-Bold" size:13]];
  
  tags.text = self.headerBig[section];
  tags.lineBreakMode = NSLineBreakByWordWrapping;
  tags.numberOfLines = 0;
  [view addSubview:tags];
  
  UILabel *distance;
  
  if (section == 0) {
    distance = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 150, 30)];
  }
  else if (section == 1) {
    distance = [[UILabel alloc] initWithFrame:CGRectMake(115, 5, 150, 30)];
  }
  else {
    distance = [[UILabel alloc] initWithFrame:CGRectMake(115, 5, 150, 30)];
  }
  [distance setTextColor:color];
  [distance setBackgroundColor:[UIColor clearColor]];
  [distance setFont:[UIFont fontWithName:@"Avenir" size:12]];
  
  distance.text = self.headerDetail[section];
  distance.lineBreakMode = NSLineBreakByWordWrapping;
  distance.numberOfLines = 0;
  [view addSubview:distance];
  
  view.backgroundColor = [UIColor whiteColor];
  view.alpha = .94f;
  
  return view;
}

- (void)setupCollection:(NSIndexPath *)indexPath withView:(UIView *)view
{
  NSUInteger numberOfRowsInSection = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
  NSUInteger currentRow = indexPath.row;
  
  UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
  
  // NOT the last row - so we know 3 images per thing.
  if (currentRow != numberOfRowsInSection - 1) {
    // TODO: use correct values in an array
    for (int x = 0; x < 3; x++) {
      UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 100 * x, 20, 73.5, 73.5)];
      tempView.image = [UIImage imageNamed:@"tempavatar.png"];
      [view addSubview:tempView];
      
      UILabel *tempLocation = [[UILabel alloc] initWithFrame:CGRectMake(7 + (100 * x), 55, 100, 120)];
      tempLocation.textAlignment = NSTextAlignmentCenter;
      tempLocation.text = @"Mission Dolores Park";
      tempLocation.numberOfLines = 0;
      tempLocation.lineBreakMode = NSLineBreakByWordWrapping;
      tempLocation.textColor = descColor;
      tempLocation.font = [UIFont fontWithName:@"Avenir" size:11.0f];
      
      [view addSubview:tempLocation];
    }
  }
  
  else {
    // TODO: is the last row - check how many images are left to show lol
    for (int x = 0; x < 3; x++) {
      UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 100 * x, 10, 73.5, 73.5)];
      tempView.image = [UIImage imageNamed:@"tempavatar.png"];
      [view addSubview:tempView];
      
      UILabel *tempLocation = [[UILabel alloc] initWithFrame:CGRectMake(7 + (100 * x), 45, 100, 120)];
      tempLocation.textAlignment = NSTextAlignmentCenter;
      tempLocation.text = @"Mission Dolores Park";
      tempLocation.numberOfLines = 0;
      tempLocation.lineBreakMode = NSLineBreakByWordWrapping;
      tempLocation.textColor = descColor;
      tempLocation.font = [UIFont fontWithName:@"Avenir" size:11.0f];
      
      [view addSubview:tempLocation];

    }
  }
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  UIView *tempView;
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    
  }
  
  cell.backgroundColor = [UIColor clearColor];
  
  
  //  PFObject *object = self.videos[indexPath.row];
  //  PFFile *videoFile = [object objectForKey:@"file"];
  //  NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
  //  self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 280) contentURL:fileUrl];
  //  [cell addSubview:self.player];
  //[self.player play];
  //MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:fileUrl];
  //[self presentMoviePlayerViewControllerAnimated:movie];

  
  [self setupCollection:indexPath withView:tempView];
  
  [cell addSubview:tempView];
  
  
  return cell;
}


@end
