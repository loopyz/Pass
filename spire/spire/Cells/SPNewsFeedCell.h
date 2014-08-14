//
//  SPNewsFeedCell.h
//  spire
//
//  Created by Niveditha Jayasekar on 8/13/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNewsFeedCell : UITableViewCell

@property (strong, nonatomic) SPPhoto *photo;
@property (strong, nonatomic) NSNumber *photoIndex;

- (id) initWithPhoto:(SPPhoto *)photo photoIndex:(NSInteger)photoIndex style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void) reloadCell;
@end
