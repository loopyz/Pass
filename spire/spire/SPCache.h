//
//  SPCache.h
//  spire
//
//  Created by Niveditha Jayasekar on 7/23/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SPCache : NSObject

+ (id)sharedCache;

- (void)clear;

- (void)setCurrentPet:(PFObject *)pet;
- (PFObject *)currentPet;

- (void) setAttributesForPhoto: (PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
- (NSDictionary *)attributesForPhoto:(PFObject *)photo;

- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
- (NSNumber *)commentCountForPhoto:(PFObject *)photo;

- (NSArray *)likersForPhoto:(PFObject *)photo;
- (NSArray *)commentersForPhoto:(PFObject *)photo;

- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;
- (BOOL)isPhotoIsLikedByCurrentUser:(PFObject *)photo;

- (void)incrementLikeCountForPhoto:(PFObject *)photo;
- (void)decrementLikeCountForPhoto:(PFObject *)photo;
- (void)incrementCommentCountForPhoto:(PFObject *)photo;
- (void)decrementCommentCountForPhoto:(PFObject *)photo;

- (void)setAttributesForUser:(PFUser *)user photoCount:(NSNumber *)count followedByCurrentUser:(BOOL)following;
- (NSDictionary *)attributesForUser:(PFUser *)user;

- (NSNumber *)photoCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user

- (void)setPhotoCountForUser:(NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

- (NSDictionary *) setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo;
- (NSString *)keyForPhoto:(PFObject *)photo;

- (void) setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user;
- (NSString *)keyForUser:(PFUser *)user;

@end
