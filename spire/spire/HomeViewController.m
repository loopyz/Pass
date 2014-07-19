//
//  HomeViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsFeedViewController.h"
#import "FindPetViewController.h"
#import "CameraViewController.h"
#import "FriendsFeedViewController.h"
#import "ProfileViewController.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

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
    
}

- (void)settingsTouched
{
    //blah
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (![[PFUser currentUser] objectForKey:@"type"]) {
//        [[PFUser currentUser] setObject:@"user" forKey:@"type"];
//        [[PFUser currentUser] saveInBackground];
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
    evc.tabBarItem.image = [UIImage imageNamed:@"search.png"];
    
    CameraViewController *nfvc = [[CameraViewController alloc] initWithNibName:nil bundle:nil];
    nfvc.tabBarItem.image = [UIImage imageNamed:@"pet.png"];
    
    FriendsFeedViewController *ffvc = [[FriendsFeedViewController alloc] initWithNibName:nil bundle:nil];
    ffvc.tabBarItem.image = [UIImage imageNamed:@"newstab.png"];
    
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    pvc.tabBarItem.image = [UIImage imageNamed:@"profiletab.png"];
    
    self.viewControllers=[NSArray arrayWithObjects:nvc, evc, nfvc, ffvc, pvc, nil];
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
}

@end

