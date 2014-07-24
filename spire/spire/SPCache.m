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




@end
