//
//  PetProfileViewController.h
//  spire
//
//  Created by Niveditha Jayasekar on 7/19/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetProfileViewController : UICollectionViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *personButton;

@property (nonatomic) BOOL mapTouched;
@property (nonatomic) BOOL photoTouched;
@property (nonatomic) BOOL personTouched;

@end
