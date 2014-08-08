//
//  SPPhoto.m
//  spire
//
//  Created by Niveditha Jayasekar on 8/7/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPPhoto.h"

@implementation SPPhoto
@dynamic image;
@dynamic caption;
@dynamic user;
@dynamic pet;
@dynamic first;
@dynamic locName;
@dynamic geoPoint;

+ (NSString *)parseClassName
{
    return @"SPPhoto";
}

- (void) setAttributesWithLikers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:likedByCurrentUser], kSPPhotoAttributesIsLikedByCurrentUserKey,
                                @([likers count]), kSPPhotoAttributesLikeCountKey,
                                likers, kSPPhotoAttributesLikersKey,
                                @([commenters count]), kSPPhotoAttributesCommentCountKey,
                                commenters, kSPPhotoAttributesCommentersKey,
                                nil];
    [[SPCache sharedCache] setAttributes:attributes forPhoto:self];
}

- (NSDictionary *)getAttributes
{
    NSString *key = [[SPCache sharedCache] keyForPhoto:self];
    return [[SPCache sharedCache] objectForKey:key];
}

- (NSNumber *)likeCount
{
    NSDictionary *attributes = [self getAttributes];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesLikeCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self getAttributes];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)likers
{
    NSDictionary *attributes = [self getAttributes];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesLikersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commenters
{
    NSDictionary *attributes = [self getAttributes];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setIsLikedByCurrentUser:(BOOL)liked
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kSPPhotoAttributesIsLikedByCurrentUserKey];
    [[SPCache sharedCache] setAttributes:attributes forPhoto:self];
}

- (BOOL)isLikedByCurrentUser
{
    NSDictionary *attributes = [self getAttributes];
    if (attributes) {
        return [[attributes objectForKey:kSPPhotoAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikeCount
{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCount] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:likerCount forKey:kSPPhotoAttributesLikeCountKey];
    [[SPCache sharedCache] setAttributes:attributes forPhoto:self];
}

- (void)decrementLikeCount
{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCount] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:likerCount forKey:kSPPhotoAttributesLikeCountKey];
    [[SPCache sharedCache] setAttributes:attributes forPhoto:self];
}

- (void)incrementCommentCount
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCount] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:commentCount forKey:kSPPhotoAttributesCommentCountKey];
    [[SPCache sharedCache] setAttributes:attributes forPhoto:self];
}

- (void)decrementCommentCount
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCount] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:commentCount forKey:kSPPhotoAttributesCommentCountKey];
    [[SPCache sharedCache] setAttributes:attributes forPhoto:self];
}

@end
