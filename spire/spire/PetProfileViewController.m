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
      [self setupPictureCollection];
      [self setupPetSnippet];
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupPetSnippet];
    [self setupPictureCollection];
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
    return 15;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell;
  if (indexPath.row != 0) {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
  }
  else {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
  }
  if (indexPath.row == 0) {
    [cell addSubview:self.header];
  }
  else {
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pusheen.png"]];
    cell.backgroundView.backgroundColor = [UIColor blackColor];
  }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
    return CGSizeMake (SCREEN_WIDTH, 164);
  }
    return CGSizeMake(105, 105);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%d", indexPath.row);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) return NO;
  return YES;
}

- (void) setupPetSnippet
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 115)];
    //setup name label
    UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(98, 10, 300, 50)];
    [name setTextColor:nameColor];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"Avenir" size:22]];
    name.text = @"FoxyFace";
    
    UIImageView *petPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pusheen.png"]];
    petPic.frame = CGRectMake(17, 23, 93, 93);
    
    [view addSubview:name];
    [view addSubview:petPic];
    
    view.backgroundColor = [UIColor whiteColor];
  
    UIImageView *bottomBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottombar.png"]];
    bottomBar.frame = CGRectMake(0, 164-39.5, SCREEN_WIDTH, 41.5);
    [view addSubview: bottomBar];
  
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

    [view addSubview:self.mapButton];
  
    self.personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.personButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    self.personButton.frame = CGRectMake(255, 130, 20.53, 28);
    [self.personButton addTarget:self action:@selector(mapButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    btnImage = [UIImage imageNamed:@"personbutton.png"];
    [self.personButton setImage:btnImage forState:UIControlStateNormal];
    self.personButton.contentMode = UIViewContentModeScaleToFill;
    
    [view addSubview:self.personButton];

    self.header = view;
}

- (void)photoButtonTouched
{
  // TODO: idk
}

- (void)personButtonTouched
{
  // TODO : Bring up people that held the pet

}

- (void)mapButtonTouched
{
  // TODO: BRING UP GOOGLE MAPS
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
