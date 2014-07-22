//
//  RegisterInformationViewController.h
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

#import "ELCTextfieldCell.h"

@interface RegisterInformationViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,ELCTextFieldDelegate>
{
	NSArray *labels;
	NSArray *placeholders;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) UITableView *formTable;

// personalization
@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbName;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePic;
@property (nonatomic) BOOL keyboardIsShown;

@end
