//
//  SPProfilePetCell.h
//  spire
//
//  Created by Niveditha Jayasekar on 8/6/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPProfilePetCell : UITableViewCell

@property (nonatomic, strong) SPPet *pet;

- (id) initWithPet:(SPPet *)pet style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void) reloadCell;
@end
