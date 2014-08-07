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

- (void) setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo;
- (NSString *)keyForPhoto:(PFObject *)photo;

- (void) setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user;
- (NSString *)keyForUser:(PFUser *)user;

- (void) setAttributes:(NSDictionary *)attributes forPet:(SPPet *)pet;
- (NSString *)keyForPet:(SPPet *)pet;

- (void)setCurrentPet:(PFObject *)pet;
- (PFObject *)currentPet;

@end
