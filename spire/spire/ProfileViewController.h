//
//  ProfileViewController.h
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "PullToRefresh.h"
#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController

@property (nonatomic, strong) UIView *profileSnippetView;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePic;
@property (nonatomic, strong) NSMutableArray *photos;
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UILabel *numScoresLabel;
@property (nonatomic, strong) PullToRefresh *ptr;


@end
