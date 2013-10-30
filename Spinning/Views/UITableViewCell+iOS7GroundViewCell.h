//
//  UITableViewCell+iOS7GroundViewCell.h
//  Spinning
//
//  Created by Robin on 10/30/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (iOS7GroundViewCell)
- (void)groundToCellInTableView:(UITableView *)tableView
                       atIndexPath:(NSIndexPath *)indexPath;
@end
