//
//  CreatePetViewController.m
//  spire
//
//  Created by Niveditha Jayasekar on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//
#import <Parse/Parse.h>

#import "CreatePetViewController.h"
#import "HomeViewController.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface CreatePetViewController (Private)
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CreatePetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupScrollView];
        [self setupWelcome];
        [self setupAvatar];
        [self setupTable];
        [self setupSubmitButton];
    }
    return self;
}

- (void)setupSubmitButton
{
    // Do any additional setup after loading the view.
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    submitButton.frame = CGRectMake(0, 800, 320, 47.5);
    [submitButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"submitbutton.png"];
    [submitButton setImage:btnImage forState:UIControlStateNormal];
    submitButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.scrollView addSubview:submitButton];
}

- (IBAction)buttonTouched:(id)sender
{
    PFObject *pet = [[PFObject alloc] initWithClassName:@"Pet"];

    // TODO : select pet pic.
    for (NSInteger i = 0; i < [self.formTable numberOfRowsInSection:0]; ++i)
    {
        ELCTextFieldCell *cell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *text = [[cell rightTextField] text];
        [pet setObject:text forKey:self.fields[i]];
    }
    [pet setObject:[PFUser currentUser] forKey:@"owner"];
    [pet setObject:@0 forKey:@"miles"];
    [pet saveInBackground];
    
    PFObject *pass = [[PFObject alloc] initWithClassName:@"Pass"];
    [pass setObject:pet forKey:@"pet"];
    [pass setObject:[PFUser currentUser] forKey:@"user"];
    [pass setObject:@0 forKey:@"miles"];
    [pass saveInBackground];
    
    // open home view controller
    HomeViewController *svc = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)setupTable
{
    
    CGRect tableViewRect = CGRectMake(0, 330, SCREEN_WIDTH, 140);
    
    self.formTable = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.formTable.delegate = self;
    self.formTable.dataSource = self;
    self.formTable.backgroundColor = [UIColor clearColor];
    [self.formTable setRowHeight:50];
    [self.formTable setAllowsSelection:YES];
    [self.scrollView addSubview:self.formTable];
}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); //scroll view occupies full parent view!
    //specify CGRect bounds in place of self.view.bounds to make it as a portion of parent view!
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 870);   //scroll view size
    
    self.scrollView.showsVerticalScrollIndicator = NO;    // to hide scroll indicators!
    
    self.scrollView.showsHorizontalScrollIndicator = YES; //by default, it shows!
    
    self.scrollView.scrollEnabled = YES;                 //say "NO" to disable scroll
    
    
    [self.view addSubview:self.scrollView];               //adding to parent view!
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fields = [NSMutableArray arrayWithObjects:@"name", nil];
    self.labels = [NSArray arrayWithObjects:@"Name",
                   nil];
	
	self.placeholders = [NSArray arrayWithObjects:@"Enter Name",
                         nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    // checking
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAvatar
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 190.5)/2 + 30, 47, 127.5, 127.5)];
    imgView.image = [UIImage imageNamed:@"fox.png"];
    [self.scrollView addSubview:imgView];
}

- (void)setupWelcome
{
    //setup welcome message
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 190.5)/2 - 10, 200, 217.5, 70)];
    imgView.image = [UIImage imageNamed:@"nameyourpet.png"];
    [self.scrollView addSubview:imgView];
}

#pragma mark -
#pragma mark Table view data source

- (void)configureCell:(ELCTextFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	cell.leftLabel.text = [self.labels objectAtIndex:indexPath.row];
	cell.rightTextField.placeholder = [self.placeholders objectAtIndex:indexPath.row];
	cell.indexPath = indexPath;
	cell.delegate = self;
    //Disables UITableViewCell from accidentally becoming selected.
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
	
    //	if (indexPath.row == 3) {
    //        [cell.rightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    //	}
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = [self.fields count];
    self.formTable.frame = CGRectMake(0, 330, SCREEN_WIDTH, rowCount * 60);
    return rowCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark ELCTextFieldCellDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ELCTextFieldCell *textFieldCell = (ELCTextFieldCell*)textField.superview;
    if (![textFieldCell isKindOfClass:ELCTextFieldCell.class]) {
        return;
    }
    //It's a better method to get the indexPath like this, in case you are rearranging / removing / adding rows,
    //the set indexPath wouldn't change
    NSIndexPath *indexPath = [self.formTable indexPathForCell:textFieldCell];
	if(indexPath != nil && indexPath.row < [labels count]-1) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		[[(ELCTextFieldCell*)[self.formTable cellForRowAtIndexPath:path] rightTextField] becomeFirstResponder];
		[self.formTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	else {
		[[(ELCTextFieldCell*)[self.formTable cellForRowAtIndexPath:indexPath] rightTextField] resignFirstResponder];
	}
}

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)indexPath string:(NSString *)string {
    
	NSLog(@"See input: %@ from section: %d row: %d, should update models appropriately", string, indexPath.section, indexPath.row);
}

@end