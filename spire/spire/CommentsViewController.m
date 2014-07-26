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

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    [self _setupSubviews];
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
        cell.text = @"hello this is the original comment";
    }
    if (indexPath.row == 1) {
        cell.text = @"load more comments link here";
    }
    else {
        cell.text = @"regular comment";
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //number of alphabet letters + recent
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: make it dynamic so that we add rows when people click "load more comments"
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO : Calculate height based off of comment length
    return 60;
}



@end
