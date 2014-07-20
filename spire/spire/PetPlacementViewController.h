//
//  PetPlacementViewController.h
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface PetPlacementViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, YCameraViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UITextView *textEntry;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UISwitch *toggleDrop;
@property (strong, nonatomic) YCameraViewController *cvc;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (strong, nonatomic) PFObject *pet;

- (IBAction)hideKeyboard:(id)sender;

@end
