//
//  SpinningPHCell.m
//  Spinning
//
//  Created by Robin on 8/29/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningPHCell.h"

@implementation SpinningPHCell

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
    [self.titleLabel setFrame:CGRectMake(PHCellGap, PHCellGap, ScreenWidth - 3*PHCellGap - PHCellImageWith, 18)];
    [self.cxtLabel setFrame:CGRectMake(PHCellGap, PHCellGap + 18, ScreenWidth - 3*PHCellGap - PHCellImageWith, 32)];
    [self.cxtImgView setFrame:CGRectMake(ScreenWidth - PHCellGap - PHCellImageWith, PHCellGap, PHCellImageWith, 50)];
    [self.cxtImgView setImage:[UIImage imageNamed:@"img_defaul"]];
    [self.seperateImgView setFrame:CGRectMake(0, PHCellHeight - 1, ScreenWidth, 1)];
    
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
