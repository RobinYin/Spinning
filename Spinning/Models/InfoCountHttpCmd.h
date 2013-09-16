//
//  InfoCountHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/14/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "SingleHttpCmd.h"

@interface InfoCountModel :SingleModel
@property (nonatomic, retain)NSString *notice;
@property (nonatomic, retain)NSString *topic;
@end

@interface InfoCountHttpCmd : SingleHttpCmd
@property (nonatomic, retain) NSString *noticeid;
@property (nonatomic, retain) NSString *topicid;
@end
