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

- (void) setAttributes:(NSDictionary *)attributes forPhoto:(SPPhoto *)photo
{
    NSString *key = [self keyForPhoto:photo];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForPhoto:(SPPhoto *)photo
{
    return [NSString stringWithFormat:@"photo_%@", [photo objectId]];
}

- (NSDictionary *)attributesForPhoto:(SPPhoto *)photo
{
    NSString *key = [self keyForPhoto:photo];
    return [self.cache objectForKey:key];
}

- (void) setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user
{
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForUser:(PFUser *)user
{
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

- (NSDictionary *)attributesForUser:(PFUser *)user
{
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (void) setAttributes:(NSDictionary *)attributes forPet:(SPPet *)pet
{
    NSString *key = [self keyForPet:pet];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForPet:(SPPet *)pet
{
    return [NSString stringWithFormat:@"pet_%@", [pet objectId]];
}

- (NSDictionary *)attributesForPet:(SPPet *)pet
{
    NSString *key = [self keyForPet:pet];
    return [self.cache objectForKey:key];
}

@end
