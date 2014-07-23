//
//  Util.m
//  spire
//
//  Created by Ivan Wang on 7/21/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "Util.h"

@implementation Util

# pragma mark - Screen Utilities

+ (BOOL)screenIsPortrait
{
    return ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

+ (CGFloat)screenWidth
{
    return ([self screenIsPortrait] ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height);
}

+ (CGFloat)screenHeight
{
  return ([self screenIsPortrait] ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width);
}

#pragma mark - Parse Utilities

+ (NSString *)currentUserId
{
    return [[PFUser currentUser] objectId];
}

+ (void)currentPetWithBlock:(void (^)(PFObject *pet, NSError *error))callback
{
    PFUser *user = [PFUser currentUser];
    if (user == nil) {
        NSLog(@"Warning: tried to call current pet while not logged in.");
        callback(nil, nil);
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
    [query whereKey:@"currentUserId" equalTo:[user objectId]];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *pet, NSError *error) {
        callback(pet, error);
    }];
}

/*+ (BOOL)currentUserHasPet
{
    PFUser *user = [PFUser currentUser];
    return (user != nil && user[@"currentPetId"] != [NSNull null]);
}*/

@end
