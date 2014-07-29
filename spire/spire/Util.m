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

+ (void)updateCurrentPetInBackground
{
    PFUser *user = [PFUser currentUser];
    if (!user) {
        NSLog(@"Warning: tried to set current pet while not logged in.");
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"Pet"];
    [query whereKey:@"currentUser" equalTo:user];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *pet, NSError *error) {
        if (!error) {
            [[SPCache sharedCache] setCurrentPet:pet];
        } else {
            NSLog(@"Error retrieving current pet.");
        }
    }];
}

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    PFUser *toUser = [photo objectForKey:@"user"];
    PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
    [likeActivity setObject:@"like" forKey:@"type"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:toUser forKey:@"toUser"];
    [likeActivity setObject:photo forKey:@"photo"];
    [likeActivity setObject:@1 forKey:@"unread"];
    
    // TODO: ACL protection
    PFACL *likeACL = [PFACL ACL];
    [likeACL setWriteAccess:YES forUser:toUser];
    [likeACL setWriteAccess:YES forUser:[PFUser currentUser]];
    [likeACL setPublicReadAccess:YES];
    likeActivity.ACL = likeACL;

    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        // TODO: updating cache
    }];
    
}

+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    
}

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    // don't follow yourself
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    

    PFObject *followActivity = [PFObject objectWithClassName:@"Activity"];
    [followActivity setObject:@"follow" forKey:@"type"];
    [followActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [followActivity setObject:user forKey:@"toUser"];
    [followActivity setObject:@1 forKey:@"unread"];
    
    //ACL protection
    PFACL *followACL = [PFACL ACL];
    [followACL setWriteAccess:YES forUser:user];
    [followACL setWriteAccess:YES forUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        // TODO: updating cache
    }];
}

+ (void)unfollowUserEventually:(PFUser *)user
{
    
}

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy
{
    PFQuery *queryLikes = [PFQuery queryWithClassName:@"Activity"];
    [queryLikes whereKey:@"photo" equalTo:photo];
    [queryLikes whereKey:@"type" equalTo:@"like"];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:@"Activity"];
    [queryComments whereKey:@"photo" equalTo:photo];
    [queryComments whereKey:@"type" equalTo:@"comment"];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    // TODO: set cache policy
    [query includeKey:@"fromUser"];
    [query includeKey:@"photo"];

    return query;
}

+ (void)migrateLatitudeLongitudeToGeoPoint
{
    NSLog(@"Migrating LL for pets...");
    NSArray *pets = [[PFQuery queryWithClassName:@"Pet"] findObjects];
    for (PFObject *pet in pets) {
        if ([pet objectForKey:@"geoPoint"] == nil) {
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[[pet objectForKey:@"latitude"] doubleValue] longitude:[[pet objectForKey:@"longitude"] doubleValue]];
            [pet setObject:geoPoint forKey:@"geoPoint"];
            [pet saveInBackground];
        }
    }

    NSLog(@"Migrating LL for photos...");
    NSArray *photos = [[PFQuery queryWithClassName:@"Photo"] findObjects];
    for (PFObject *photo in photos) {
        if ([photo objectForKey:@"geoPoint"] == nil) {
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[[photo objectForKey:@"latitude"] doubleValue] longitude:[[photo objectForKey:@"longitude"] doubleValue]];
            [photo setObject:geoPoint forKey:@"geoPoint"];
            [photo saveInBackground];
        }
    }
}


+ (void)shareToFacebook:(PFUser *)user photo:(UIImage *)image caption:(NSString *)caption block:(void(^) (BOOL succeeded, NSError *error)) completionBlock
{
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        // todo: adding permissions
        [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
            //sharing
            if ([FBDialogs canPresentShareDialogWithPhotos]){
                NSLog(@"can present");
                FBPhotoParams *params = [[FBPhotoParams alloc]init];
                params.photos = @[image];
                [FBDialogs presentShareDialogWithPhotoParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                    completionBlock(error == nil, error);
                }];
                
            }
        }];
    } else {
        // sharing
        if ([FBDialogs canPresentShareDialogWithPhotos]){
            NSLog(@"can present");
            FBPhotoParams *params = [[FBPhotoParams alloc]init];
            params.photos = @[image];
            [FBDialogs presentShareDialogWithPhotoParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                completionBlock(error == nil, error);
            }];
            
        }
    }
}

+ (PFQuery *)queryForNotifications:(BOOL *)getUnread
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:@"fromUser"];
    [query includeKey:@"fromUser"];
    //[query includeKey:@"photo"]; // todo?
    if (getUnread) {
        [query whereKey:@"unread" equalTo:@1];
    } else {
        [query setLimit:50];
    }
    [query orderByDescending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // todo: add caching
    
    return query;
}

@end
