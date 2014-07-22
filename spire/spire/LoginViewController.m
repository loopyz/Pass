//
//  LoginViewController.m
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//
#import <Parse/Parse.h>

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "RegisterInformationViewController.h"

#define FORCE_REGISTER true

@interface LoginViewController () {
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat loginPadding;
    CGFloat buttonBetween;
}

@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        if (screenHeight <= 480) {
            loginPadding = screenHeight/1.47f;
            buttonBetween = 10;
        }
        else {
            loginPadding = screenHeight/1.52f;
            buttonBetween = 15;
        }
        // Custom initialization
        // moved to view did load temporarily
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    // check if user is cached and linked to Facebook and bypass login if so
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] && !FORCE_REGISTER) {
        //[PFUser logOut];
        HomeViewController *svc = [[HomeViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
        return;
    }
    
    // otherwise do login
    [self addBackgroundImage];
    [self addLogo];
    
	// Do any additional setup after loading the view.
    [self setupFacebookLogin];
    [self setupNormalLogin];
    [self setupRegisterButton];
    
}

- (void)buttonTouched:(id)sender
{
    NSArray *permissionsArray = @[@"user_about_me", @"user_friends"];
    // login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"User cancelled the FB Login Process.");
            } else {
                NSLog(@"Some error occured during FB Login Process.");
            }
        } else if (user.isNew || ![user objectForKey:@"registered"] || FORCE_REGISTER) {
            NSLog(@"User just joined the app. Successful login.");
            PFUser *currentUser = [PFUser currentUser];
            if (![currentUser objectForKey:@"fbId"]) {
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        NSDictionary *userData = (NSDictionary *)result;
                        [currentUser setObject:userData[@"id"] forKey:@"fbId"];
                        [currentUser setObject:userData[@"name"] forKey:@"fbName"];
                        NSString *url = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", userData[@"id"]];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                        
                        PFFile *image = [PFFile fileWithName:@"profile.png" data:imageData];
                        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [[PFUser currentUser] setObject:image forKey:@"fbProfilePic"];
                                [currentUser saveInBackground];
                            } else {
                                NSLog(@"parse error --saving profile image%@", error);
                            }
                        }];
                        RegisterInformationViewController *svc = [[RegisterInformationViewController alloc] init];
                        svc.fbId = userData[@"id"];
                        svc.fbName = userData[@"name"];
                        [self.navigationController pushViewController:svc animated:YES];
                    }
                }];
            } else {
                RegisterInformationViewController *svc = [[RegisterInformationViewController alloc] init];
                svc.fbId = [currentUser objectForKey:@"fbId"];
                svc.fbName = [currentUser objectForKey:@"fbName"];
                [self.navigationController pushViewController:svc animated:YES];
            }
            
        } else {
            NSLog(@"Successful login.");
            HomeViewController *svc = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
        }
    }];
}

- (void)normalLoginTouched
{
    //lol we'll have this later
}

#pragma mark - Button Setup

- (void)setupRegisterButton
{
    // Do any additional setup after loading the view.
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    self.facebookButton.frame = CGRectMake((self.view.frame.size.width - 278)/2 + 3, loginPadding + buttonBetween + 41 + 41 + buttonBetween, 278, 41);
    [self.facebookButton addTarget:self action:@selector(normalLoginTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"email-register.png"];
    [self.facebookButton setImage:btnImage forState:UIControlStateNormal];
    self.facebookButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:self.facebookButton];
}

- (void)setupNormalLogin
{
    // Do any additional setup after loading the view.
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    self.facebookButton.frame = CGRectMake((self.view.frame.size.width - 278)/2 + 3, loginPadding + buttonBetween + 41, 278, 41);
    [self.facebookButton addTarget:self action:@selector(normalLoginTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"email-login.png"];
    [self.facebookButton setImage:btnImage forState:UIControlStateNormal];
    self.facebookButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:self.facebookButton];
}

- (void)setupFacebookLogin
{
    // Do any additional setup after loading the view.
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setTitle:@"Show View" forState:UIControlStateNormal];
    
    self.facebookButton.frame = CGRectMake((self.view.frame.size.width - 278)/2 + 3, loginPadding, 278, 41);
    [self.facebookButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"facebook-login.png"];
    [self.facebookButton setImage:btnImage forState:UIControlStateNormal];
    self.facebookButton.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:self.facebookButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

#pragma mark - View Setup

- (void)addBackgroundImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    if (screenHeight <= 480) {
        imageView.image = [UIImage imageNamed:@"login-bg.png"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"login-bg-iphone4.png"];
    }
    
    [self.view insertSubview:imageView atIndex:0];
}

- (void)addLogo
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 230)/2, 50, 423/2, 231/2)];
    imgView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:imgView];
}

@end