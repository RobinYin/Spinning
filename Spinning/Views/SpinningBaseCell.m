//
//  SpinningBaseCell.m
//  Spinning
//
//  Created by Robin on 8/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningBaseCell.h"

@implementation SpinningBaseCell

@synthesize titleLabel = _titleLabel;
@synthesize cxtLabel = _cxtLabel;
@synthesize cxtImgView = _cxtImgView;
@synthesize seperateImgView = _seperateImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self configurationCellContent];
    }
    return self;
}

- (void)configurationCellContent
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont: [UIFont systemFontOfSize:15]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextColor:[UIColor colorWithRed:192./255 green:202./255 blue:110./255 alpha:1]];
    [self.contentView addSubview:_titleLabel];
    
    _cxtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_cxtLabel setFont: [UIFont systemFontOfSize:13]];
    [_cxtLabel setBackgroundColor:[UIColor clearColor]];
    [_cxtLabel setNumberOfLines:0];
    [_cxtLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:_cxtLabel];
    
    _cxtImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_cxtImgView];
    
    _seperateImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
    [_seperateImgView setBackgroundColor:[UIColor whiteColor]];
//    [_seperateImgView setImage:[UIImage imageNamed:@"tab_bg"]];
    [self.contentView addSubview:_seperateImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    RbSafeRelease(_seperateImgView);
    RbSafeRelease(_cxtImgView);
    RbSafeRelease(_cxtLabel);
    RbSafeRelease(_titleLabel);
    RbSuperDealoc;
}
@end

