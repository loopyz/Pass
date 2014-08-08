//
//  SPUser.m
//  spire
//
//  Created by Niveditha Jayasekar on 8/6/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPUser.h"

@implementation SPUser

@dynamic username;
@dynamic description;
@dynamic fbId;
@dynamic fbName;
@dynamic hometown;
@dynamic website;
@dynamic registered;
@dynamic fbProfilePic;

 __strong static id _instance = nil;

+(SPUser *)currentUser
{
    return _instance;
}

+(void)setCurrentUser:(PFUser *)user
{
    _instance = user;
}

- (void)setAttributesWithPhotoCount:(NSNumber *)count followedByCurrentUser:(BOOL)following
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count, kSPUserAttributesPhotoCountKey,
                                [NSNumber numberWithBool:following], kSPUserAttributesIsFollowedByCurrentUserKey,
                                nil];
    [[SPCache sharedCache] setAttributes:attributes forUser:self];
}

- (NSDictionary *)getAttributes
{
    return [[SPCache sharedCache] attributesForUser:self];
}

- (NSNumber *)photoCount
{
    NSDictionary *attributes = [self getAttributes];
    
    if (attributes) {
        NSNumber *photoCount = [attributes objectForKey:kSPUserAttributesPhotoCountKey];
        
        if (photoCount) {
            return photoCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatus
{
    NSDictionary *attributes = [self getAttributes];
    
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kSPUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    
    return NO;
}

- (void)setPhotoCount:(NSNumber *)count
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:count forKey:kSPUserAttributesPhotoCountKey];
    [[SPCache sharedCache] setAttributes:attributes forUser:self];
}

- (void)setFollowStatus:(BOOL)following
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getAttributes]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kSPUserAttributesIsFollowedByCurrentUserKey];
    [[SPCache sharedCache] setAttributes:attributes forUser:self];
}

@end
