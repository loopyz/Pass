//
//  SingleImageViewController.h
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SingleImageViewController : UITableViewController

@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, strong) UIView *captionView;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePic;

@end
