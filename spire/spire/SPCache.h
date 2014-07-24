//
//  SPCache.h
//  spire
//
//  Created by Niveditha Jayasekar on 7/23/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCache : NSObject

+ (id)sharedCache;

- (void)clear;

// todo add cache methods for activities
//- (void) setAttributesForPhoto: (PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
//- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
//
//- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
//- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
//
//- (NSArray *)likersForPhoto:(PFObject *)photo;
//- (NSArray *)commentersForPhoto:(PFObject *)photo;
//
//- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo;
//- (void)incrementLikeCountForPhoto:(PFObject *)photo;
//- (void)decrementLikeCountForPhoto:(PFObject *)photo;
//- (void)incrementCommentCountForPhoto:(PFObject *)photo;
//- (void)decrementCommentCountForPhoto:(PFObject *)photo;
//
//- (NSDictionary *)attributesForUser:(PFUser *)user;
//
//- (NSNumber *)photoCountForUser:(PFUser *)user;
//- (void)setPhotoCountForUser:(NSNumber *)count user:(PFUser *)user;

@end
