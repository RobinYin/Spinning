//
//  SpinningHistoryCell.m
//  Spinning
//
//  Created by Robin on 8/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningHistoryCell.h"

@implementation SpinningHistoryCell

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
    [self.titleLabel setFrame:CGRectMake(HistoryCellGap, HistoryCellGap, HistoryCellTitleWith, 36)];
    [self.cxtLabel setFrame:CGRectMake(HistoryCellGap, HistoryCellGap + 36, ScreenWidth - 2*HistoryCellGap, 16)];
    [self.seperateImgView setFrame:CGRectMake(0, HistoryCellHeight - 1, ScreenWidth, 1)];
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
