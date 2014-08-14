//
//  SPNewsFeedCell.m
//  spire
//
//  Created by Niveditha Jayasekar on 8/13/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "SPNewsFeedCell.h"
#import "CommentsViewController.h"

@interface SPNewsFeedCell ()



@property (strong, nonatomic) UIView *informationView;
@property (strong, nonatomic) PFImageView *imageView;
@property (strong, nonatomic) UILabel *desc;
@property (strong, nonatomic) UIButton *likesButton;
@property (strong, nonatomic) UIButton *commentsButton;
@property (strong, nonatomic) UIButton *heartButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *shareButton;
@end

@implementation SPNewsFeedCell
@synthesize imageView;
- (id) initWithPhoto:(SPPhoto *)photo photoIndex:(NSInteger)photoIndex style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIImage *commentButtonIcon = [UIImage imageNamed:@"newsfeedcommentbutton.png"];
        UIImage *locationIcon = [UIImage imageNamed:@"locationicon.png"];
        UIImage *heartIcon = [UIImage imageNamed:@"hearticon.png"];
        UIImage *commentIcon = [UIImage imageNamed:@"commenticon.png"];
        UIImage *heartButtonUnactiveIcon = [UIImage imageNamed:@"heartbuttonunactive.png"];
        UIImage *heartButtonActiveIcon = [UIImage imageNamed:@"heartbuttonactive.png"];
        UIImage *shareButtonIcon = [UIImage imageNamed:@"newsfeedmoreoptions.png"];
        
        self.backgroundColor =  [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f];
        
        // setup information view
        self.informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 450)];
        self.informationView.backgroundColor = [UIColor whiteColor];
        self.imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        self.imageView.image =[UIImage imageNamed:@"tempsingleimage.png"];
        [self.informationView addSubview:self.imageView];
        
        UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
        
        //setup caption label
        self.desc = [[UILabel alloc] initWithFrame:CGRectMake(15, 320, 200, 50)];
        [self.desc setTextColor:descColor];
        [self.desc setBackgroundColor:[UIColor clearColor]];
        [self.desc setFont:[UIFont fontWithName:@"Avenir" size:17]];
        self.desc.lineBreakMode = NSLineBreakByWordWrapping;
        self.desc.numberOfLines = 0;
        [self.informationView addSubview:self.desc];
        
        // setup separator
        UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(14.75, self.desc.frame.origin.y + self.desc.frame.size.height + 25, 291, 3)];
        separator.image = [UIImage imageNamed:@"newsfeedborder.png"];
        [self.informationView addSubview:separator];
        
        //setup likes label
        self.likesButton = [[UIButton alloc] initWithFrame:CGRectMake(9, self.desc.frame.origin.y + self.desc.frame.size.height, 55, 20)];
        [self.likesButton addTarget:self action:@selector(seeLikes:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.likesButton setTitleColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.likesButton setTitle:@"22 likes" forState:UIControlStateNormal];
        self.likesButton.titleLabel.font =[UIFont fontWithName:@"Avenir" size:12];
        
        [self.informationView addSubview:self.likesButton];
        
        //setup comments label
        self.commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.likesButton.frame.origin.x + self.likesButton.frame.size.width, self.desc.frame.origin.y + self.desc.frame.size.height, 100, 20)];
        
        [self.commentsButton setTitleColor:[UIColor colorWithRed:25/255.0f green:138/255.0f blue:149/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.commentsButton setTitle:@"12 comments" forState:UIControlStateNormal];
        self.commentsButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:12];
        [self.commentsButton addTarget:self action:@selector(commentTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.informationView addSubview:self.commentsButton];
        
        
        
        
        [self addSubview:self.informationView];
        
        // testing shit out
        
        self.heartButton = [[UIButton alloc] init];
        // Hardcode the x value and size for simplicity
        BOOL isLiked = NO;
        self.heartButton.selected = isLiked ? YES : NO;
        self.heartButton.frame = CGRectMake(15, separator.frame.origin.y + separator.frame.size.height + 10, 28, 28);
        [self.heartButton setImage:[UIImage imageNamed:@"likeButton_unselected.png"] forState:UIControlStateNormal];
        [self.heartButton setImage:[UIImage imageNamed:@"likeButton_selected.png"] forState:UIControlStateSelected];
        [self.heartButton setImage:[UIImage imageNamed:@"likeButton_highlighted.png"] forState:UIControlStateHighlighted];
        [self.heartButton addTarget:self action:@selector(heartTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.heartButton];
        
        // setup comment button
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        self.commentButton.frame = CGRectMake(self.heartButton.frame.size.height + self.heartButton.frame.origin.x + 30, separator.frame.origin.y + separator.frame.size.height + 10, 28, 26);
        
        [self.informationView addSubview:self.commentButton];
        [self.commentButton setImage:commentButtonIcon forState:UIControlStateNormal];
        self.commentButton.contentMode = UIViewContentModeScaleToFill;
        [self.commentButton addTarget:self action:@selector(commentTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        // setup share button
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
        
        self.shareButton.frame = CGRectMake(self.frame.size.width - 50, separator.frame.origin.y + separator.frame.size.height + 10, 31, 31);
        
        [self.informationView addSubview:self.shareButton];
        [self.shareButton setImage:shareButtonIcon forState:UIControlStateNormal];
        self.shareButton.contentMode = UIViewContentModeScaleToFill;
        [self.shareButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];

        self.photo = photo;
        self.photoIndex = [[NSNumber alloc] initWithInteger:photoIndex];
        [self reloadCell];
    }
    
    return self;
}

- (void) reloadCell
{
    self.imageView.file = [self.photo image];
    [self.imageView loadInBackground];
    
    self.desc.text = [self.photo caption];
    
    [self.likesButton setTitle:[NSString stringWithFormat:@"%@ likes", [self.photo likeCount]] forState:UIControlStateNormal];
    
    [self.commentsButton setTitle:[NSString stringWithFormat:@"%@ comments", [self.photo commentCount]] forState:UIControlStateNormal];
}

- (void)heartTouched:(id)sender
{
    // change image of button
    UIButton *heartButton = (UIButton *)sender;
    heartButton.selected = !heartButton.selected;
    
    // TODO: toggle styles of heart
    // TODO: add dislike part
    [Util likePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"error liking photo");
        } else {
            NSLog(@"liked photo successfully");
        }
    }];
    
    
}

- (void)commentTouched:(id)sender
{
    NSLog(@"comment touched from inside SPNewsFeedCell");
    
    NSDictionary *userInfo = @{@"photoIndex":self.photoIndex};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openCommentsForPhoto" object:nil userInfo:userInfo];
}

- (void)seeLikes:(id)self
{
    NSLog(@"show people who have liked it here");
}

- (void)moreButtonPressed
{
    NSLog(@"more button pressed");
    NSDictionary *userInfo = @{@"photoIndex":self.photoIndex};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openMoreForPhoto" object:nil userInfo:userInfo];
}

@end
