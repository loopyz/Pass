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
    PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
    [likeActivity setObject:@"like" forKey:@"type"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:[photo objectForKey:@"user"] forKey:@"toUser"];
    [likeActivity setObject:photo forKey:@"photo"];
    
    // TODO: ACL protection
    PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
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
    
    // TODO: ACL protection
    
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

+ (void)shareToTwitter:(PFUser *)user photo:(UIImage *)image caption:(NSString *)caption block:(void(^) (BOOL succeeded, NSError *error)) completionBlock
{
    if (![PFTwitterUtils isLinkedWithUser:user]) {
        [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
            // sharing
            [self twitterImageConverstion:image caption:caption];
        }];
    } else {
        // sharing
        //UIImagePNGRepresentation(image)
        [self twitterImageConverstion:image caption:caption];
    }
}

+ (void) twitterImageConverstion:(UIImage *)image caption:(NSString *)caption
{
    NSURL *requestURL = [NSURL URLWithString:@"https://upload.twitter.com/1.1/statuses/update_with_media.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    NSString *stringBoundary = @"---------------------------14737809831466499882746641449";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // add image data
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"media[]\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set URL
    [request setURL:requestURL];
    
    
    // Construct the parameters string. The value of "status" is percent-escaped.
    
    
    [[PFTwitterUtils twitter] signRequest:request];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Post status synchronously.
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    // Handle response.
    if (!error) {
        NSString *responseBody = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"Error: %@", responseBody);
    } else {
        NSLog(@"Error: %@", error);
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


@end
