//
//  UITableViewCell+iOS7GroundViewCell.m
//  Spinning
//
//  Created by Robin on 10/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "UITableViewCell+iOS7GroundViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableViewCell (iOS7GroundViewCell)
- (void)groundToCellInTableView:(UITableView *)tableView
                    atIndexPath:(NSIndexPath *)indexPath
{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)) {
        CGRect rect = CGRectMake(kGroudCellGap, 0, self.bounds.size.width -10, self.bounds.size.height);
        BOOL isFirstRow = !indexPath.row;
        BOOL isLastRow = (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1);
        BOOL isSingle = [tableView numberOfRowsInSection:indexPath.section] == 1 ?YES :NO;
        CALayer *layer = self.layer;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        if (isSingle) {
            maskLayer.path = [self maskPathTag:3 rect:rect].CGPath;
        }else
        {
            if (isFirstRow) {
                maskLayer.path = [self maskPathTag:1 rect:rect].CGPath;
            }else if(isLastRow)
            {
                maskLayer.path = [self maskPathTag:2 rect:rect].CGPath;
            }
            else
            {
                maskLayer.path = [self maskPathTag:0 rect:rect].CGPath;
            }
        }
        layer.mask = maskLayer;

    }
}

- (UIBezierPath *)maskPathTag:(int) tag rect:(CGRect)rect{
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    
    [maskPath moveToPoint:CGPointMake(rect.origin.x + kGroudCellRadius, 0)];
    
    switch (tag) {
        case 0:
        {
            [maskPath addLineToPoint:CGPointMake(rect.size.width, 0)];
            [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x + 0, rect.size.height)];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x + 0, 0)];
        }
            break;
        case 1:
        {
            [maskPath addLineToPoint:CGPointMake(rect.size.width - kGroudCellRadius, 0)];
            [maskPath addArcWithCenter:CGPointMake(rect.size.width - kGroudCellRadius, kGroudCellRadius) radius:kGroudCellRadius startAngle:M_PI_2 endAngle:0 clockwise:YES];
            [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x +0, rect.size.height)];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x +0, kGroudCellRadius)];
            [maskPath addArcWithCenter:CGPointMake(rect.origin.x +kGroudCellRadius, kGroudCellRadius) radius:kGroudCellRadius startAngle:M_PI endAngle:M_PI_2 clockwise:YES];
            
        }
            break;
        case 2:
        {
            [maskPath addLineToPoint:CGPointMake(rect.size.width, 0)];
            [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height - kGroudCellRadius)];
            [maskPath addArcWithCenter:CGPointMake(rect.size.width - kGroudCellRadius, rect.size.height - kGroudCellRadius) radius:kGroudCellRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x +kGroudCellRadius, rect.size.height)];
            [maskPath addArcWithCenter:CGPointMake(rect.origin.x +kGroudCellRadius, rect.size.height - kGroudCellRadius) radius:kGroudCellRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:YES];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x +0, 0)];
        }
            break;
        case 3:
        {
            [maskPath addLineToPoint:CGPointMake(rect.size.width - kGroudCellRadius, 0)];
            [maskPath addArcWithCenter:CGPointMake(rect.size.width - kGroudCellRadius, kGroudCellRadius) radius:kGroudCellRadius startAngle:M_PI_2 endAngle:0 clockwise:YES];
            [maskPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height - kGroudCellRadius)];
            [maskPath addArcWithCenter:CGPointMake(rect.size.width - kGroudCellRadius, rect.size.height - kGroudCellRadius) radius:kGroudCellRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x +kGroudCellRadius, rect.size.height)];
            [maskPath addArcWithCenter:CGPointMake(rect.origin.x +kGroudCellRadius, rect.size.height - kGroudCellRadius) radius:kGroudCellRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:YES];
            [maskPath addLineToPoint:CGPointMake(rect.origin.x +0, kGroudCellRadius)];
            [maskPath addArcWithCenter:CGPointMake(rect.origin.x +kGroudCellRadius, kGroudCellRadius) radius:kGroudCellRadius startAngle:M_PI endAngle:M_PI_2 clockwise:YES];
        }
            break;
            
        default:
            break;
    }
    [maskPath closePath];
    return maskPath;
}


@end
