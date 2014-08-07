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

+ (void)updateCurrentPetInBackground
{
    PFUser *user = [PFUser currentUser];
    if (!user) {
        NSLog(@"Warning: tried to set current pet while not logged in.");
        return;
    }

    PFQuery *query = [PFQuery queryWithClassName:kSPPetClassKey];
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

+ (void)updateCurrentUserActiveInBackground
{
    PFUser *user = [PFUser currentUser];
    [user setObject:[NSDate date] forKey:@"lastActiveAt"];
    [user saveInBackground];
}

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    PFUser *toUser = [photo objectForKey:@"user"];
    PFObject *likeActivity = [PFObject objectWithClassName:kSPActivityClassKey];
    [likeActivity setObject:kSPActivityTypeLike forKey:@"type"];
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
    

    PFObject *followActivity = [PFObject objectWithClassName:kSPActivityClassKey];
    [followActivity setObject:kSPActivityTypeFollow forKey:@"type"];
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
    PFQuery *queryLikes = [PFQuery queryWithClassName:kSPActivityClassKey];
    [queryLikes whereKey:@"photo" equalTo:photo];
    [queryLikes whereKey:@"type" equalTo:kSPActivityTypeLike];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kSPActivityClassKey];
    [queryComments whereKey:@"photo" equalTo:photo];
    [queryComments whereKey:@"type" equalTo:kSPActivityTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    // TODO: set cache policy
    [query includeKey:@"fromUser"];
    [query includeKey:@"photo"];

    return query;
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
    PFQuery *query = [PFQuery queryWithClassName:kSPActivityClassKey];
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

#pragma mark - Foursquare API

+ (void)getVenues:(NSString *)url withCallback:(void (^)(NSArray *locs))callback
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];

    [request setHTTPMethod: @"GET"];

    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   json = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:nil];
                                   NSLog(@"%@", json[@"response"][@"venues"][0][@"name"]);

                                   callback(json[@"response"][@"venues"]);
                               }
                           }];
}

+ (void)getFoursquareVenuesNearGeoPoint:(PFGeoPoint *)geoPoint withCallback:(void (^)(NSArray *locs))callback
{
    NSString *locFormat = @"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%f,%f";
    NSString *queryAddr = [NSString stringWithFormat:locFormat, kSPFoursquareClientId, kSPFoursquareClientSecret, geoPoint.latitude, geoPoint.longitude];
  
    [self getVenues:queryAddr withCallback:callback];
}



@end
