//
//  PetProfileViewController.m
//  spire
//
//  Created by Niveditha Jayasekar on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

#import "PetProfileViewController.h"
#import "SingleImageViewController.h"
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface PetProfileViewController ()

@end

@implementation PetProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.photos = [[NSMutableArray alloc] init];
//      [self setupPictureCollection];
//      [self setupPetSnippet];
      [self setupPictureCollection];
        // default button enabled settings
        self.mapTouched = false;
        self.photoTouched = true;
        self.personTouched = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void) setupPictureCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 750) collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // TODO with real data

// photoTouched
        return [self.photos count] + 1;

}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell;
  if (indexPath.row != 0) {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
  }
  else {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    [cell.contentView addSubview:self.mapButton];
  }
  
//  dispatch_async(dispatch_get_main_queue(), ^{
//    
//    //  ********* Changed *******
//    
//    for (UIView *v in [cell.contentView subviews])
//      [v removeFromSuperview];
//    
//    // ********** Changed **********
//    if (indexPath.row == 0) {
//      // [cell addSubview:self.header];
//      cell.backgroundView = self.header;
//    }
//    else {
//      PFFile *image = [[self.photos objectAtIndex:(indexPath.row - 1)] objectForKey:@"image"];
//      PFImageView *photo = [[PFImageView alloc] init];
//      photo.image = [UIImage imageNamed:@"tempsingleimage.png"];
//      photo.file = image;
//      [photo loadInBackground];
//      cell.backgroundView = photo;
//      // [cell addSubview:photo];
//    }
//  });
  
 // photoTouched
        if (indexPath.row == 0) {
            cell.backgroundView = self.header;
        }
        else {
            PFFile *image = [[self.photos objectAtIndex:(indexPath.row - 1)] objectForKey:@"image"];
            PFImageView *photo = [[PFImageView alloc] init];
            photo.image = [UIImage imageNamed:@"tempsingleimage.png"];
            photo.file = image;
            [photo loadInBackground];
            cell.backgroundView = photo;
            cell.backgroundView.backgroundColor = [UIColor blackColor];
        }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
// photoTouched
        if (indexPath.row == 0) {
            return CGSizeMake (SCREEN_WIDTH, 164);
        }
        return CGSizeMake(105, 105);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%d", indexPath.row);
    if (indexPath.row != 0) {
        PFObject *photo = self.photos[indexPath.row - 1];
        SingleImageViewController *ppvc = [[SingleImageViewController alloc] initWithPhoto:photo];

  [self presentViewController:ppvc animated:YES completion:nil];
  //[self.navigationController pushViewController:ppvc animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) return NO;
  return YES;
}

- (void) setupPetSnippet:(PFObject *)pet
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 115)];
    //setup name label
    UIColor *nameColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 300, 50)];
    [name setTextColor:nameColor];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"Avenir" size:25]];
    name.text = [pet objectForKey:@"name"];//@"Foxy";
  
    //sets up on nav bar also
    self.navigationController.navigationBar.topItem.title = name.text;
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  // [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    NSString *petFName = [NSString stringWithFormat:@"%@.png", [pet objectForKey:@"type"]];
    UIImageView *petPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:petFName]]; // todo
    petPic.frame = CGRectMake(10, 10, 100, 100);
    
    [view addSubview:name];
    [view addSubview:petPic];
    
    view.backgroundColor = [UIColor whiteColor];
  
    UIImageView *bottomBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottombar.png"]];
    bottomBar.frame = CGRectMake(0, 164-39.5, SCREEN_WIDTH, 41.5);
    [view addSubview: bottomBar];
  
  // set up miles traveled
  UILabel *numMiles = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 200, 50)];
  [numMiles setTextColor:nameColor];
  [numMiles setBackgroundColor:[UIColor clearColor]];
  [numMiles setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
  
    numMiles.text = [[pet objectForKey:@"miles"] stringValue];//@"2187";
  numMiles.lineBreakMode = NSLineBreakByWordWrapping;
  numMiles.numberOfLines = 0;
  [view addSubview:numMiles];
  
  // setup miles label
  UILabel *milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 200, 50)];
  [milesLabel setTextColor:nameColor];
  [milesLabel setBackgroundColor:[UIColor clearColor]];
  [milesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
  
  milesLabel.text = @"miles traveled";
  milesLabel.lineBreakMode = NSLineBreakByWordWrapping;
  milesLabel.numberOfLines = 0;
  [view addSubview:milesLabel];
  
  // set up miles traveled
  UILabel *numPasses = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 200, 50)];
  [numPasses setTextColor:nameColor];
  [numPasses setBackgroundColor:[UIColor clearColor]];
  [numPasses setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
  
    numPasses.text = [[pet objectForKey:@"passes"] stringValue];//@"1322";
  numPasses.lineBreakMode = NSLineBreakByWordWrapping;
  numPasses.numberOfLines = 0;
  [view addSubview:numPasses];
  
  // setup miles label
  UILabel *passesLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 60, 200, 50)];
  [passesLabel setTextColor:nameColor];
  [passesLabel setBackgroundColor:[UIColor clearColor]];
  [passesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
  
  passesLabel.text = @"passes";
  passesLabel.lineBreakMode = NSLineBreakByWordWrapping;
  passesLabel.numberOfLines = 0;
  [view addSubview:passesLabel];
  
  // setup original owner
  UILabel *originalOwnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 79, 200, 50)];
  [originalOwnerLabel setTextColor:nameColor];
  [originalOwnerLabel setBackgroundColor:[UIColor clearColor]];
  [originalOwnerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
  
  originalOwnerLabel.text = @"Original Owner:";
  originalOwnerLabel.lineBreakMode = NSLineBreakByWordWrapping;
  originalOwnerLabel.numberOfLines = 0;
  [view addSubview:originalOwnerLabel];
  
  
  UIColor *ownerColor = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
  UILabel *ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(204, 79, 150, 50)];
  [ownerLabel setTextColor:ownerColor];
  [ownerLabel setBackgroundColor:[UIColor clearColor]];
  [ownerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    ownerLabel.text = [[pet objectForKey:@"owner"] objectForKey:@"username"];//@"poopypants";
  
  [view addSubview:ownerLabel];
  
  // setup buttons
  self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.photoButton setTitle:@"Show View" forState:UIControlStateNormal];

  self.photoButton.frame = CGRectMake(40, 130, 28, 28);
  [self.photoButton addTarget:self action:@selector(photoButtonTouched) forControlEvents:UIControlEventTouchUpInside];

  UIImage *btnImage = [UIImage imageNamed:@"photobutton-pressed.png"];
  [self.photoButton setImage:btnImage forState:UIControlStateNormal];
  self.photoButton.contentMode = UIViewContentModeScaleToFill;

  [view addSubview:self.photoButton];

  self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.mapButton setTitle:@"Show View" forState:UIControlStateNormal];

  self.mapButton.frame = CGRectMake(145, 130, 28, 28);
  [self.mapButton addTarget:self action:@selector(mapButtonTouched) forControlEvents:UIControlEventTouchUpInside];

  btnImage = [UIImage imageNamed:@"mapbutton.png"];
  [self.mapButton setImage:btnImage forState:UIControlStateNormal];
  self.mapButton.contentMode = UIViewContentModeScaleToFill;

  //[view addSubview:self.mapButton];

  self.personButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.personButton setTitle:@"Show View" forState:UIControlStateNormal];
  
  self.personButton.frame = CGRectMake(255, 130, 20.53, 28);
  [self.personButton addTarget:self action:@selector(personButtonTouched) forControlEvents:UIControlEventTouchUpInside];
  
  btnImage = [UIImage imageNamed:@"personbutton.png"];
  [self.personButton setImage:btnImage forState:UIControlStateNormal];
  self.personButton.contentMode = UIViewContentModeScaleToFill;
  
  [view addSubview:self.personButton];

  self.header = view;
}

- (void)photoButtonTouched
{
  // TODO: idk
    NSLog(@"photo clicked");
    if (self.mapTouched) {
        // styling to turn off map
    }
    if (self.personTouched) {
        // styling to turn off person
    }
    // styling to turn on photo
    
    // toggling values and reloading collections view
    self.photoTouched = true;
    self.mapTouched = false;
    self.personTouched = false;
    [self.collectionView reloadData];
}

- (void)personButtonTouched
{
  // TODO : Bring up people that held the pet
    NSLog(@"person clicked");
    if (self.mapTouched) {
        // styling to turn off map
    }
    if (self.photoTouched) {
        // styling to turn off photo
    }
    // styling to turn on person
    
    // toggling values and reloading collections view
    self.photoTouched = false;
    self.mapTouched = false;
    self.personTouched = true;
    [self.collectionView reloadData];

}

- (void)mapButtonTouched
{
  // TODO: BRING UP GOOGLE MAPS
    NSLog(@"map clicked");
    if (self.photoTouched) {
        // styling to turn off photo
    }
    if (self.personTouched) {
        // styling to turn off person
    }
    // styling to turn on map
    
    // toggling values and reloading collections view
    self.photoTouched = false;
    self.mapTouched = true;
    self.personTouched = false;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:NO];
  // Do any additional setup after loading the view.
    if (self.petId) {
        PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
        [query includeKey:@"owner"];
        [query getObjectInBackgroundWithId:self.petId block:^(PFObject *object, NSError *error) {
            PFQuery *photosquery = [PFQuery queryWithClassName:@"Photo"];
            [photosquery includeKey:@"user"];
            [photosquery whereKey:@"pet" equalTo:object];
            [photosquery orderByDescending:@"createdAt"];
            
            [photosquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                self.photos = [[NSMutableArray alloc] init];
                [self.photos addObjectsFromArray:objects];
              
                [self.collectionView reloadData];
            }];
            [self setupPetSnippet:object];
        }];
        
        
        
        
    } else {
        NSLog(@"error. can't call pet profile ctrl without petId.");
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
  return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
