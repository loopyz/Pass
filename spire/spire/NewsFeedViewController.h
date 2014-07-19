//
//  NewsFeedViewController.h
//  spire
//
//  Created by Lucy Guo on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"

@interface NewsFeedViewController : UITableViewController<UIScrollViewDelegate, BEMPullToRefreshDelegate>

@property (nonatomic, strong) PullToRefresh *ptr;
@property (nonatomic, strong) NSMutableArray *videos;

@end
