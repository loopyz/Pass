//
//  Util.h
//  spire
//
//  Created by Ivan Wang on 7/21/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Parse/Parse.h>

@interface Util : NSObject

+ (BOOL)screenIsPortrait;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

+ (NSString *)currentUserId;
+ (void)currentPetWithBlock:(void (^)(PFObject *pet, NSError *error))callback;
//+ (BOOL)currentUserHasPet;

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy;

+ (void)migrateLatitudeLongitudeToGeoPoint;


@end
