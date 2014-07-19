//
//  CameraViewController.h
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImageView *overlay;
@property (strong, nonatomic) UIImagePickerController *picker;

@end
