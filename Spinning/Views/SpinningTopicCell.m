//
//  SpinningTopicCell.m
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningTopicCell.h"

@implementation SpinningTopicCell
@synthesize subLabel = _subLabel;
@synthesize badgeView = _badgeView;

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
    [self.titleLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap +TopicCellImgheight + 5 , TopicCellImgWith, 18)];
//    [self.cxtLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 33, TopicCellImgWith, 64)];
    [self.cxtLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 23, TopicCellImgWith, 64)];
    [self.cxtImgView setFrame:CGRectMake(TopicCellImgGap, TopicCellGap, TopicCellReimgWith, TopicCellImgheight)];
    [self.cxtImgView setImage:[UIImage imageNamed:@"cell_img"]];
//    [self.seperateImgView setFrame:CGRectMake(10, TopicCellGap +TopicCellImgheight + 28, ScreenWidth, 1)];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 90, TopicCellImgWith, 16)];
    [_subLabel setFont: [UIFont systemFontOfSize:13]];
    [_subLabel setBackgroundColor:[UIColor clearColor]];
    [_subLabel setNumberOfLines:0];
    [_subLabel setTextColor:[UIColor colorWithRed:255./255 green:244./255 blue:98./255 alpha:1]];
    [self.contentView addSubview:_subLabel];
    
    RbBadgeView *badgeView = [[RbBadgeView alloc] initWithFrame:CGRectMake(TopicCellImgWith -TopicCellGap, TopicCellGap + TopicCellImgheight + 85,16, 16)];
    [badgeView setBadgeString:@""];
    [self.contentView addSubview:badgeView];
    self.badgeView = badgeView;
    RbSafeRelease(badgeView);
    
    [self.seperateImgView setFrame:CGRectMake(0, TopicCellGap + TopicCellImgheight + 110, ScreenWidth, 1)];
    
}

- (void)dealloc
{
    RbSafeRelease(_badgeView);
    RbSafeRelease(_subLabel);
    RbSuperDealoc;
}

@end
