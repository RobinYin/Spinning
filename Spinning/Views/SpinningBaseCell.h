//
//  SpinningBaseCell.h
//  Spinning
//
//  Created by Robin on 8/28/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinningBaseCell : UITableViewCell
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *cxtLabel;
@property (nonatomic, retain) UIImageView *cxtImgView;
@property (nonatomic, retain) UIImageView *seperateImgView;
- (void)configurationCellContent;
@end
