//
//  RbBadgeView.h
//  TestForBadge
//
//  Created by Robin on 5/17/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    RbBadgeViewAlignmentNormal,
    RbBadgeViewAlignmentTopLeft,
    RbBadgeViewAlignmentTopRight,
    RbBadgeViewAlignmentTopCenter,
    RbBadgeViewAlignmentCenterLeft,
    RbBadgeViewAlignmentCenterRight,
    RbBadgeViewAlignmentBottomLeft,
    RbBadgeViewAlignmentBottomRight,
    RbBadgeViewAlignmentBottomCenter,
    RbBadgeViewAlignmentCenter
} RbBadgeViewAlignment;

@interface RbBadgeView :UIView
{
    @private NSString *_badgeText;
}

@property (nonatomic, copy) NSString *badgeString;

#pragma mark - Customization

@property (nonatomic, assign) RbBadgeViewAlignment badgeAlignment;

@property (nonatomic, retain) UIColor *badgeTextColor;
@property (nonatomic, assign) CGSize badgeTextShadowOffset;
@property (nonatomic, retain) UIColor *badgeTextShadowColor;

@property (nonatomic, retain) UIFont *badgeTextFont;

@property (nonatomic, retain) UIColor *badgeBackgroundColor;

/**
 * @discussion color of the overlay circle at the top. Default is semi-transparent white.
 */
@property (nonatomic, retain) UIColor *badgeOverlayColor;

/**
 * @discussion allows to shift the badge by x and y points.
 */
@property (nonatomic, assign) CGPoint badgePositionAdjustment;

/**
 * @discussion (optional) If not provided, the superview frame is used.
 * You can use this to position the view if you're drawing it using drawRect instead of `-addSubview:`
 */
@property (nonatomic, assign) CGRect frameToPositionInRelationWith;

@end
