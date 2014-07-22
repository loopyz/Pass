//  HomeViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

#import "HomeViewController.h"
#import "NewsFeedViewController.h"
#import "FindPetViewController.h"
#import "FriendsFeedViewController.h"
#import "ProfileViewController.h"
#import "PetProfileViewController.h"
#import "PetPlacementViewController.h"

#import <Parse/Parse.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.bgColor = [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
        [self modifyBackground];
        [self initNavBar];
        [self setupTabBars];
        
    
    }
    return self;
}

- (void)launchAddGameView
{
    // do nothing
}

- (void)initNavBar
{
    // Background image for navbar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbg.png"]
                                       forBarMetrics: UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *lbb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchicon.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(launchAddGameView)];
    
    lbb.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = lbb;
    
    // Logo in the center of navigation bar
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 37.5)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo.png"]];
    titleImageView.frame = CGRectMake(0, 0, titleImageView.frame.size.width/2, titleImageView.frame.size.height/2);
    [logoView addSubview:titleImageView];
    self.navigationItem.titleView = logoView;
    
    
    // Right bar button item to launch the categories selection screen.
    UIBarButtonItem *rbb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsicon.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(settingsTouched)];
    
    rbb.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rbb;
  
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  
}

- (void)settingsTouched
{
    //blah
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation addUniqueObject:@"PetsNearby" forKey:@"channels"];
//    [currentInstallation saveInBackground];
    // Uncomment to add a bunch of pets!
    /*for (int i = 0; i < 10; i++) {
        PFObject *pet = [PFObject objectWithClassName:@"Pet"];
        pet[@"currentUserId"] = [Util currentUserId];
        pet[@"owner"] = [PFUser currentUser];
        pet[@"name"] = [NSString stringWithFormat:@"Pet%d", i];
        pet[@"miles"] = @0;
        pet[@"passes"] = @0;
        pet[@"type"] = @"pandacat";
        [pet saveInBackground];
    }*/
    
    // Do any additional setup after loading the view.
//    if (![[PFUser currentUser] objectForKey:@"fbProfilePic"]) {
//        
//        NSString *url = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [[PFUser currentUser] objectForKey:@"fbId"]];
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        
//        PFFile *image = [PFFile fileWithName:@"profile.png" data:imageData];
//        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                [[PFUser currentUser] setObject:image forKey:@"fbProfilePic"];
//                [[PFUser currentUser] saveInBackground];
//            } else {
//                NSLog(@"parse error --saving profile image%@", error);
//            }
//        }];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self assignTabColors];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modifyBackground
{
    self.view.backgroundColor = self.bgColor;
}

#pragma mark - UITabBarController Methods

- (void)setupTabBars
{
    NewsFeedViewController *nvc = [[NewsFeedViewController alloc]initWithNibName:nil bundle:nil];
    nvc.tabBarItem.image = [UIImage imageNamed:@"hometab.png"];
    
    FindPetViewController *evc = [[FindPetViewController alloc] initWithNibName:nil bundle:nil];
    evc.tabBarItem.image = [UIImage imageNamed:@"searchtab.png"];
    
    PetPlacementViewController *placevc = [[PetPlacementViewController alloc] initWithNibName:nil bundle:nil];
    placevc.tabBarItem.image = [UIImage imageNamed:@"pettab.png"];
    
    FriendsFeedViewController *ffvc = [[FriendsFeedViewController alloc] initWithNibName:nil bundle:nil];
    ffvc.tabBarItem.image = [UIImage imageNamed:@"newstab.png"];
    
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
//    PetProfileViewController *pvc = [[PetProfileViewController alloc] initWithNibName:nil bundle:nil];
    pvc.tabBarItem.image = [UIImage imageNamed:@"profiletab.png"];
    
    [placevc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"pettab-highlighted.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"pettab.png"]];
    
    self.viewControllers=[NSArray arrayWithObjects:nvc, evc, placevc, ffvc, pvc, nil];
}

- (void)assignTabColors
{
    switch (self.selectedIndex) {
        case 0: {
            UIColor * color = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
            self.view.tintColor = color;
            break;
        }
            
        default:
            break;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self assignTabColors];
    [viewController viewWillAppear:YES];
//    if ([])
//    [viewController Refresh];
}

@end

