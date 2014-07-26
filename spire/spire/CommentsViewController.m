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
    }
    return self;
}

- (id)initWithPhoto:(PFObject *)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        self.photo = photo;
        self.comments = [[NSArray alloc] init];
        //        [self setupTable];
        //        [self setupCommentBox];
    }
    return self;
}

#pragma mark - View lifecycle

- (PFQuery *) queryForComments
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"photo" equalTo:self.photo];
    [query whereKey:@"type" equalTo:@"comment"];
    [query includeKey:@"fromUser"];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query setLimit:10];

    return query;
}

- (void) saveCommentToParse: (NSString *)commentText
{
    if (commentText.length != 0) {
        PFObject *comment = [PFObject objectWithClassName:@"Activity"];
        [comment setObject:commentText forKey:@"content"];
        [comment setObject:@"comment" forKey:@"type"];
        [comment setObject:[self.photo objectForKey:@"user"] forKey:@"toUser"];
        [comment setObject:[PFUser currentUser] forKey:@"fromUser"];
        [comment setObject:self.photo forKey:@"photo"];
        
        // setting ACLs
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        comment.ACL = ACL;
        
        // todo -- update comment records in SPCACHE
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
    PFQuery *query = [self queryForComments];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.comments = objects;
            [self.tableView reloadData];
        }
    }];
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
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0) {
        cell.text = [self.photo objectForKey:@"caption"]; // is this the caption?
    }
    if (indexPath.row == 1) {
        cell.text = @"Load more comments link here";
    }
    else if (indexPath.row > 1){
        PFObject *comment = [self.comments objectAtIndex:(indexPath.row - 2)];
        cell.text = [comment objectForKey:@"content"];
        
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
