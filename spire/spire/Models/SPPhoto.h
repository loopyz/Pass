//
//  SPPhoto.h
//  spire
//
//  Created by Niveditha Jayasekar on 8/7/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Parse/Parse.h>

@interface SPPhoto : PFObject<PFSubclassing>

@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFObject *pet;
@property (nonatomic, strong) NSNumber *first;
@property (nonatomic, strong) NSString *locName;
@property (nonatomic, strong) PFGeoPoint *geoPoint;

- (void) setAttributesWithLikers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
- (NSDictionary *)getAttributes;

- (NSNumber *)likeCount;
- (NSNumber *)commentCount;

- (NSArray *)likers;
- (NSArray *)commenters;

- (void)setIsLikedByCurrentUser:(BOOL)liked;
- (BOOL)isLikedByCurrentUser;

- (void)incrementLikeCount;
- (void)decrementLikeCount;
- (void)incrementCommentCount;
- (void)decrementCommentCount;
@end
