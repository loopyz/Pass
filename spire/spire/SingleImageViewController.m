//
//  SingleImageViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SingleImageViewController.h"
#import "CommentsViewController.h"
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
        
      
      
    }
    return self;
}

- (id)initWithPhoto:(PFObject *)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
        self.photo = photo;

        
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {return YES;}

- (void)setupImage
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 164)];
  
  self.imageView = view;
  
    PFImageView *imgView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    imgView.image = [UIImage imageNamed:@"tempsingleimage.png"];
    imgView.file = [self.photo objectForKey:@"image"];
    [imgView loadInBackground];
    //  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    //  imgView.image = [UIImage imageNamed:@"tempsingleimage.png"];
    
    [self.imageView addSubview:imgView];
  
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
  [commentButton addTarget:self action:@selector(commentTouched) forControlEvents:UIControlEventTouchUpInside];
  
  btnImage = [UIImage imageNamed:@"circlecommentbutton.png"];
  [commentButton setImage:btnImage forState:UIControlStateNormal];
  commentButton.contentMode = UIViewContentModeScaleToFill;
  
  [view addSubview:commentButton];
  
  UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  likeButton.frame = CGRectMake(230, 15, 31.5, 31.5);
  [likeButton addTarget:self action:@selector(heartTouched) forControlEvents:UIControlEventTouchUpInside];
  
  btnImage = [UIImage imageNamed:@"circlelikebutton.png"];
  [likeButton setImage:btnImage forState:UIControlStateNormal];
  likeButton.contentMode = UIViewContentModeScaleToFill;
  
  [view addSubview:likeButton];
}

- (NSString *)randomPersonAvatar
{
    NSArray* types = @[@"andrewhuang", @"charlotte", @"keithmiller", @"lucyguo", @"nivejayasekar", @"vivianma"];
    
    return types[arc4random() % [types count]];
}

- (NSString *)randomComment
{
    NSArray* types = @[@"Oh gosh I miss my baby.", @"So jealous that you travel more than me.", @"You're so cute!", @"Love that pose!", @"Awesome!", @"I'm gonna get another pet just like you"];
    
    return types[arc4random() % [types count]];
}

- (void)backButtonTouched
{
  // TODO: BACK BUTTON TOUCHED
  [self.navigationController popViewControllerAnimated:YES];
  // [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupCaption
{
  PFUser *user = [self.photo objectForKey:@"user"];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 164)];
  
  self.captionView = view;
  self.fbProfilePic = [[FBProfilePictureView alloc] init];
  
  self.fbProfilePic.profileID = [user objectForKey:@"fbId"];
  //setup name label
  UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
  UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 35)];
  
  
  [name setTextColor:nameColor];
  [name setBackgroundColor:[UIColor clearColor]];
  [name setFont:[UIFont fontWithName:@"Avenir" size:15]];
  
  name.text = [user objectForKey:@"username"]; //@"loopyz";
  [self.captionView addSubview:name];
  [self addProfile];
  
  
  // setup description
  UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
  
  UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 75)];
  [description setTextColor:descriptionColor];
  [description setBackgroundColor:[UIColor clearColor]];
  [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    description.text = [self.photo objectForKey:@"caption"];//@"I really like pizza. And travel.";
  
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

- (FBProfilePictureView *)addProfile:(FBProfilePictureView *)fbPic
{
  fbPic.backgroundColor = [UIColor blackColor];
  fbPic.frame = CGRectMake(17, 8, 40, 40);
  
  //makes it into circle
  float width = self.fbProfilePic.bounds.size.width;
  fbPic.layer.cornerRadius = width/2;
  
  return fbPic;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:YES];
  // Do any additional setup after loading the view.
    if (self.photo) {
        [self setupImage];
        [self setupCaption];
        self.comments = @[[self randomComment], [self randomComment], [self randomComment]];
        self.usernames = @[[self randomPersonAvatar],[self randomPersonAvatar], [self randomPersonAvatar]];
        [self.tableView reloadData];
    }
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
  
  NSUInteger extraRows = 3;
  NSUInteger count = 3 + extraRows;

  return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) return 320;
  if (indexPath.row == 1) return 58;
  if (indexPath.row == 2) return 60;
  return 65;
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
  else if (indexPath.row == 2) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Location"];
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  }
  if (cell == nil && indexPath.row == 0) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Header"];
    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
      [cell addSubview:self.imageView];
      self.imageView.tag = 300;
  }
  else if (cell == nil && indexPath.row == 1) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Caption"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowRadius = 0;
    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
      [cell addSubview:self.captionView];
      self.captionView.tag = 301;
  }
  else if (cell == nil && indexPath.row == 2) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Location"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:251/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowRadius = 0;
    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
      UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 20)];
      city.font = [UIFont fontWithName:@"Avenir" size:20.0f];
      city.textColor = [UIColor colorWithRed:110/255.0f green:91/255.0f blue:214/255.0f alpha:1.0f];
      
      city.tag = 301;
      [cell addSubview:city];
      
      UILabel *numLikes = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 70)];
      numLikes.text = @"22";
      numLikes.font = [UIFont fontWithName:@"Avenir" size:15.0f];
      numLikes.textColor = [UIColor colorWithRed:214/255.0f green:91/255.0f blue:144/255.0f alpha:1.0f];
      numLikes.tag = 302;
      [cell addSubview:numLikes];
      
      UILabel *likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 300, 70)];
      likesLabel.text = @"likes";
      likesLabel.font = [UIFont fontWithName:@"Avenir" size:13.0f];
      likesLabel.textColor = [UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1.0f];
      likesLabel.tag = 303;
      [cell addSubview:likesLabel];

  }
  else if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:251/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowRadius = 0;
    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 164)];
      
      //    self.captionView = view;
      //      self.captionView.tag = 301;
      
      //FBProfilePictureView *fbpic = [[FBProfilePictureView alloc] init];
      
      //fbpic.profileID = [currentUser objectForKey:@"fbId"];
      //setup name label
      UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
      UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 35)];
      name.tag = 304;
      
      
      [name setTextColor:nameColor];
      [name setBackgroundColor:[UIColor clearColor]];
      [name setFont:[UIFont fontWithName:@"Avenir" size:15]];
      
      [cell addSubview:name];
      
      UIImageView *fbPic = [[UIImageView alloc] initWithFrame:CGRectMake(17, 8, 40, 40)];
      
      
      //fbpic = [self addProfile:fbpic];
      
      //[cell addSubview:fbpic];
      //fbPic.backgroundColor = [UIColor blackColor];
      fbPic.frame = CGRectMake(17, 8, 40, 40);
      
      //makes it into circle
      float width = fbPic.bounds.size.width;
      fbPic.layer.cornerRadius = width/2;
      fbPic.tag = 305;
      [cell addSubview:fbPic];
      // setup description
      UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
      
      UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 75)];
      [description setTextColor:descriptionColor];
      [description setBackgroundColor:[UIColor clearColor]];
      [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
      
      description.tag = 306;
      [cell addSubview:description];

  }
  
  if (indexPath.row == 0) {
    
  }
  else if (indexPath.row == 1) {
    
  }
  else if (indexPath.row == 2) {
      UILabel *city = (UILabel *)[cell viewWithTag:301];
    city.text = [self.photo objectForKey:@"locName"];//@"San Francisco, CA";
  }
  else {
      NSUInteger *map = indexPath.row % 3;
      
      UILabel *name = (UILabel *)[cell viewWithTag:304];
      NSString *username = [self.usernames objectAtIndex:map];
      NSString *comment = [self.comments objectAtIndex:map];
      name.text = username;
      
      UIImageView *fbPic = (UIImageView *)[cell viewWithTag:305];
      fbPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", username]];
      
      UILabel *description = (UILabel *)[cell viewWithTag:306];
      description.text = comment;
      
  }
  
  return cell;
}

- (void)commentTouched
{
//    CommentsViewController *ppvc = [[CommentsViewController alloc] initWithPhoto:self.photo];
//    
//    [self.navigationController pushViewController:ppvc animated:YES];
    [self backButtonTouched];
}

- (void)heartTouched
{
    [Util likePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"error liking photo");
        } else {
            NSLog(@"liked photo successfully");
        }
    }];
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
