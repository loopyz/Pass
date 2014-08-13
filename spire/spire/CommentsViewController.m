//
//  CommentsViewController.m
//  spire
//
//  Created by Lucy Guo on 7/25/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "CommentsViewController.h"
#import "RDRStickyKeyboardView.h"

static NSString * const CellIdentifier = @"cell";

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate> {
  CGFloat screenWidth;
  CGFloat screenHeight;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RDRStickyKeyboardView *contentWrapper;

@end

@implementation CommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    //        [self setupTable];
    //        [self setupCommentBox];
    
    [self initNavBar];
  }
  return self;
}

- (void)initNavBar
{
  
  self.navigationController.navigationBar.topItem.title = @"Comments";
  self.navigationItem.title = @"Comments";
}

- (id)initWithPhoto:(SPPhoto *)photo
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    self.photo = photo;
    self.comments = [[NSMutableArray alloc] init];
    self.usernames = [[NSMutableArray alloc] init];
    //        [self setupTable];
    //        [self setupCommentBox];
  }
  return self;
}

#pragma mark - View lifecycle

- (PFQuery *) queryForComments
{
  PFQuery *query = [PFQuery queryWithClassName:kSPActivityClassKey];
  [query whereKey:@"photo" equalTo:self.photo];
  [query whereKey:@"type" equalTo:kSPActivityTypeComment];
  [query includeKey:@"fromUser"];
  [query orderByDescending:@"createdAt"];
  [query setCachePolicy:kPFCachePolicyNetworkOnly];
  [query setLimit:10];
  
  return query;
}

- (void) saveCommentToParse: (NSString *)commentText
{
  if (commentText.length != 0) {
      PFUser *toUser = [self.photo user];
    PFObject *comment = [PFObject objectWithClassName:kSPActivityClassKey];
    [comment setObject:commentText forKey:@"content"];
    [comment setObject:kSPActivityTypeComment forKey:@"type"];
    [comment setObject:toUser forKey:@"toUser"];
    [comment setObject:[PFUser currentUser] forKey:@"fromUser"];
    [comment setObject:self.photo forKey:@"photo"];
    [comment setObject:@1 forKey:@"unread"];
    
    // setting ACLs
    PFACL *ACL = [PFACL ACL];
    [ACL setWriteAccess:YES forUser:toUser];
    [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    comment.ACL = ACL;
    
    // todo -- update comment records in SPCACHE
    [self.comments addObject:comment];
      
      [self.usernames addObject:[[self.photo user] fbName]];
    [self.tableView reloadData];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (error){
        NSLog(@"some error");
      } else {
        NSLog(@"comment success");
        
      }
    }];
  }
}
- (void)loadView
{
  [super loadView];
  
  [self _setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  PFQuery *query = [self queryForComments];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      self.comments = [[NSMutableArray alloc] initWithArray:objects];
      [self.tableView reloadData];
    }
  }];
  
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  self.navigationItem.title = @"Comments";
}
#pragma mark - Private

- (void)_setupSubviews
{
  // Setup tableview
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                style:UITableViewStylePlain];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
  |UIViewAutoresizingFlexibleHeight;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:CellIdentifier];
  
  // Setup wrapper
  self.contentWrapper = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
  self.contentWrapper.frame = self.view.bounds;
  self.contentWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
  self.contentWrapper.inputView.delegate = self;
  self.contentWrapper.inputViewScrollView.delegate = self;
  [self.view addSubview:self.contentWrapper];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                          forIndexPath:indexPath];
  
  if (cell == nil && indexPath.row == 1) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
  }
  else if (cell == nil && indexPath.row != 1) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    // TODO : OVERLAPPING ISSUES HERE
  }
  
  if (indexPath.row == 0) {
    //setup avatar
    PFImageView *avatarView = [[PFImageView alloc] initWithFrame:CGRectMake(17,8,40,40)];
    avatarView.image = [UIImage imageNamed:@"lucyguo.png"];
    [cell addSubview:avatarView];
    UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
    
    //setup avatar name
    UILabel *avatarName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 50)];
    [avatarName setTextColor:descColor];
    [avatarName setBackgroundColor:[UIColor clearColor]];
    [avatarName setFont:[UIFont fontWithName:@"Avenir" size:16]];
    
    avatarName.text = @"lucyguo";
    avatarName.lineBreakMode = NSLineBreakByWordWrapping;
    avatarName.numberOfLines = 0;
    [cell addSubview:avatarName];
    
    // setup description
    UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 300, 75)];
    [description setTextColor:descriptionColor];
    [description setBackgroundColor:[UIColor clearColor]];
    [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [cell addSubview:description];
    
      description.text = [self.photo caption];
    
  }
  if (indexPath.row == 1) {
    UILabel *loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 20)];
    loadMoreLabel.text = @"Load more comments";
    loadMoreLabel.textAlignment = NSTextAlignmentCenter;
    loadMoreLabel.textColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
    [cell addSubview:loadMoreLabel];
  }
  else if (indexPath.row > 1){
    PFObject *comment = [self.comments objectAtIndex:(indexPath.row - 2)];
    // cell.text = [comment objectForKey:@"content"];
    
    UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 35)];
    
    
    [name setTextColor:nameColor];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"Avenir" size:15]];
    
    [cell addSubview:name];
    
    UIImageView *fbPic = [[UIImageView alloc] initWithFrame:CGRectMake(17, 8, 40, 40)];
    fbPic.frame = CGRectMake(17, 8, 40, 40);
    
    //makes it into circle
    float width = fbPic.bounds.size.width;
    fbPic.layer.cornerRadius = width/2;
    [cell addSubview:fbPic];
    // setup description
    UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 300, 75)];
    [description setTextColor:descriptionColor];
    [description setBackgroundColor:[UIColor clearColor]];
    [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [cell addSubview:description];
    
    NSString *username = @"testuser";
    name.text = username;
    
    fbPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", username]];
    
    fbPic.image = [UIImage imageNamed:@"tempavatar.png"];
 
    description.text = [comment objectForKey:@"content"];
    
  }
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1; //number of alphabet letters + recent
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // TODO: make it dynamic so that we add rows when people click "load more comments"
  NSInteger numComments = [self.comments count] + 2;
  return numComments;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // TODO : Calculate height based off of comment length
  return 60;
}

- (void)commentTextViewDidPressPostButton:(RDRKeyboardInputView *)commentView {
  NSLog(@"Post message %@", commentView.textView.text);
  [self saveCommentToParse:commentView.textView.text];
  commentView.textView.text = @"";
  self.contentWrapper.inputView.textView.text = @"";
  [self.contentWrapper hideKeyboard];
}


@end
