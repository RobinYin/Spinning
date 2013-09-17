//
//  SpinningCommentCell.m
//  Spinning
//
//  Created by Robin on 9/17/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningCommentCell.h"

@implementation SpinningCommentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configurationCellContent];
    }
    return self;
}

- (void)configurationCellContent
{
    [super configurationCellContent];
    [self.titleLabel setFrame:CGRectMake(PHCellGap, PHCellGap, TopicCellImgWith, 18)];
    [self.cxtLabel setFrame:CGRectMake(PHCellGap, PHCellGap + 18, TopicCellImgWith, 32)];
    [self.seperateImgView setFrame:CGRectMake(0, NotificationCellHeight - 1, ScreenWidth, 1)];
}

- (void)dealloc
{
    RbSuperDealoc;
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
