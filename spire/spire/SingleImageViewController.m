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

#import "UIImage+ImageEffects.h"
#import "ToolBarView.h"
#import "UIFont+SecretFont.h"
#import "CommentCell.h"
#import "UIView+GradientMask.h"

#import <QuartzCore/QuartzCore.h>

#define HEADER_HEIGHT 320.0f
#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define TOOLBAR_INIT_FRAME CGRectMake (0, 302, 320, 22)

const CGFloat kBarHeight = 50.0f;
const CGFloat kBackgroundParallexFactor = 0.5f;
const CGFloat kBlurFadeInFactor = 0.005f;
const CGFloat kTextFadeOutFactor = 0.05f;
const CGFloat kCommentCellHeight = 50.0f;

@interface SingleImageViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>


@end

@implementation SingleImageViewController {
  UIScrollView *_mainScrollView;
  UIScrollView *_backgroundScrollView;
  UIImageView *_blurImageView;
  ToolBarView *_toolBarView;
  UIView *_commentsViewContainer;
  UITableView *_commentsTableView;
  UIButton *_backButton;
  
  UIView *_fadeView;
  
  // TODO: Implement these
  UIGestureRecognizer *_leftSwipeGestureRecognizer;
  UIGestureRecognizer *_rightSwipeGestureRecognizer;
  
  NSMutableArray *comments;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//      self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
      [self.navigationController setNavigationBarHidden:YES];
        comments = [@[@"Oh my god! Me too!", @"I miss my baby", @"I really want to travel there one day that looks awesome", @"More comments", @"Go Toronto Blue Jays!", @"I rather use Twitter", @"CANT STOP WONT STOP", @"I don't have an iPhone", @"How are you using this then?"] mutableCopy];
        self.comments = comments;


      
    }
    return self;
}

- (NSString *)randomPersonAvatar
{
    NSArray* types = @[@"andrewhuang", @"charlotte", @"keithmiller", @"lucyguo", @"nivejayasekar", @"vivianma"];

    return types[arc4random() % [types count]];
}

- (id)initWithPhoto:(PFObject *)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
        self.photo = photo;
        comments = [@[@"Oh my god! Me too!", @"I miss my baby", @"I really want to travel there one day that looks awesome", @"More comments", @"Go Toronto Blue Jays!", @"I rather use Twitter", @"CANT STOP WONT STOP", @"I don't have an iPhone", @"How are you using this then?"] mutableCopy];
        self.comments = comments;
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
//  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//  backButton.frame = CGRectMake(15, 15, 31.5, 31.5);
//  [backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
//
//  UIImage *btnImage = [UIImage imageNamed:@"circlebackbutton.png"];
//  [backButton setImage:btnImage forState:UIControlStateNormal];
//  backButton.contentMode = UIViewContentModeScaleToFill;
//
//  [view addSubview:backButton];
//
//  UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//  commentButton.frame = CGRectMake(270, 15, 31.5, 31.5);
//  [commentButton addTarget:self action:@selector(commentTouched) forControlEvents:UIControlEventTouchUpInside];
//
//  btnImage = [UIImage imageNamed:@"circlecommentbutton.png"];
//  [commentButton setImage:btnImage forState:UIControlStateNormal];
//  commentButton.contentMode = UIViewContentModeScaleToFill;
//
//  [view addSubview:commentButton];
//
//  UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//  likeButton.frame = CGRectMake(230, 15, 31.5, 31.5);
//  [likeButton addTarget:self action:@selector(heartTouched) forControlEvents:UIControlEventTouchUpInside];
//
//  btnImage = [UIImage imageNamed:@"circlelikebutton.png"];
//  [likeButton setImage:btnImage forState:UIControlStateNormal];
//  likeButton.contentMode = UIViewContentModeScaleToFill;
//
//  [view addSubview:likeButton];
}

//- (NSString *)randomPersonAvatar
//{
//    NSArray* types = @[@"andrewhuang", @"charlotte", @"keithmiller", @"lucyguo", @"nivejayasekar", @"vivianma"];
//
//    return types[arc4random() % [types count]];
//}

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
  // [self.navigationController setNavigationBarHidden:YES];
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  self.navigationItem.title = @"Photo";
  self.navigationController.navigationItem.title = @"Photo";
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
    NSUInteger numComments = 5;
  NSUInteger count = numComments + extraRows;

  return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) return 320;
  if (indexPath.row == 1) return 58;
  if (indexPath.row == 2) return 60;
  else {
      NSString *text = [comments objectAtIndex:[indexPath row]];
      CGSize requiredSize;
      if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
          CGRect rect = [text boundingRectWithSize:(CGSize){225, MAXFLOAT}
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont secretFontLightWithSize:16.f]}
                                           context:nil];
          requiredSize = rect.size;
      } else {
          requiredSize = [text sizeWithFont:[UIFont secretFontLightWithSize:16.f] constrainedToSize:(CGSize){225, MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
      }
      return kCommentCellHeight + requiredSize.height;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

//for each header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // TODO: if this is clicked, then open person's profile
    SPPhoto *photo = self.photo;
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
    locationIconView.image = [UIImage imageNamed:@"locationicon.png"];
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



//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell;
  CommentCell *commentCell;
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
      commentCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
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
      commentCell.layer.shadowColor = [[UIColor whiteColor] CGColor];
      commentCell.layer.shadowOpacity = 1.0;
      commentCell.layer.shadowRadius = 0;
      commentCell.layer.shadowOffset = CGSizeMake(0.0, 1.0);

      if (!cell) {
          commentCell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
          commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
          commentCell.commentLabel.frame = (CGRect) {.origin = commentCell.commentLabel.frame.origin , .size = {CGRectGetMinX(commentCell.likeButton.frame) - CGRectGetMaxY(commentCell.iconView.frame) - kCommentPaddingFromLeft - kCommentPaddingFromRight,[self tableView:tableView heightForRowAtIndexPath:indexPath] - kCommentCellHeight + 20}};
          commentCell.commentLabel.text = comments[indexPath.row];
          commentCell.nameLabel.frame = (CGRect) {.origin = {CGRectGetMinX(commentCell.commentLabel.frame), CGRectGetMinY(commentCell.commentLabel.frame)}};
          commentCell.nameLabel.text = @"Vivian Ma";
          [commentCell.nameLabel sizeToFit];
          
          
          //      UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(17, 18, 40, 40)];
          //      avatar.image = [UIImage imageNamed:@"lucyguo.png"];
          //      [commentCell addSubview:avatar];
          
          // Don't judge my magic numbers or my crappy assets!!!
          commentCell.likeCountImageView.frame = CGRectMake(CGRectGetMaxX(commentCell.nameLabel.frame) + 7, CGRectGetMinY(commentCell.nameLabel.frame) + 3, 10, 10);
          commentCell.likeCountImageView.image = [UIImage imageNamed:@"like_greyIcon.png"];
          commentCell.likeCountLabel.frame = CGRectMake(CGRectGetMaxX(commentCell.likeCountImageView.frame) + 3, CGRectGetMinY(commentCell.nameLabel.frame), 0, CGRectGetHeight(commentCell.nameLabel.frame));
      }


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
    
    if (indexPath.row <= 2) return cell;
    else return commentCell;

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


//- (id)initWithPhoto:(SPPhoto *)photo
//{
//  self = [super initWithNibName:nil bundle:nil];
//  if (self) {
//    // Custom initialization
////    self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
//    self.photo = photo;
//    
//    
//  }
//  return self;
//}
//
//- (void)setupImage
//{
//  _mainScrollView = [[UIScrollView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
//  _mainScrollView.delegate = self;
//  _mainScrollView.bounces = YES;
//  _mainScrollView.alwaysBounceVertical = YES;
//  _mainScrollView.contentSize = CGSizeZero;
//  _mainScrollView.showsVerticalScrollIndicator = YES;
//  _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kBarHeight, 0, 0, 0);
//  self.view = _mainScrollView;
//  
//  _backgroundScrollView = [[UIScrollView alloc] initWithFrame:HEADER_INIT_FRAME];
//  _backgroundScrollView.scrollEnabled = NO;
//  _backgroundScrollView.contentSize = CGSizeMake(320, 1000);
//    
//    
//  // header
//
//  UIImageView *imageView = [[UIImageView alloc] initWithFrame:HEADER_INIT_FRAME];
//
//  imageView.image = [UIImage imageNamed:@"tempsingleimage.png"];
//  
//  PFImageView *imgView = [[PFImageView alloc] initWithFrame:HEADER_INIT_FRAME];
//  imgView.image = [UIImage imageNamed:@"tempsingleimage.png"];
//    imgView.file = [self.photo image];
//  [imgView loadInBackground];
//  [imageView addSubview:imgView];
//  
//  imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//  
//  imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  _fadeView = [[UIView alloc] initWithFrame:CGRectMake (0, 292, 320, 32)];
//  _fadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
//  _fadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  
//  _toolBarView = [[ToolBarView alloc] initWithFrame:TOOLBAR_INIT_FRAME ];
////  _toolBarView.autoresizingMask =   UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
//  
//  _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//  _backButton.frame = CGRectMake(20, 20, 31.5, 31.5);
//  [_backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
//  UIImage *btnImage = [UIImage imageNamed:@"circlebackbutton.png"];
//  [_backButton setImage:btnImage forState:UIControlStateNormal];
//  _backButton.contentMode = UIViewContentModeScaleToFill;
//  
//  
//  [_backgroundScrollView addSubview:imageView];
//  [_backgroundScrollView addSubview:_fadeView];
//  [_backgroundScrollView addSubview:_toolBarView];
//  // [_backgroundScrollView addSubview:_backButton];
//
//  
//  // Take a snapshot of the background scroll view and apply a blur to that image
//  // Then add the blurred image on top of the regular image and slowly fade it in
//  // in scrollViewDidScroll
//  UIGraphicsBeginImageContextWithOptions(_backgroundScrollView.bounds.size, _backgroundScrollView.opaque, 0.0);
//  [_backgroundScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
//  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
//  
//  _blurImageView = [[UIImageView alloc] initWithFrame:HEADER_INIT_FRAME];
//  _blurImageView.image = [img applyBlurWithRadius:12 tintColor:[UIColor colorWithWhite:0.8 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
//  _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  _blurImageView.alpha = 0;
//  _blurImageView.backgroundColor = [UIColor clearColor];
//  [_backgroundScrollView addSubview:_blurImageView];
//  
//  _commentsViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backgroundScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kBarHeight )];
//  [_commentsViewContainer addGradientMaskWithStartPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 0.03)];
//  _commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kBarHeight ) style:UITableViewStylePlain];
//  _commentsTableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
//  _commentsTableView.scrollEnabled = NO;
//  _commentsTableView.delegate = self;
//  _commentsTableView.dataSource = self;
//  _commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//  // _commentsTableView.separatorColor = [UIColor clearColor];
//  
//  [self.view addSubview:_backgroundScrollView];
//  [_commentsViewContainer addSubview:_commentsTableView];
//  [self.view addSubview:_commentsViewContainer];
//  
//  // Let's put in some fake data!
//  comments = [@[@"Oh my god! Me too!", @"I miss my baby", @"I really want to travel there one day that looks awesome", @"More comments", @"Go Toronto Blue Jays!", @"I rather use Twitter", @"CANT STOP WONT STOP", @"I don't have an iPhone", @"How are you using this then?"] mutableCopy];
//  [_toolBarView setNumberOfComments:[comments count]];
//  [self setupCaption];
//  
//}
//
//- (void)backButtonTouched
//{
//  [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (id)init {
//  self = [super init];
//  if (self) {
//  }
//  return self;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//  [self.navigationController setNavigationBarHidden:NO];
//  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//  self.navigationItem.title = @"Photo";
//  self.navigationController.navigationItem.title = @"Photo";
//    
//// Do any additional setup after loading the view.
//  if (self.photo) {
//    [self setupImage];
//    [self setupCaption];
////    self.comments = @[[self randomComment], [self randomComment], [self randomComment]];
////    self.usernames = @[[self randomPersonAvatar],[self randomPersonAvatar], [self randomPersonAvatar]];
//    [_commentsTableView reloadData];
//  }
//}
//
//- (void)addProfile
//{
//
//  self.fbProfilePic.backgroundColor = [UIColor blackColor];
//  self.fbProfilePic.frame = CGRectMake(17, 8, 40, 40);
//
//  //makes it into circle
//  float width = self.fbProfilePic.bounds.size.width;
//  self.fbProfilePic.layer.cornerRadius = width/2;
//  [self.captionView addSubview:self.fbProfilePic];
//
//}
//
//- (void)setupCaption
//{
//    SPUser *user = [self.photo user];
//  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 164)];
//  
//  self.captionView = view;
//  self.fbProfilePic = [[FBProfilePictureView alloc] init];
//  
//    self.fbProfilePic.profileID = [user fbId];
//
//  //setup name label
//  UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
//  UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 35)];
//  
//  
//  [name setTextColor:nameColor];
//  [name setBackgroundColor:[UIColor clearColor]];
//  [name setFont:[UIFont fontWithName:@"Avenir" size:15]];
//  
//    name.text = [user username];
//  [self.captionView addSubview:name];
//  [self addProfile];
//  
//  
//  // setup description
//  UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
//  
//  UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 75)];
//  [description setTextColor:descriptionColor];
//  [description setBackgroundColor:[UIColor clearColor]];
//  [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
//    description.text = [self.photo caption];
//  
//  [self.captionView addSubview:description];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  CGFloat delta = 0.0f;
//  CGRect rect = HEADER_INIT_FRAME;
//  CGRect toolbarRect = TOOLBAR_INIT_FRAME;
//  // Here is where I do the "Zooming" image and the quick fade out the text and toolbar
//  if (scrollView.contentOffset.y < 0.0f) {
//    delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y));
//    _backgroundScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0f, CGRectGetMinY(rect) - delta, CGRectGetWidth(rect) + delta, CGRectGetHeight(rect) + delta);
//    _toolBarView.alpha = 1.0f;
//    // _fadeView.alpha = MIN(1.0f, 1.0f - delta * kTextFadeOutFactor);
//    _toolBarView.frame = CGRectMake(CGRectGetMinX(toolbarRect) + delta / 2.0f, CGRectGetMinY(toolbarRect) + delta, CGRectGetWidth(toolbarRect), CGRectGetHeight(toolbarRect));
//    [_commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
//  } else {
//    delta = _mainScrollView.contentOffset.y;
//    _toolBarView.alpha = 1.0f;
//    _fadeView.alpha = 1.0f;
//    _blurImageView.alpha = MIN(1 , delta * kBlurFadeInFactor);
//    _toolBarView.frame = TOOLBAR_INIT_FRAME;
//    CGFloat backgroundScrollViewLimit = _backgroundScrollView.frame.size.height - kBarHeight;
//    // Here I check whether or not the user has scrolled passed the limit where I want to stick the header, if they have then I move the frame with the scroll view
//    // to give it the sticky header look
//    if (delta > backgroundScrollViewLimit) {
//      _backgroundScrollView.frame = (CGRect) {.origin = {0, delta - _backgroundScrollView.frame.size.height + kBarHeight}, .size = {self.view.frame.size.width, HEADER_HEIGHT}};
//      _commentsViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(_backgroundScrollView.frame) + CGRectGetHeight(_backgroundScrollView.frame)}, .size = _commentsViewContainer.frame.size };
//      _commentsTableView.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
//      CGFloat contentOffsetY = -backgroundScrollViewLimit * kBackgroundParallexFactor;
//      [_backgroundScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
//    }
//    else {
//      _backgroundScrollView.frame = rect;
//      _commentsViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _commentsViewContainer.frame.size };
//      [_commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
//      [_backgroundScrollView setContentOffset:CGPointMake(0, -delta * kBackgroundParallexFactor)animated:NO];
//    }
//  }
//}
//
//#pragma mark
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return [comments count];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 70;
//}
//
////for each header
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    // TODO: if this is clicked, then open person's profile
//    SPPhoto *photo = self.photo;
//    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
//    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
//    [view addTarget:self action:@selector(personTouched:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
//    
//    //setup avatar
//    SPUser *avatar = [photo user];
//    PFImageView *avatarView = [[PFImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
//    avatarView.image =[UIImage imageNamed:@"tempnewsavatar.png"];
//    avatarView.file = [avatar fbProfilePic];
//    [avatarView loadInBackground];
//    avatarView.layer.masksToBounds = YES;
//    float width = avatarView.bounds.size.width;
//    avatarView.layer.cornerRadius = width/2;
//    [view addSubview:avatarView];
//    
//    
//    
//    
//    //setup avatar name
//    UILabel *avatarName = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 300, 50)];
//    [avatarName setTextColor:descColor];
//    [avatarName setBackgroundColor:[UIColor clearColor]];
//    [avatarName setFont:[UIFont fontWithName:@"Avenir" size:16]];
//    
//    avatarName.text = [avatar username];
//    avatarName.lineBreakMode = NSLineBreakByWordWrapping;
//    avatarName.numberOfLines = 0;
//    [view addSubview:avatarName];
//    
//    // setup tags
//    UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(71, 21, 300, 50)];
//    [tags setTextColor:descColor];
//    [tags setBackgroundColor:[UIColor clearColor]];
//    [tags setFont:[UIFont fontWithName:@"Avenir" size:12]];
//    
//    tags.lineBreakMode = NSLineBreakByWordWrapping;
//    tags.numberOfLines = 0;
//    [view addSubview:tags];
//    
//    // setup location icon
//    UIImageView *locationIconView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 11/1.5f, 17/1.5f)];
//    // locationIconView.image = locationIcon;
//    locationIconView.tag = 101;
//    [view addSubview:locationIconView];
//    
//    tags.text = [photo locName];
//    
//    view.backgroundColor = [UIColor clearColor];
//    outerView.backgroundColor = [UIColor whiteColor];
//    outerView.alpha = .94f;
//    
//    view.tag = 800 + section;
//    [outerView addSubview:view];
//    
//    CALayer *bottomBorder = [CALayer layer];
//    
//    bottomBorder.frame = CGRectMake(0.0f, 70, self.tableView.frame.size.width, .6f);
//    
//    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
//                                                     alpha:1.0f].CGColor;
//    
//    [outerView.layer addSublayer:bottomBorder];
//    return outerView;
//}
//
//
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath.row == 0) return 58;
//  NSString *text = [comments objectAtIndex:[indexPath row]];
//  CGSize requiredSize;
//  if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//    CGRect rect = [text boundingRectWithSize:(CGSize){225, MAXFLOAT}
//                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                  attributes:@{NSFontAttributeName:[UIFont secretFontLightWithSize:16.f]}
//                                     context:nil];
//    requiredSize = rect.size;
//  } else {
//    requiredSize = [text sizeWithFont:[UIFont secretFontLightWithSize:16.f] constrainedToSize:(CGSize){225, MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
//  }
//  return kCommentCellHeight + requiredSize.height;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  UITableViewCell *cell;
//  CommentCell *commentCell;
//  if (indexPath.row == 0) {
//    cell = [tableView dequeueReusableCellWithIdentifier:@"Caption"];
//    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
//    cell.layer.shadowOpacity = 1.0;
//    cell.layer.shadowRadius = 0;
//    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//  }
//  else {
//    commentCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
//    commentCell.layer.shadowColor = [[UIColor whiteColor] CGColor];
//    commentCell.layer.shadowOpacity = 1.0;
//    commentCell.layer.shadowRadius = 0;
//    commentCell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//  }
//  if (cell == nil && indexPath.row == 0) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Caption"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
//    cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
//    cell.layer.shadowOpacity = 1.0;
//    cell.layer.shadowRadius = 0;
//    cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//    [cell addSubview:self.captionView];
//    self.captionView.tag = 301;
//  }
//  else if (cell == nil )
//    if (!cell) {
//      commentCell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
//      commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
//      commentCell.commentLabel.frame = (CGRect) {.origin = commentCell.commentLabel.frame.origin, .size = {CGRectGetMinX(commentCell.likeButton.frame) - CGRectGetMaxY(commentCell.iconView.frame) - kCommentPaddingFromLeft - kCommentPaddingFromRight,[self tableView:tableView heightForRowAtIndexPath:indexPath] - kCommentCellHeight}};
//      commentCell.commentLabel.text = comments[indexPath.row];
//      commentCell.timeLabel.frame = (CGRect) {.origin = {CGRectGetMinX(commentCell.commentLabel.frame), CGRectGetMaxY(commentCell.commentLabel.frame)}};
//      commentCell.timeLabel.text = @"1d ago";
//      [commentCell.timeLabel sizeToFit];
//      
//      
////      UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(17, 18, 40, 40)];
////      avatar.image = [UIImage imageNamed:@"lucyguo.png"];
////      [commentCell addSubview:avatar];
//      
//      // Don't judge my magic numbers or my crappy assets!!!
//      commentCell.likeCountImageView.frame = CGRectMake(CGRectGetMaxX(commentCell.timeLabel.frame) + 7, CGRectGetMinY(commentCell.timeLabel.frame) + 3, 10, 10);
//      commentCell.likeCountImageView.image = [UIImage imageNamed:@"like_greyIcon.png"];
//      commentCell.likeCountLabel.frame = CGRectMake(CGRectGetMaxX(commentCell.likeCountImageView.frame) + 3, CGRectGetMinY(commentCell.timeLabel.frame), 0, CGRectGetHeight(commentCell.timeLabel.frame));
//    }
//  if (indexPath.row == 0)
//    return cell;
//  else return commentCell;
//}
//
//
//- (void)viewDidAppear:(BOOL)animated {
//  _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _commentsTableView.contentSize.height + CGRectGetHeight(_backgroundScrollView.frame));
//    
//}
//
//- (void)viewDidLoad
//{
//  [super viewDidLoad];
//	// Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning
//{
//  [super didReceiveMemoryWarning];
//  // Dispose of any resources that can be recreated.
//}
//
//#pragma mark
//- (BOOL)prefersStatusBarHidden {
//  return YES;
//}
//
//@end
//
