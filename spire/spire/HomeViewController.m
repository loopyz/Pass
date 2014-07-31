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
#import "SPNotificationsViewController.h"
#import "ProfileViewController.h"
#import "PetProfileViewController.h"
#import "PetPlacementViewController.h"
#import "SettingsViewController.h"

#import <Parse/Parse.h>

@interface HomeViewController () {
  PetPlacementViewController *placevc;
}

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
      self.delegate = (id<UITabBarControllerDelegate>)self;
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
    SettingsViewController *ppvc = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:ppvc animated:YES];
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
        pet[@"currentUser"] = [PFUser currentUser];
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
    [self.navigationController setNavigationBarHidden:YES];
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
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    NewsFeedViewController *nvc = [[NewsFeedViewController alloc]initWithNibName:nil bundle:nil];
    nvc.tabBarItem.image = [UIImage imageNamed:@"hometabsmall.png"];
    
    FindPetViewController *evc = [[FindPetViewController alloc] initWithNibName:nil bundle:nil];
    evc.tabBarItem.image = [UIImage imageNamed:@"searchtabsmall.png"];
    
    placevc = [[PetPlacementViewController alloc] initWithNibName:nil bundle:nil];
    placevc.tabBarItem.image = [UIImage imageNamed:@"pettabsmall.png"];
    
    SPNotificationsViewController *ffvc = [[SPNotificationsViewController alloc] initWithNibName:nil bundle:nil];
    ffvc.tabBarItem.image = [UIImage imageNamed:@"newstabsmall.png"];
    
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:[PFUser currentUser]];
//    PetProfileViewController *pvc = [[PetProfileViewController alloc] initWithNibName:nil bundle:nil];
    pvc.tabBarItem.image = [UIImage imageNamed:@"profiletabsmall.png"];
    
    // show number of notifications here
    PFQuery *unreadNotifcationsQuery = [Util queryForNotifications:YES];
    [unreadNotifcationsQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        ffvc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", number];
    }];
    
    [placevc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"pettab-highlighted.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"pettabsmall.png"]];
    
    
    self.viewControllers=[NSArray arrayWithObjects:[[UINavigationController alloc] initWithRootViewController:nvc], [[UINavigationController alloc] initWithRootViewController:evc], [[UINavigationController alloc] initWithRootViewController:placevc], [[UINavigationController alloc] initWithRootViewController:ffvc], [[UINavigationController alloc] initWithRootViewController:pvc], nil];
}

- (void)assignTabColors
{
//    switch (self.selectedIndex) {
//        case 0: {
//            UIColor * color = [UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f];
//            self.view.tintColor = color;
//            
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    UIColor *backgroundColor = [UIColor colorWithRed:255/255.0f green:254/255.0f blue:252/255.0f alpha:1.0f];
    
    // set the bar background color
    [[UITabBar appearance] setBackgroundImage:[self imageFromColor:backgroundColor forSize:CGSizeMake(320, 49) withCornerRadius:0]];
    
    // set the text color for selected state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    // set the text color for unselected state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    // set the selected icon color
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f]];
    // remove the shadow
    [[UITabBar appearance] setShadowImage:nil];
    
    // Set the dark color to selected tab (the dimmed background)
    [[UITabBar appearance] setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f] forSize:CGSizeMake(64, 49) withCornerRadius:0]];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // [self assignTabColors];
  // reset camera if index is 2
  if (tabBarController.selectedIndex == 2) {
    placevc = [[PetPlacementViewController alloc] initWithNibName:nil bundle:nil];
  }
  
    [viewController viewWillAppear:YES];
//    if ([])
//    [viewController Refresh];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        
        UINavigationController *selectedNav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        UIViewController *currentVC = selectedNav.visibleViewController;
        if([currentVC isMemberOfClass:NSClassFromString(@"HomeViewController")])
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
        }
    }
    return YES;
    
//    static UIViewController *previousController = nil;
//    if (previousController == viewController) {
//        // the same tab was tapped a second time
//        UITableViewController *tableViewController = (UITableViewController *)viewController;
//        [tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
//                                                                                 inSection:0]
//                                             atScrollPosition:UITableViewScrollPositionTop
//                                                     animated:YES];
//        
//    }
//    previousController = viewController;
//    return YES;
}



- (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}


@end

