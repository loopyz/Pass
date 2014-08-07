//
//  SPPet.h
//  spire
//
//  Created by Niveditha Jayasekar on 8/6/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Parse/Parse.h>

@interface SPPet : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSNumber *miles;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFUser *owner;

+ (SPPet*)currentPet;
+ (void)setCurrentPet:(PFObject *)pet;

@end
