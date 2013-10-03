//
//  SpinningTopicCell.h
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SpinningBaseCell.h"
#import "RbBadgeView.h"
@interface SpinningTopicCell : SpinningBaseCell
@property (nonatomic, retain) UILabel *subLabel;
@property (nonatomic, retain) RbBadgeView *badgeView;
@end
