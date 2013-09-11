//
//  SpinningTopicCell.m
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningTopicCell.h"

@implementation SpinningTopicCell

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
    [self.cxtLabel setFrame:CGRectMake(TopicCellGap, TopicCellGap + TopicCellImgheight + 33, TopicCellImgWith, 64)];
    [self.cxtImgView setFrame:CGRectMake(TopicCellGap, TopicCellGap, TopicCellImgWith, TopicCellImgheight)];
    [self.cxtImgView setImage:[UIImage imageNamed:@"img_defaul"]];
    [self.seperateImgView setFrame:CGRectMake(0, TopicCellGap +TopicCellImgheight + 28, ScreenWidth, 1)];
    
}

- (void)dealloc
{
    RbSuperDealoc;
}

@end
