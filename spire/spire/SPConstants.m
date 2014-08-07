//
//  SPConstants.m
//  spire
//
//  Created by Ivan Wang on 7/31/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPConstants.h"

#pragma mark - Third-Party App Keys

NSString *const kSPParseApplicationId = @"0tIsLeaAK4LvDqxYfrVc9Qzs7l3kyIqlmEYqsnRw";
NSString *const kSPParseClientKey = @"OxsqVethSVtjArsp2OPWN85RnAsLXQxKS7jbdwJv";

NSString *const kSPFoursquareClientId = @"02K3GC4J1Y34WDZG4XIWHBSF2WJKOHIOMSTPWTWQVMPFALL2";
NSString *const kSPFoursquareClientSecret = @"XYHXKNHOVBPTX4KLXR1QID4QNA2RSMXZZQML32ANKP1H4VHJ";

NSString *const kSPGoogleApplicationKey = @"AIzaSyC2hvD0SPXnBmOEK09pFH02M9UZYp-yYLc";

#pragma mark - Parse Model Keys

NSString *const kSPPetClassKey = @"Pet";
NSString *const kSPPhotoClassKey = @"Photo";
NSString *const kSPActivityClassKey = @"Activity";

NSString *const kSPActivityTypeLike = @"like";
NSString *const kSPActivityTypeComment = @"comment";
NSString *const kSPActivityTypeFollow = @"follow";


#pragma mark - Cached Photo Attributes
NSString *const kSPPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kSPPhotoAttributesLikeCountKey = @"likeCount";
NSString *const kSPPhotoAttributesLikersKey = @"likers";
NSString *const kSPPhotoAttributesCommentCountKey = @"commentCount";
NSString *const kSPPhotoAttributesCommentersKey = @"commenters";

#pragma mark - Cached User Attributes
NSString *const kSPUserAttributesPhotoCountKey = @"photoCount";
NSString *const kSPUserAttributesIsFollowedByCurrentUserKey = @"isFollowedByCurrentUser";

#pragma mark - Google APIs

const int kSPGooglePlacesMaxRadius = 10;