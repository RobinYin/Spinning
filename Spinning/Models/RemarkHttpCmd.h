//
//  RemarkHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"
@interface RemarkModel :SingleModel
@end

@interface RemarkHttpCmd : SingleHttpCmd
@property (nonatomic, retain)NSString *suggestion;
@property (nonatomic, retain)NSString *mid;
@end
