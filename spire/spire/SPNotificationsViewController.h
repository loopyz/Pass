//
//  SPNotificationsViewController.h
//  spire
//
//  Created by Niveditha Jayasekar on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"

@interface SPNotificationsViewController : UITableViewController<UIScrollViewDelegate, BEMPullToRefreshDelegate>

@property (nonatomic, strong) PullToRefresh *ptr;
@property (nonatomic, strong) NSArray *notifications;

@end
