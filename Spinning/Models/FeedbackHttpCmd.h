//
//  FeedbackHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface FeedbackModel :SingleModel
@end

@interface FeedbackHttpCmd : SingleHttpCmd
@property (nonatomic, retain)NSString *suggestion;
@end
