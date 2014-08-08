//
//  SPPet.m
//  spire
//
//  Created by Niveditha Jayasekar on 8/6/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPPet.h"

@implementation SPPet

@dynamic currentUser;
@dynamic miles;
@dynamic type;
@dynamic name;
@dynamic owner;

 __strong static id _instance = nil;

+ (NSString*)parseClassName
{
    return @"Pet";
}

+ (SPPet*)currentPet
{
    return _instance;
}

+ (void)setCurrentPet:(PFObject *)pet
{
    _instance = pet;
    [SPCache sharedCache]
}

@end
