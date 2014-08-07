//
//  SPUser.h
//  spire
//
//  Created by Niveditha Jayasekar on 8/6/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Parse/Parse.h>

@interface SPUser : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbName;
@property (nonatomic, strong) NSString *hometown;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSNumber *registered;
@property (nonatomic, strong) PFFile *fbProfilePic;

+(SPUser *)currentUser;
+(void)setCurrentUser:(PFUser *)user;

@end
