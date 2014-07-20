//
//  SingleImageViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SingleImageViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SingleImageViewController ()

@end

@implementation SingleImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
      
      [self setupCaption];
      [self setupImage];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {return YES;}

- (void)setupImage
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 164)];
  
  self.imageView = view;
  
  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  imgView.image = [UIImage imageNamed:@"tempsingleimage.png"];
  
  [view addSubview:imgView];
  
  // setup buttons
  // Do any additional setup after loading the view.
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  backButton.frame = CGRectMake(15, 15, 31.5, 31.5);
  [backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *btnImage = [UIImage imageNamed:@"circlebackbutton.png"];
  [backButton setImage:btnImage forState:UIControlStateNormal];
  backButton.contentMode = UIViewContentModeScaleToFill;
  
  [view addSubview:backButton];
  
  UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  commentButton.frame = CGRectMake(270, 15, 31.5, 31.5);
  [commentButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
  
  btnImage = [UIImage imageNamed:@"circlecommentbutton.png"];
  [commentButton setImage:btnImage forState:UIControlStateNormal];
  commentButton.contentMode = UIViewContentModeScaleToFill;
  
  [view addSubview:commentButton];
  
  UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  likeButton.frame = CGRectMake(230, 15, 31.5, 31.5);
  [likeButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
  
  btnImage = [UIImage imageNamed:@"circlelikebutton.png"];
  [likeButton setImage:btnImage forState:UIControlStateNormal];
  likeButton.contentMode = UIViewContentModeScaleToFill;
  
  [view addSubview:likeButton];
}

- (void)backButtonTouched
{
  // TODO: BACK BUTTON TOUCHED
  // [self.navigationController popViewControllerAnimated:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupCaption
{
  PFUser *currentUser = [PFUser currentUser];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 164)];
  
  self.captionView = view;
  self.fbProfilePic = [[FBProfilePictureView alloc] init];
  
  self.fbProfilePic.profileID = [currentUser objectForKey:@"fbId"];
  //setup name label
  UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
  UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 35)];
  
  
  [name setTextColor:nameColor];
  [name setBackgroundColor:[UIColor clearColor]];
  [name setFont:[UIFont fontWithName:@"Avenir" size:15]];
  
  name.text = [currentUser objectForKey:@"username"]; //@"loopyz";
  [self.captionView addSubview:name];
  [self addProfile];
  
  
  // setup description
  UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
  
  UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 75)];
  [description setTextColor:descriptionColor];
  [description setBackgroundColor:[UIColor clearColor]];
  [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
  description.text = [currentUser objectForKey:@"description"];//@"I really like pizza. And travel.";
  
  [self.captionView addSubview:description];
  
}

- (void)addProfile
{
  
  self.fbProfilePic.backgroundColor = [UIColor blackColor];
  self.fbProfilePic.frame = CGRectMake(17, 8, 40, 40);
  
  //makes it into circle
  float width = self.fbProfilePic.bounds.size.width;
  self.fbProfilePic.layer.cornerRadius = width/2;
  [self.captionView addSubview:self.fbProfilePic];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:YES];
  // Do any additional setup after loading the view.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
  
  NSUInteger count = 3 + 1;

  return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) return 320;
  if (indexPath.row == 1) return 58;
  return 130;
}


//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell;
  if (indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  else if (indexPath.row == 1) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Caption"];
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  }
  if (cell == nil && indexPath.row == 0) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Header"];
    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
  }
  else if (cell == nil && indexPath.row == 1) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Caption"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowRadius = 0;
    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
  }
  else if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:251/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowRadius = 0;
    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
  }
  
  if (indexPath.row == 0) {
    [cell addSubview:self.imageView];
  }
  else if (indexPath.row == 1) {
    [cell addSubview:self.captionView];
  }
  else {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 77, 77)];
    imgView.image = [UIImage imageNamed:@"fox.png"];
    [cell addSubview:imgView];
    
    
    //setup Location label
    UIColor *descColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:1.0f];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 200, 50)];
    [desc setTextColor:descColor];
    [desc setBackgroundColor:[UIColor clearColor]];
    [desc setFont:[UIFont fontWithName:@"Avenir" size:24]];
    
    desc.text = @"Pusheen";
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.numberOfLines = 0;
    [cell addSubview:desc];
    
    // set up miles traveled
    UILabel *numMiles = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 200, 50)];
    [numMiles setTextColor:descColor];
    [numMiles setBackgroundColor:[UIColor clearColor]];
    [numMiles setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
    
    numMiles.text = @"2187";
    numMiles.lineBreakMode = NSLineBreakByWordWrapping;
    numMiles.numberOfLines = 0;
    [cell addSubview:numMiles];
    
    // setup miles label
    UILabel *milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 200, 50)];
    [milesLabel setTextColor:descColor];
    [milesLabel setBackgroundColor:[UIColor clearColor]];
    [milesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    milesLabel.text = @"miles";
    milesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    milesLabel.numberOfLines = 0;
    [cell addSubview:milesLabel];
    
    // set up miles traveled
    UILabel *numPasses = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 200, 50)];
    [numPasses setTextColor:descColor];
    [numPasses setBackgroundColor:[UIColor clearColor]];
    [numPasses setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
    
    numPasses.text = @"1322";
    numPasses.lineBreakMode = NSLineBreakByWordWrapping;
    numPasses.numberOfLines = 0;
    [cell addSubview:numPasses];
    
    // setup miles label
    UILabel *passesLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 60, 200, 50)];
    [passesLabel setTextColor:descColor];
    [passesLabel setBackgroundColor:[UIColor clearColor]];
    [passesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    passesLabel.text = @"passes";
    passesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    passesLabel.numberOfLines = 0;
    [cell addSubview:passesLabel];
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
  if (indexPath.row == 0 || indexPath.row == 1) {
   // do nothing
    NSLog(@"%d", indexPath.row);
  }
  else {
    NSLog(@"have it go to user profile?");
      }
}


@end
