//
//  SpingNotificationCell.m
//  Spinning
//
//  Created by Robin on 8/29/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningNotificationCell.h"

@implementation SpinningNotificationCell

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
    [self.titleLabel setFrame:CGRectMake(PHCellGap, PHCellGap, NotificationCellTitleWith, 36)];
    [self.cxtLabel setFrame:CGRectMake(PHCellGap, PHCellGap + 36, ScreenWidth - 2*PHCellGap, 16)];
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
