//
//  SPCache.m
//  spire
//
//  Created by Niveditha Jayasekar on 7/23/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPCache.h"

@interface SPCache()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation SPCache
@synthesize cache;

+ (id)sharedCache
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;

    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }

    return self;
}

- (void)clear
{
    [self.cache removeAllObjects];
}


- (void)setCurrentPet:(PFObject *)pet {
    NSLog(@"Updating current pet in cache.");
    NSString *key = @"currentPet";
    if (pet) {
        [self.cache setObject:pet forKey:key];
    } else {
        [self.cache removeObjectForKey:key];
    }
//    [[NSUserDefaults standardUserDefaults] setObject:pet forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (PFObject *)currentPet {
    NSString *key = @"currentPet";
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    } else {
        //    PFObject *pet = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        PFQuery *petQuery = [PFQuery queryWithClassName:kSPPetClassKey];
        [petQuery whereKey:@"currentUser" equalTo:[PFUser currentUser]];
        PFObject *pet = [petQuery getFirstObject];
        if (pet) {
            [self.cache setObject:pet forKey:key];
        }
        
        return pet;
    }
}

- (void) setAttributesForPhoto: (PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:likedByCurrentUser], kSPPhotoAttributesIsLikedByCurrentUserKey,
                                @([likers count]), kSPPhotoAttributesLikeCountKey,
                                likers, kSPPhotoAttributesLikersKey,
                                @([commenters count]), kSPPhotoAttributesCommentCountKey,
                                commenters, kSPPhotoAttributesCommentersKey,
                                nil];
    [self setAttributes:attributes forPhoto:photo];
}

- (NSDictionary *)attributesForPhoto:(PFObject *)photo
{
    NSString *key = [self keyForPhoto:photo];
    return [self.cache objectForKey:key];
}

- (NSNumber *)likeCountForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesLikeCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)likersForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesLikersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commentersForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [attributes objectForKey:kSPPhotoAttributesCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kSPPhotoAttributesIsLikedByCurrentUserKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (BOOL)isPhotoIsLikedByCurrentUser:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes) {
        return [[attributes objectForKey:kSPPhotoAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikeCountForPhoto:(PFObject *)photo
{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:likerCount forKey:kSPPhotoAttributesLikeCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)decrementLikeCountForPhoto:(PFObject *)photo
{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:likerCount forKey:kSPPhotoAttributesLikeCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)incrementCommentCountForPhoto:(PFObject *)photo
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:commentCount forKey:kSPPhotoAttributesCommentCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)decrementCommentCountForPhoto:(PFObject *)photo
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:commentCount forKey:kSPPhotoAttributesCommentCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)setAttributesForUser:(PFUser *)user photoCount:(NSNumber *)count followedByCurrentUser:(BOOL)following
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count, kSPUserAttributesPhotoCountKey,
                                [NSNumber numberWithBool:following], kSPUserAttributesIsFollowedByCurrentUserKey,
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PFUser *)user
{
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)photoCountForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    
    if (attributes) {
        NSNumber *photoCount = [attributes objectForKey:kSPUserAttributesPhotoCountKey];
        
        if (photoCount) {
            return photoCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatusForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kSPUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    
    return NO;
}

- (void)setPhotoCountForUser:(NSNumber *)count user:(PFUser *)user
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kSPUserAttributesPhotoCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kSPUserAttributesIsFollowedByCurrentUserKey];
    [self setAttributes:attributes forUser:user];
}

- (void) setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo
{
    NSString *key = [self keyForPhoto:photo];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForPhoto:(PFObject *)photo
{
    return [NSString stringWithFormat:@"photo_%@", [photo objectId]];
}

- (void) setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user
{
    NSString *key = [self keyForPhoto:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForUser:(PFUser *)user
{
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}


@end
