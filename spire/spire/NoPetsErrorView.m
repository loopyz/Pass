//
//  NoPetsErrorView.m
//  spire
//
//  Created by Lucy Guo on 7/20/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "NoPetsErrorView.h"
#import "FindPetViewController.h"

@implementation NoPetsErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      [self setBackground];
      // [self setSubmitButton];
    }
    return self;
}

- (void)setBackground {
  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
  imgView.image = [UIImage imageNamed:@"nopetbg.png"];
  [self addSubview:imgView];
}

- (void)setSubmitButton
{
  // Do any additional setup after loading the view.
  UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [submitButton setTitle:@"Show View" forState:UIControlStateNormal];
  
  submitButton.frame = CGRectMake(0, [Util screenHeight] - 180, 320, 47.5);
  [submitButton addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *btnImage = [UIImage imageNamed:@"findonebutton.png"];
  [submitButton setImage:btnImage forState:UIControlStateNormal];
  submitButton.contentMode = UIViewContentModeScaleToFill;
  
  [self addSubview:submitButton];
}

- (void)buttonTouched:(id)sender
{
    // do nothing for now.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
