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


@end
