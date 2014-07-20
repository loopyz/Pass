//
//  PetPlacementViewController.h
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCameraViewController.h"

@interface PetPlacementViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, YCameraViewControllerDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UITextField *textEntry;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UISwitch *toggleDrop;
@property (strong, nonatomic) YCameraViewController *cvc;

@end
