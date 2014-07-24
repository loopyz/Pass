//
//  ProfileViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "ProfileViewController.h"
#import "PetProfileViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController () {
  UIImage *locationIcon;
  UIImage *heartButtonIcon;
  UIImage *commentButtonIcon;
}

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.bgColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
    
    self.photos = [[NSMutableArray alloc] init];
    [self setupHeader];
    
    locationIcon = [UIImage imageNamed:@"locationicon.png"];
    heartButtonIcon = [UIImage imageNamed:@"heartbutton.png"];
    commentButtonIcon = [UIImage imageNamed:@"commentbutton.png"];
    
    self.tableView.separatorColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
  }
  return self;
}

- (void)setupHeader
{
    PFUser *currentUser = [PFUser currentUser];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 164)];
  view.backgroundColor = [UIColor whiteColor];
  self.profileSnippetView = view;
  self.fbProfilePic = [[FBProfilePictureView alloc] init];

      
    self.fbProfilePic.profileID = [currentUser objectForKey:@"fbId"];
    //setup name label
    UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(108, 10, 300, 50)];
      
      
    [name setTextColor:nameColor];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"Avenir" size:22]];
      
    name.text = [currentUser objectForKey:@"username"]; //@"loopyz";
    [self.profileSnippetView addSubview:name];
    [self addProfile];

  
  // setup description
  UIColor *descriptionColor = [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1.0f];
  
  UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(108, 38, 180, 50)];
  [description setTextColor:descriptionColor];
  [description setBackgroundColor:[UIColor clearColor]];
  [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    description.text = [currentUser objectForKey:@"description"];//@"I really like pizza. And travel.";
  
  [self.profileSnippetView addSubview:description];
  
  // setup website
  UIColor *websiteColor = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
  UILabel *website = [[UILabel alloc] initWithFrame:CGRectMake(108, 60, 150, 50)];
  [website setTextColor:websiteColor];
  [website setBackgroundColor:[UIColor clearColor]];
  [website setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    website.text = [currentUser objectForKey:@"website"]; //@"http://www.lucy.ws";
  
  [self.profileSnippetView addSubview:website];
  
  
  //setup score, offers, and pending label
  UIColor *tinyLabelColor = [UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1.0f];
  
  UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(40, 120, 150, 50)];
  [score setTextColor:tinyLabelColor];
  [score setBackgroundColor:[UIColor clearColor]];
  [score setFont:[UIFont fontWithName:@"Avenir" size:13]];
  score.text = @"Posts";
  
  UILabel *offers = [[UILabel alloc] initWithFrame:CGRectMake(140, 120, 150, 50)];
  [offers setTextColor:tinyLabelColor];
  [offers setBackgroundColor:[UIColor clearColor]];
  [offers setFont:[UIFont fontWithName:@"Avenir" size:13]];
  offers.text = @"Followers";
  
  UILabel *pending = [[UILabel alloc] initWithFrame:CGRectMake(240, 120, 150, 50)];
  [pending setTextColor:tinyLabelColor];
  [pending setBackgroundColor:[UIColor clearColor]];
  [pending setFont:[UIFont fontWithName:@"Avenir" size:13]];
  pending.text = @"Following";
  
  UILabel *numScore = [[UILabel alloc] initWithFrame:CGRectMake(35, 100, 40, 50)];
  [numScore setTextColor:[UIColor colorWithRed:68/255.0f green:203/255.0f blue:154/255.0f alpha:1.0f]];
  [numScore setBackgroundColor:[UIColor clearColor]];
  numScore.textAlignment = NSTextAlignmentCenter;
  [numScore setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numScore.text = @"123";
    self.numScoresLabel = numScore;
  
  UILabel *numoffers = [[UILabel alloc] initWithFrame:CGRectMake(155, 100, 25, 50)];
  [numoffers setTextColor:[UIColor colorWithRed:105/255.0f green:32/255.0f blue:213/255.0f alpha:1.0f]];
  [numoffers setBackgroundColor:[UIColor clearColor]];
  numoffers.textAlignment = NSTextAlignmentCenter;
  [numoffers setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numoffers.text = @"8";
  
  UILabel *numPending = [[UILabel alloc] initWithFrame:CGRectMake(253, 100, 32, 50)];
  [numPending setTextColor:[UIColor colorWithRed:206/255.0f green:34/255.0f blue:155/255.0f alpha:1.0f]];
  [numPending setBackgroundColor:[UIColor clearColor]];
  numPending.textAlignment = NSTextAlignmentCenter;
  [numPending setFont:[UIFont fontWithName:@"Avenir-Book" size:22]];
  numPending.text = @"2";
  
  [self.profileSnippetView addSubview:score];
  [self.profileSnippetView addSubview:offers];
  [self.profileSnippetView addSubview:pending];
  
  [self.profileSnippetView addSubview:numScore];
  [self.profileSnippetView addSubview:numoffers];
  [self.profileSnippetView addSubview:numPending];
  
  
  
  self.profileSnippetView.backgroundColor = [UIColor whiteColor];

}

- (void)addProfile
{
  
  self.fbProfilePic.backgroundColor = [UIColor blackColor];
  self.fbProfilePic.frame = CGRectMake(17, 23, 71, 71);
  
  //makes it into circle
  float width = self.fbProfilePic.bounds.size.width;
  self.fbProfilePic.layer.cornerRadius = width/2;
  [self.profileSnippetView addSubview:self.fbProfilePic];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
    [self.ptr viewDidScroll:scrollView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
  self.tableView.contentInset = inset;
    
    self.ptr = [[PullToRefresh alloc] initWithNumberOfDots:5];
    self.ptr.delegate = self;
    [self.view addSubview:self.ptr];
    
    [self Refresh];

  // Do any additional setup after loading the view.
}

- (void)refreshView
{
    PFQuery *countquery = [PFQuery queryWithClassName:@"Photo"];
    [countquery whereKey:@"user" equalTo:[PFUser currentUser]];
    [countquery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.numScoresLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"pet"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKeyExists:@"first"]; // neccessary?
    [query whereKey:@"first" equalTo:@1];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = [[NSMutableArray alloc] init];
            [self.photos addObjectsFromArray:objects];

            [self.tableView reloadData];
        }
    }];
}

- (void)Refresh {
    [self refreshView];
    
    // Perform here the required actions to refresh the data (call a JSON API for example).
    // Once the data has been updated, call the method isDoneRefreshing:
    [self.ptr isDoneRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
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
  return [self.photos count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) return 164;
  return 130;
}


//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell;
  if (indexPath.row != 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
    
    if (cell == nil) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Header"];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        cell.layer.shadowColor = [[UIColor whiteColor] CGColor];
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 0;
        cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor whiteColor];
            [cell addSubview:self.profileSnippetView];
        }
        else {
            cell.backgroundColor = self.bgColor;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 77, 77)];
            
            imgView.tag = 200;
            [cell addSubview:imgView];
            
            //setup Location label
            UIColor *descColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:1.0f];
            UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 200, 50)];
            [desc setTextColor:descColor];
            [desc setBackgroundColor:[UIColor clearColor]];
            [desc setFont:[UIFont fontWithName:@"Avenir" size:24]];
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            desc.numberOfLines = 0;
            desc.tag = 201;
            [cell addSubview:desc];
            
            // set up miles traveled
            UILabel *numMiles = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 200, 50)];
            [numMiles setTextColor:descColor];
            [numMiles setBackgroundColor:[UIColor clearColor]];
            [numMiles setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            numMiles.lineBreakMode = NSLineBreakByWordWrapping;
            numMiles.numberOfLines = 0;
            numMiles.tag = 202;
            [cell addSubview:numMiles];
            
            // setup miles label
            UILabel *milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 200, 50)];
            [milesLabel setTextColor:descColor];
            [milesLabel setBackgroundColor:[UIColor clearColor]];
            [milesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            
            milesLabel.text = @"miles traveled";
            milesLabel.lineBreakMode = NSLineBreakByWordWrapping;
            milesLabel.numberOfLines = 0;
            milesLabel.tag = 203;
            [cell addSubview:milesLabel];
            
            // set up miles traveled
            UILabel *numPasses = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 200, 50)];
            [numPasses setTextColor:descColor];
            [numPasses setBackgroundColor:[UIColor clearColor]];
            [numPasses setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            numPasses.lineBreakMode = NSLineBreakByWordWrapping;
            numPasses.numberOfLines = 0;
            numPasses.tag = 204;
            [cell addSubview:numPasses];
            
            // setup miles label
            UILabel *passesLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 60, 200, 50)];
            [passesLabel setTextColor:descColor];
            [passesLabel setBackgroundColor:[UIColor clearColor]];
            [passesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            
            passesLabel.text = @"passes";
            passesLabel.lineBreakMode = NSLineBreakByWordWrapping;
            passesLabel.numberOfLines = 0;
            passesLabel.tag = 205;
            [cell addSubview:passesLabel];
        }
    }
  
    if (indexPath.row != 0) {
        PFObject *pet = [[self.photos objectAtIndex:(indexPath.row-1)] objectForKey:@"pet"];
    
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:200];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[pet objectForKey:@"type"]]];
        UILabel *desc = (UILabel *)[cell viewWithTag:201];
        desc.text = [pet objectForKey:@"name"];//@"Pusheen";
    

        UILabel *numMiles = (UILabel *)[cell viewWithTag:202];
        
        numMiles.text = [NSString stringWithFormat:@"%d", [[pet objectForKey:@"miles"] intValue]];//@"2187";
    
        UILabel *numPasses = (UILabel *)[cell viewWithTag:204];
        numPasses.text = [[pet objectForKey:@"passes"] stringValue];//@"1322";
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
  if (indexPath.row == 0) {
    
  }//do not nothing
  else {
    NSLog(@"opening pet profile");
    PFObject *pet = [[self.photos objectAtIndex:(indexPath.row-1)] objectForKey:@"pet"];
    PetProfileViewController *ppvc = [[PetProfileViewController alloc] initWithNibName:nil bundle:nil];
      ppvc.petId = [pet objectId];
    [self.navigationController pushViewController:ppvc animated:YES];
  }
}


@end
