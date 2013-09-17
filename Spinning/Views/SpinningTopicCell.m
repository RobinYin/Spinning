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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configurationCellContent];
    }
    return self;
}

//http://192.168.66.100:8080/ckiasrv/
- (void)configurationCellContent
{
    [super configurationCellContent];
    [self.titleLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap +TopicCellImgheight + 5 , TopicCellImgWith, 18)];
//    [self.cxtLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 33, TopicCellImgWith, 64)];
    [self.cxtLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 23, TopicCellImgWith, 64)];
    [self.cxtImgView setFrame:CGRectMake(TopicCellGap, TopicCellGap, TopicCellImgWith, TopicCellImgheight)];
    [self.cxtImgView setImage:[UIImage imageNamed:@"img_defaul"]];
//    [self.seperateImgView setFrame:CGRectMake(10, TopicCellGap +TopicCellImgheight + 28, ScreenWidth, 1)];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 90, TopicCellImgWith, 16)];
    [_subLabel setFont: [UIFont systemFontOfSize:13]];
    [_subLabel setBackgroundColor:[UIColor clearColor]];
    [_subLabel setNumberOfLines:0];
    [_subLabel setTextColor:[UIColor colorWithRed:192./255 green:202./255 blue:110./255 alpha:1]];
    [self.contentView addSubview:_subLabel];
    
    [self.seperateImgView setFrame:CGRectMake(10, TopicCellGap + TopicCellImgheight + 110, TopicCellImgWith, 1)];
    
}

- (void)dealloc
{
    RbSafeRelease(_subLabel);
    RbSuperDealoc;
}

@end
