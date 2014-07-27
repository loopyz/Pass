//
//  SettingsForm.h
//  spire
//
//  Created by Lucy Guo on 7/27/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FXForms.h"


typedef NS_ENUM(NSInteger, Gender)
{
    GenderMale = 0,
    GenderFemale,
    GenderOther
};

@interface SettingsForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *repeatPassword;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) UIImage *profilePhoto;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSArray *interests;
@property (nonatomic, copy) NSString *about;


@property (nonatomic, copy) NSString *notifications;
@property (nonatomic, assign) BOOL agreedToTerms;

@end