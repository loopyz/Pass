//
//  CommentCell.h

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

extern const CGFloat kCommentPaddingFromLeft;
extern const CGFloat kCommentPaddingFromRight;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIImageView *likeCountImageView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *nameLabel;
@end
