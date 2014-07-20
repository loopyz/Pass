//
//  VenueTableViewController.h
//  spire
//
//  Created by Jeffrey Zhang on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueTableViewController : UITableViewController

typedef void(^DictCallback)(NSDictionary *selectedVenue);

- (id)initWithVenues:(NSArray*)venueItems andCallback:(DictCallback)callback;

@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) DictCallback callback;

@end
