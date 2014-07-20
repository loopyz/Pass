//
//  SingleImageViewController.h
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface SingleImageViewController : UITableViewController

@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, strong) UIView *captionView;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePic;
@property (nonatomic, strong) PFObject *photo;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *usernames;

- (id)initWithPhoto: (PFObject *)photo;
@end
