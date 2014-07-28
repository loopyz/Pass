//
//  FindPetViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "FindPetViewController.h"

@interface FindPetViewController ()

@property (strong, nonatomic) NSArray *headerBig;
@property (strong, nonatomic) NSArray *headerDetail;

@end

@implementation FindPetViewController

- (void)findNearbyPets
{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error) {
            // TODO: handle when location service is disabled? For now just use fake coordinates.
            geoPoint = [PFGeoPoint geoPointWithLatitude:3.14 longitude:2.71];
        }

        self.pets = [[NSMutableArray alloc] initWithArray:@[@[], @[], @[]]];
        
        // Max distance in miles from current location (500 ft, 1 mi, 5 mi).
        double maxDistances[] = {0.0947, 1.0, 5.0};
        
        __block int callbacksReceived = 0;
        
        for (int i = 0; i < 3; i++) {
            double maxDistance = maxDistances[i];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
            [query whereKey:@"currentUser" equalTo:[NSNull null]];
            [query whereKey:@"geoPoint" nearGeoPoint:geoPoint withinMiles:maxDistance];
            //[query whereKey:@"owner" notEqualTo:[PFUser currentUser]];
            query.limit = 15;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *pets, NSError *error) {
                if (pets != nil) {
                    [self.pets replaceObjectAtIndex:i withObject:pets];
                }
                callbacksReceived++;
                if (callbacksReceived == 3) {
                    
                    NSArray *petIds0 = [self.pets[0] valueForKey:@"objectId"];
                    NSArray *petIds1 = [self.pets[1] valueForKey:@"objectId"];
                    
                    // Filter out pets in closer sections from sections 2 and 3.
                    self.pets[2] = [self.pets[2] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PFObject *evaluatedObject, NSDictionary *bindings) {
                        NSLog(@"%@", [evaluatedObject objectId]);
                        return [petIds1 indexOfObject:[evaluatedObject objectId]] == NSNotFound;
                    }]];
                    self.pets[1] = [self.pets[1] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PFObject *evaluatedObject, NSDictionary *bindings) {
                        return [petIds0 indexOfObject:[evaluatedObject objectId]] == NSNotFound;
                    }]];
                    [self.tableView reloadData];
                }
            }];
        }
    }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    // TODO: checks if user has pet
    self.userHasPet = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIColor *color = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
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
    
//    self.ptr = [[PullToRefresh alloc] initWithNumberOfDots:5];
//    self.ptr.delegate = self;
//    [self.view addSubview:self.ptr];
    
    //pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    
    [self Refresh];
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
  return ([self.pets[section] count] + 2) / 3;
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
  
    // Check for last row for spacing.
    BOOL lastRow = (currentRow == numberOfRowsInSection - 1);
    int numberOfPetsInRow = 3;
    if (lastRow) {
        numberOfPetsInRow = [self.pets[indexPath.section] count] % 3;
        if (numberOfPetsInRow == 0) {
            numberOfPetsInRow = 3;
        }
    }

    // TODO: use correct values in an array
    for (int x = 0; x < numberOfPetsInRow; x++) {
        NSUInteger section = indexPath.section;
        NSUInteger index = currentRow * 3 + x;

        if (section >= [self.pets count] || index >= [self.pets[section] count]) {
            NSLog(@"Section or index out of bounds :(");
            return;
        }

        PFObject *pet = self.pets[section][index];
        NSString *petType = [pet objectForKey:@"type"];
        NSString *petLoc = [pet objectForKey:@"locName"];
        UIImage *petImage = [UIImage imageNamed:[petType stringByAppendingString:@".png"]];

        // If nearby, and user does not have pet, add pet as button.
        if (indexPath.section == 0 && !self.userHasPet) {
            UIButton *petButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + 100 * x, 20, 73.5, 73.5)];
            [petButton setImage:petImage forState:UIControlStateNormal];
            petButton.contentMode = UIViewContentModeScaleAspectFill;
            // Hack: Store pet objectId as hidden label so we can retrieve it on button press.
            petButton.titleLabel.text = [pet objectId];
            petButton.titleLabel.hidden = YES;
            [petButton addTarget:self action:@selector(petTouched:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:petButton];
        } else {
            // Otherwise, use normal view.
            UIImageView *petView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 100 * x, 20, 73.5, 73.5)];
            petView.image = petImage;
            [view addSubview:petView];
        } 

        CGFloat locationY = lastRow ? 45 : 55;
        UILabel *petLocation = [[UILabel alloc] initWithFrame:CGRectMake(7 + (100 * x), locationY, 100, 120)];
        petLocation.textAlignment = NSTextAlignmentCenter;
        petLocation.text = petLoc;
        petLocation.numberOfLines = 0;
        petLocation.lineBreakMode = NSLineBreakByWordWrapping;
        petLocation.textColor = descColor;
        petLocation.font = [UIFont fontWithName:@"Avenir" size:11.0f];
        
        [view addSubview:petLocation];
    }
}

- (void)petTouched:(id) sender
{
    UIButton *clicked = (UIButton *) sender;
    self.selectedPetId = clicked.titleLabel.text;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement" message: @"Are you sure you want to collect this pet?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
      NSLog(@"user pressed cancel");
      self.selectedPetId = nil;
  } else {
      NSLog(@"user pressed OK: %@", self.selectedPetId);

      // Pick up pet!
      PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
      [query whereKey:@"objectId" equalTo:self.selectedPetId];
      [query getFirstObjectInBackgroundWithBlock:^(PFObject *pet, NSError *error) {
          [pet setObject:[PFUser currentUser] forKey:@"currentUser"];
          [pet saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              [self Refresh];
          }];
          self.selectedPetId = nil;
      }];
  }
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  UIView *tempView;
  //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];

  //}

  cell.backgroundColor = [UIColor clearColor];

  [self setupCollection:indexPath withView:tempView];
  [cell addSubview:tempView];
  
  
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
    // [self.ptr viewDidScroll:scrollView];
}

- (void)Refresh {
    // Perform here the required actions to refresh the data (call a JSON API for example).
    // Once the data has been updated, call the method isDoneRefreshing:
    PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
    [query whereKey:@"currentUser" equalTo:[PFUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.userHasPet = number > 0;
    }];
    [self findNearbyPets];
    // [self.ptr isDoneRefreshing];
    [self.refreshControl endRefreshing];
}


@end
