//
//  CheckinHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface CheckinModel :SingleModel
@end
@interface CheckinHttpCmd : SingleHttpCmd
@property (nonatomic, retain) NSString *meetingcode;
@end
